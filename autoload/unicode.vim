" unicodePlugin : A completion plugin for Unicode glyphs
" Author: C.Brabandt <cb@256bit.org>
" Version: 0.10
" Copyright: (c) 2009 by Christian Brabandt
"            The VIM LICENSE applies to unicode.vim, and unicode.txt
"            (see |copyright|) except use "unicode" instead of "Vim".
"            No warranty, express or implied.
"  *** ***   Use At-Your-Own-Risk!   *** ***
"
" GetLatestVimScripts: 2822 10 :AutoInstall: unicode.vim

" ---------------------------------------------------------------------


if exists("g:unicode_URL")
    let s:unicode_URL=g:unicode_URL
else
    "let s:unicode_URL='http://www.unicode.org/Public/UNIDATA/Index.txt'
    let s:unicode_URL='http://www.unicode.org/Public/UNIDATA/UnicodeData.txt'
endif


let s:file=matchstr(s:unicode_URL, '[^/]*$')

let s:directory  = expand("<sfile>:p:h")."/unicode"
let s:UniFile    = s:directory . '/UnicodeData.txt'

fun! <sid>WarningMsg(msg)"{{{1
        echohl WarningMsg
        let msg = "UnicodePlugin: " . a:msg
        if exists(":unsilent") == 2
                unsilent echomsg msg
        else
                echomsg msg
        endif
        echohl Normal
endfun

fu! unicode#CheckUniFile(force) "{{{1
    if (!filereadable(s:UniFile) || (getfsize(s:UniFile) == 0)) || a:force
		call s:WarningMsg("File " . s:UniFile . " does not exist or is zero.")
		call s:WarningMsg("Let's see, if we can download it.")
		call s:WarningMsg("If this doesn't work, you should download ")
		call s:WarningMsg(s:unicode_URL . " and save it as " . s:UniFile)
		sleep 10
		if exists(":Nread")
			sp +enew
			" Use the default download method. You can specify a different one,
			" using :let g:netrw_http_cmd="wget"
			exe ":lcd " . s:directory
			exe "0Nread " . s:unicode_URL
			$d _
			exe ":w!" . s:UniFile
			if getfsize(s:UniFile)==0
				call s:WarningMsg("Error fetching Unicode File from " . s:unicode_URL)
				return 0
			endif
			bw
		else
			call s:WarningMsg("Please download " . s:unicode_URL)
			call s:WarningMsg("and save it as " . s:UniFile)
			call s:WarningMsg("Quitting")
			return 0
		endif
    endif
    return 1
endfu

fu! unicode#CheckDir() "{{{1
    try
		if (!isdirectory(s:directory))
			call mkdir(s:directory)
		endif
    catch
		call s:WarningMsg("Error creating Directory: " . s:directory)
		return 0
    endtry
    return unicode#CheckUniFile(0)
endfu

fu! unicode#UnicodeDict() "{{{1
    let dict={}
    let list=readfile(s:UniFile)
    for glyph in list
		let val          = split(glyph, ";")
		let U1Name       = val[10]
		let U1Name       = (!empty(U1Name)?' ('.U1Name.')':'')
		let Name         = val[1]
        let dict[Name]   = str2nr(val[0],16)
    endfor
"    let dict=filter(dict, 'v:key !~ "Control Code"')
    return dict
endfu

fu! unicode#CompleteUnicode(findstart,base) "{{{1
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
		let complete_list = filter(copy(s:UniDict), 'printf("%04X", v:val) =~? "^0*".a:base[2:]')
    else
		let complete_list = filter(copy(s:UniDict), 'v:key =~? a:base')
    endif
    for [key, value] in sort(items(complete_list), "unicode#CompareList")
    	"let key=matchstr(key, "^[^0-9 ]*")
		let dg_char=unicode#GetDigraphChars(value)
        if s:showDigraphCode
			if !empty(dg_char)
				let fstring=printf("U+%04X %s (%s):'%s'", value, key, dg_char, nr2char(value))
			else
			let fstring=printf("U+%04X %s:%s", value, key, nr2char(value))
			endif
		else
			let fstring=printf("U+%04X %s:'%s'", value, key, nr2char(value))
		endif
		let istring=printf("U+%04X %s%s:'%s'", value, key, empty(dg_char) ? '' : '('.dg_char.')', nr2char(value))
	    
		if s:unicode_complete_name
			call complete_add({'word':key, 'abbr':fstring, 'info': istring})
		else
			call complete_add({'word':nr2char(value), 'abbr':fstring, 'info': istring})
		endif
		if complete_check()
			break
		endif
    endfor
    	
    return {}
  endif
endfu

fu! unicode#GetDigraph() "{{{1
    redir => digraphs
		silent digraphs
    redir END
    let dlist=[]
    let dlist=map(split(substitute(digraphs, "\n", ' ', 'g'), '..\s<\?.\{1,2\}>\?\s\+\d\{1,5\}\zs'), 'substitute(v:val, "^\\s\\+", "", "")')
    " special case: digraph 57344: starts with 2 spaces
    "return filter(dlist, 'v:val =~ "57344$"')
    let idx=match(dlist, '57344$')
    let dlist[idx]='   '.dlist[idx]

    return dlist
endfu

fu! unicode#GetDigraphChars(code) "{{{1
    let dlist = unicode#GetDigraph()
    let ddict = {}
    for digraph in dlist
		let key=matchstr(digraph, '\d\+$')+0
		let val=split(digraph)
		let ddict[key] = val[0]
    endfor
    return get(ddict, a:code, '')
endfu

fu! unicode#CompleteDigraph() "{{{1
   let prevchar=getline('.')[col('.')-2]
   let dlist=unicode#GetDigraph()
   if prevchar !~ '\s' && !empty(prevchar)
       let dlist=filter(dlist, 'v:val =~ "^".prevchar')
       let col=col('.')-1
   else
       let col=col('.')
   endif
   let tlist=[]
   for args in dlist
       let t=matchlist(args, '^\(..\)\s<\?\(..\?\)>\?\s\+\(\d\+\)$')
       "echo args
       "if !empty(t)
	   let format=printf("'%s' %s U+%04X",t[1], t[2], t[3])
	   call add(tlist, {'word':nr2char(t[3]), 'abbr':format,
				   \'info': printf("Abbrev\tGlyph\tCodepoint\n%s\t%s\tU+%04X",t[1],t[2],t[3])})
       "endif
   endfor
   call complete(col, tlist)
   return ''
endfu

fu! unicode#CompareList(l1, l2) "{{{1
    return a:l1[1] == a:l2[1] ? 0 : a:l1[1] > a:l2[1] ? 1 : -1
endfu

fu! unicode#SwapCompletion() "{{{1
	if !exists('s:unicode_complete_name')
		let s:unicode_complete_name = 1
	endif
	if exists('g:unicode_complete_name')
		let s:unicode_complete_name = g:unicode_complete_name
	else
		let s:unicode_complete_name = !s:unicode_complete_name
	endif
	echo "Unicode Completion Names " .
		\ (s:unicode_complete_name ? 'ON':'OFF')
endfu

fu! unicode#Init(enable) "{{{1
	if !exists("s:unicode_complete_name")
		let s:unicode_complete_name = 0
	endif
    if a:enable
		let b:oldfunc=&l:cfu
		if (unicode#CheckDir())
			let s:UniDict = unicode#UnicodeDict()
			setl completefunc=unicode#CompleteUnicode
			set completeopt+=menuone
			inoremap <C-X><C-G> <C-R>=unicode#CompleteDigraph()<CR>
			nnoremap <leader>un :call unicode#SwapCompletion()<CR>
		endif
    else
		if !empty(b:oldfunc)
			let &l:cfu=b:oldfunc
		else
			setl completefunc=
		endif
		unlet s:UniDict
		nunmap <leader>un
		iunmap <C-X><C-G>
    endif
	echo "Unicode Completion " . (a:enable?'ON':'OFF')
endfu

fu <sid>OutputMessage(msg) " {{{1
	echohl Title
	echo a:msg
	echohl Normal
endfu

fu! unicode#GetUniChar() "{{{1
	if (unicode#CheckDir())
		if !exists("s:UniDict")
			let s:UniDict=unicode#UnicodeDict()
		endif

		" Get glyph at Cursor
		" need to use redir, cause we also want to capture combining chars
		redir => a | exe "silent norm! ga" | redir end 
		let a = substitute(a, '\n', '', 'g')
		" Special case: no character under cursor
        if a == 'NUL'
			call <sid>OutputMessage("No character under cursor!")
			return
		endif
		" Split string, in case cursor was on a combining char
		for item in split(a, 'Octal \d\+\zs \?')

			let glyph = substitute(item, '^<\(<\?[^>]*>\?\)>.*', '\1', '')
			let dec   = substitute(item, '^[^>]*>\?> \+\(\d\+\),.*', '\1', '')
			" Check for control char (has no name)
			if dec <= 0x1F || ( dec >= 0x7F && dec <= 0x9F)
				call <sid>OutputMessage(printf("'%s' U+%04X <Control Char>", glyph, dec))
			" CJK Unigraphs start at U+4E00 and go until U+9FFF
			elseif dec >= 0x4E00 && dec <= 0x9FFF
				call <sid>OutputMessage(
					\printf("'%s' U+%04X CJK Ideograph", glyph, dec))
			else
				for [key, value] in items(s:UniDict)
					if value == dec
						call <sid>OutputMessage(
							\printf("'%s' U+%04X %s", glyph, value, key))
						break
					endif
				endfor
			endif
		endfor
	else
		call <sid>WarningMsg("Can't determine char under cursor!")
	endif
endfun

" Modeline "{{{1
" vim: ts=4 sts=4 fdm=marker com+=l\:\" fdl=0
