" Unicode Completion Script for Vim

if exists("g:unicode_URL")
    let s:unicode_URL=g:unicode_URL
else
    let s:unicode_URL='http://www.unicode.org/Public/UNIDATA/Index.txt'
endif


let s:file=matchstr(s:unicode_URL, '[^/]*$')

let s:directory  = expand("<sfile>:p:h")."/unicode"
let s:UniFile    = s:directory . '/Index.txt'

let s:debug = 0

fu! unicode#CheckUniFile(force)
    if !filereadable(s:UniFile) || a:force
	if exists(":Nread")
	    try
		sp +enew
		"It seems like when netrw uses elinks, the file is downloaded 
		"corrupted. Therefore download Index.txt using wget
		exe ":lcd " . s:directory
		let g:netrw_http_cmd="wget"
		exe "0Nread " . s:unicode_URL
	    catch
		echoerr "Error fetching Unicode File from " . s:unicode_URL
		return 0
	    endtry
	    $d
	    exe ":w!" . s:UniFile
	    bw
	else
	    echoerr "Please download " . s:unicode_URL
	    echoerr "and save it as " . s:UniFile
	    echoerr "Quitting"
	    return 0
	endif
    endif
    return 1
endfu

fu! unicode#CheckDir()
    if (!isdirectory(s:directory))
	try
	    call mkdir(s:directory)
	catch
	    echoer "Error creating Directory: " . s:directory
	    return 0
	endtry
    endif
    return unicode#CheckUniFile(0)
endfu

fu! unicode#UnicodeDict()
    let dict={}
    let list=readfile(s:UniFile)
    for glyph in list
	let val=split(glyph, "\t")
        let dict[substitute(glyph, "\t", ' ', '')] = str2nr(val[1],16)
    endfor
"    let dict=filter(dict, 'v:key !~ "Control Code"')
    return dict
endfu

fu! unicode#CompleteDigraph(findstart,base)
  if !exists("s:numeric")
      let s:numeric=0
  endif
  if a:findstart
    let line = getline('.')
    let start = col('.') - 1
    while start > 0 && line[start - 1] =~ '\w\|+'
      let start -= 1
    endwhile
    if line[start] =~# 'U' && line[start+1] == '+' && col('.')-1 >=start+2
	let s:numeric=1
    else
	let s:numeric=0
    endif
    return start
  else
    if exists("g:showDigraphCode")
	let s:showDigraphCode=g:showDigraphCode
    else
	let s:showDigraphCode = 0
    endif
    "let glyphs=unicode#UnicodeDict()
    if s:numeric
	let complete_list = filter(copy(s:UniDict), 'printf("%06X", v:val) =~? "^0*".a:base[2:]')
    else
	let complete_list = filter(copy(s:UniDict), 'v:key =~? "^".a:base')
    endif
    for [key, value] in sort(items(complete_list), "unicode#CompareList")
    	let key=matchstr(key, "^[^0-9]*")
        if s:showDigraphCode
	    let dg_char=unicode#GetDigraphChars(value)
	    if !empty(dg_char)
		let fstring=printf("U+%06X %s (%s):%s", value, key, dg_char, nr2char(value))
	    else
		let fstring=printf("U+%06X %s:%s", value, key, nr2char(value))
	    endif
	else
	    let fstring=printf("U+%06X %s:%s", value, key, nr2char(value))
	endif
	    
    	call complete_add({'word':nr2char(value), 'abbr':fstring})
	if complete_check()
	  break
	endif
    endfor
    	
    return {}
  endif
endfu

fu! unicode#GetDigraphChars(code)
    redir => digraphs
    silent digraphs
    redir END
    let dlist = split(substitute(digraphs, "\n", '', 'g'), '..\s.\{1,2\}\s\+\d\+\zs')
    let ddict = {}
    for digraph in dlist
	let key=matchstr(digraph, '\d\+$')+0
	let val=split(digraph)
	"let key=val[2]+0
	let ddict[key] = val[0]
    endfor
    return get(ddict, a:code, '')
endfu



fu! unicode#CompareList(l1, l2)
    return a:l1[1] == a:l2[1] ? 0 : a:l1[1] > a:l2[1] ? 1 : -1
endfu


fu! unicode#Init(enable)
    if a:enable
	let b:oldfunc=&l:cfu
	if (unicode#CheckDir())
	    let s:UniDict = unicode#UnicodeDict()
	    setl completefunc=unicode#CompleteDigraph
	    set completeopt+=menuone
	    echo "Unicode Completion " . (a:enable?'ON':'OFF')
	endif

    else
	if !empty(b:oldfunc)
	    let &l:cfu=b:oldfunc
	endif
	unlet s:UniDict
	echo "Unicode Completion " . (a:enable?'ON':'OFF')
    endif
endfu

    
