" unicodePlugin : A completion plugin for Unicode glyphs
" Author: C.Brabandt <cb@256bit.org>
" Version: 0.22
" Copyright: (c) 2009-2020 by Christian Brabandt
"            The VIM LICENSE applies to unicode.vim, and unicode.txt
"            (see |copyright|) except use "unicode" instead of "Vim".
"            No warranty, express or implied.
"  *** ***   Use At-Your-Own-Risk!   *** ***
" GetLatestVimScripts: 2822 21 :AutoInstall: unicode.vim
" ---------------------------------------------------------------------
" initialize Variables {{{1
let s:unicode_URL  = get(g:, 'Unicode_URL',
        \ 'https://www.unicode.org/Public/UNIDATA/UnicodeData.txt')
if has("nvim")
    " default: ~/.local/share/nvim/site/unicode/
    let s:data_directory =
        \ get(g:, 'Unicode_data_directory', stdpath('data') . '/site/unicode')
    " default: ~/.cache/nvim/unicode/UnicodeData.vim
    let s:cache_directory =
        \ get(g:, 'Unicode_cache_directory', stdpath('cache') . '/unicode')
else
    let s:autoload_directory = expand("<sfile>:p:h")."/unicode"
    let s:data_directory =
        \ get(g:, 'Unicode_data_directory', s:autoload_directory)
    let s:cache_directory =
        \ get(g:, 'Unicode_cache_directory', s:autoload_directory)
endif
let s:data_file = s:data_directory . '/UnicodeData.txt'
let s:data_cache_file = s:cache_directory . '/UnicodeData.vim'
let s:table_cache_file = s:cache_directory . '/UnicodeTable.txt'
let s:use_cache = get(g:, 'Unicode_use_cache', v:true)

" sets the color for the glyph of a unicode character
let s:fuzzy_color = get(g:, 'Unicode_fuzzy_color', 4)

" HTML entitities {{{2
let s:html = unicode#html#get_html_entities()
" Additional Information {{{2
" some additional information for certain characters
let s:info = {}
let s:info[0xfeff] = "(Byte Order Mark: BOM)" "}}}2
" public functions {{{1
fu! unicode#FindDigraphBy(match) abort "{{{2
    return <sid>DigraphsInternal(a:match)
endfu
fu! unicode#FindUnicodeBy(match) abort "{{{2
    return <sid>FindUnicodeByInternal(a:match)
endfu
fu! unicode#Search(match) abort "{{{2
    let uni    = <sid>FindUnicodeByInternal(a:match)
    let format = ["% 4S\t", "U+%04X Dec:%06d\t", ' %s']
    let s:color_pattern = a:match.'\c'
    let cnt = 1
    let s:output_width = 1
    if len(uni) > 1
        echon "\n"
        for item in uni
            let dig  = get(item, 'dig' , '')
            let html = get(item, 'html', '')
            let width=strlen(len(uni))
            call <sid>ScreenOutput(printf("%*i", width, cnt),
                \ printf(format[0], item.glyph),
                \ printf(format[1].format[2], item.dec, item.dec, item.name),
                \ (empty(dig)  ? [] : printf(" %s", dig)),
                \ (empty(html) ? [] : printf(" %s", html)),
                \ (empty(item.info) ? [] : printf(" %s", item.info)))
            let s:output_width = &columns
            let cnt+=1
        endfor
        echon "\n"
        unlet! s:color_pattern
        let input=trim(input('Please choose: '))
        if empty(input)
            return
        elseif input !~? '^\d\+' || input > len(uni)
            echo "\ninvalid number selected, aborting..."
            return ''
        else
            return uni[input-1].dec
        endif
    else
        return uni[0].dec
    endif
endfu
fu! unicode#Digraph(char) abort "{{{2
    let c=split(a:char, '\zs')
    if len(c) > 2 || len(c) < 2
        call <sid>WarningMsg('Need exactly 2 chars for returning digraphs!')
        return ''
    endif
    let s:digraph=''
    " How about a digrpah() function?
    " already sent a patch to Bram
    " exe "sil! norm! :let s.='\<c-k>".a:char1.a:char2."'\<cr>"
    exe 'norm!' ":\<C-k>".c[0].c[1]."\<c-\>eextend(s:, {'digraph': getcmdline()}).digraph\n"
    if s:digraph ==? c[0] || s:digraph ==? c[1]
        return ''
    endif
    return s:digraph
endfu
fu! unicode#UnicodeName(val) abort "{{{2
    return <sid>GetUnicodeName(a:val)
endfu
fu! unicode#Regex(val) abort "{{{2
    if empty(a:val)
        return ''
    endif
    let hexl = strlen(printf("%X", a:val))
    let val=a:val <= 0xFFFF ?
        \ printf('\%%u%*x', hexl, a:val) :
        \ printf('\%%U%*x', hexl, a:val)
    return val
endfu
fu! unicode#Download(force, ...) abort "{{{2
    let silent = a:0 && a:1 == 1

    if (!filereadable(s:data_file) || (getfsize(s:data_file) == 0)) || a:force
        if !a:force
            call s:WarningMsg("File " . s:data_file . " does not exist or is zero.")
        else
            call s:WarningMsg("Updating ". s:data_file)
        endif
        call s:WarningMsg("Let's see, if we can download it.")
        call s:WarningMsg("If this doesn't work, you should download ")
        call s:WarningMsg(s:unicode_URL . " and save it as " . s:data_file)
        let args = ["Download " . s:unicode_URL . " now?", "&Yes\n&No", 1, "Question"]
        if silent
            let choice = 1
        elseif exists(':unsilent') == 2
            unsilent let choice = call('confirm', args)
        else
            let choice = call('confirm', args)
        endif
        if choice ==# 0 || choice ==# 2
            call s:WarningMsg("Not downloading file. You can retry by executing :UnicodeDownload")
            return 0
        endif
        " remove cache file
        " (will be re-created later)
        if s:use_cache
            if filereadable(s:data_cache_file)
                call delete(s:data_cache_file)
            endif
            if filereadable(s:table_cache_file)
                call delete(s:data_cache_file)
            endif
        endif
        if exists(":Nread") || executable('curl')
            if !<sid>MkDir(s:data_directory)
                return 0
            endif
            sp +enew
            " Use the default download method. You can specify a different
            " one, using :let g:netrw_http_cmd="wget"
            exe ":lcd " . s:data_directory
            if exists(':Nread')
                exe "0Nread " . s:unicode_URL
                $d _
                exe ":noa :keepalt :sil w! " . s:data_file
            else
                " best guess :/
                exe "!curl -LO " . s:unicode_URL
            endif
            " Try to verfiy the downloaded file
            " 1) Check size
            if getfsize(s:data_file)==0
                call s:WarningMsg("Error fetching File from ". s:unicode_URL)
                return 0
            endif
            " 2) Call UnicodeDict()
            try
                let cache_var = s:use_cache
                let s:use_cache = 0
                call <sid>UnicodeDict()
            catch
                " Should only happen if the download was corrupted
                call s:WarningMsg("Error loading UnicodeData file from ". s:unicode_URL)
                call s:WarningMsg("Please verify the structure of the file: ". s:data_file)
                return 0
            finally
                let s:use_cache = cache_var
            endtry
            bw
        else
            call s:WarningMsg("NetRw not loaded; cannot download file")
            call s:WarningMsg("Please download " . s:unicode_URL)
            call s:WarningMsg("and save it as " . s:data_file)
            call s:WarningMsg("Quitting")
            return 0
        endif
    endif
    return 1
endfu
fu! unicode#MkCache() abort "{{{2
    if !s:use_cache
        return
    endif
    " Create the cache for existing Unicode Data file
    if !filereadable(s:data_cache_file)
        call <sid>UnicodeDict()
    else
        call <sid>WarningMsg("Cache already exists")
        return
    endif
    if !filereadable(s:data_cache_file) ||
        \ getftime(s:data_cache_file) < getftime(s:data_file) ||
        \ getfsize(s:data_cache_file) < 100 " Unicode Cache Dict should be a lot larger
        call <sid>WarningMsg("Something went wrong when trying to create the cache file")
    else
        call <sid>WarningMsg("Cache successfully created")
    endif
endfu
fu! unicode#Fuzzy() abort "{{{2
    if !exists('*fzf#run') | return s:WarningMsg('fzf is not installed') | endif
    if !exists('s:fuzzy_source') | call s:set_fuzzy_source() | endif
    let s:fzf_using_vim_window = 0
    let s:fzf_cursor_col = col('.')
    augroup FzfUsingVimWindow | au!
        au FileType fzf let s:fzf_using_vim_window = 1
    augroup END
    call fzf#run(fzf#wrap({
        \ 'source': s:fuzzy_source,
        \ 'options': '--ansi --nth=2.. --tiebreak=length,index -m',
        \ 'sink*': function('s:inject_unicode_characters'),
        \ }))
endfu
" internal functions {{{1
fu! unicode#CompleteUnicode() abort "{{{2
    " Completion function for Unicode characters
    let type = {}
    let complete_list={}
    if !exists("s:UniDict")
        let s:UniDict=<sid>UnicodeDict()
    endif
    let line = getline('.')
    let start = col('.') - 1
    while start > 0 && line[start - 1] !~ '\s'
        let start -= 1
    endwhile
    if line[start] =~# 'U' && line[start+1] == '+' && col('.')-1 >=start+2
        let type.numeric=1
    elseif line[start] =~# '&'
        let type.entity=1
    endif
    let base = substitute(line[start : (col('.')-1)], '\s\+$', '', '')
    if empty(base)
        let complete_list = s:UniDict
        echom '(Checking all Unicode Names... this might be slow)'
    else
        if empty(type)
            " name based completion, prefer a match at the start of line
            let complete_list1 = filter(copy(s:UniDict), 'v:val =~? "^".base')
            let complete_list2 = filter(copy(s:UniDict), 'v:val =~? ''\<''.base')
            let complete_list3 = filter(copy(s:UniDict), 'v:val =~? ''\k\@<=''.base')
        elseif get(type, 'numeric', 0)
            " numeric completion
            let complete_list = filter(copy(s:UniDict),
                \ 'printf("%04X", v:key) =~? "^0*".base[2:]')
        elseif get(type, 'entity', 0)
            " html entity list
            let html_list = filter(copy(s:html), 'match(v:val, base) > -1')
            for key in keys(html_list)
                let complete_list[key] = s:UniDict[key]
            endfor
        endif
        echom printf('(Checking Unicode Names for "%s"... this might be slow)', base)
    endif
    if exists("complete_list1")
        let compl = <sid>AddCompleteEntries(complete_list1) + 
                    \ <sid>AddCompleteEntries(complete_list2) + 
                    \ <sid>AddCompleteEntries(complete_list3)
        let compl = uniq(compl)
    else
        let compl = <sid>AddCompleteEntries(complete_list)
    endif
    call complete(start+1, compl)
    return ""
endfu
fu! unicode#CompleteHTMLEntity() abort "{{{2
    let line = getline('.')
    let start = col('.') - 1
    while start > 0 && line[start - 1] !~ '\s'
        let start -= 1
    endwhile
    let base = substitute(line[start : (col('.')-1)], '\s\+$', '', '')
    "let html_entities = map(copy(s:html), 'join(v:val, ''\|'')')
    let complete_list = filter(copy(s:html), 'match(v:val, base) > -1')
    let compl = <sid>AddHTMLCompleteEntries(complete_list, base)
    call complete(start+1, compl)
    return ""
endfu
fu! unicode#CompleteDigraph() abort "{{{2
    " Completion function for digraphs
    let prevchar  = getline('.')[col('.')-2]
    let prevchar1 = getline('.')[col('.')-3]
    if prevchar is? "'"
        let prevchar = "''"
    endif
    if prevchar1 is? "'"
        let prevchar1 = "''"
    endif
    let dlist=values(<sid>GetDigraphDict())
    if !exists("s:UniDict")
        let s:UniDict=<sid>UnicodeDict()
    endif
    if prevchar !~ '\s' && !empty(prevchar)
        let filter1 = printf("match(v:val, '\\C%s%s')>-1",  prevchar1, prevchar)
        let filter2 = printf('match(v:val, ''\\C%s\|%s'')>-1', prevchar1, prevchar)
        let dlist1  = filter(copy(dlist), filter1)
        if empty(dlist1)
            let dlist = filter(dlist, filter2)
            let col=col('.')-1
        else
            let dlist = dlist1
            let col=col('.') - (empty(prevchar1) ? 1 : 2)
        endif
        unlet dlist1
    else
        let col=col('.')
    endif
    let tlist=<sid>AddDigraphCompleteEntries(dlist)
    call complete(col, tlist)
    return ''
endfu
fu! unicode#GetUniChar(...) abort "{{{2
    " Return Unicode Name of Character under cursor
    " :UnicodeName
    if exists("a:1") && !empty(a:1) && (len(a:1)>1 || a:1 !~# '[a-zA-Z0-9+*/]')
        call <sid>WarningMsg("No valid register specified")
        return
    endif
    let type=''
    if exists("a:1") && a:1 == '/'
        let type = 'r'
        let typelist = []
    endif
    if exists("a:2") && !empty(a:2) && a:2 !~? '^\(d\%[igraph]\|r\%[egex]\|n\%[ame]\|h\%[tml]\|v\%[alue]\)$'
        call <sid>WarningMsg("No item (digraph/html/name/regex/value) specified")
        return
    elseif exists("a:2")
        let type=a:2[0]
        let typelist = []
    endif
    if exists("a:3")
        call <sid>WarningMsg("Too many arguments")
        return
    endif

    let msg        = []
    try
        if !exists("s:UniDict")
            let s:UniDict=<sid>UnicodeDict()
            if empty(s:UniDict)
                call add(msg,
                    \ printf("Can't determine char under cursor,".
                    \ "%s not found", s:data_file))
                return
            endif
        endif
        " set locale to english, if possible
        " For versions without gettext, assume it will be English :/
        if has("gettext")
            let lang=v:lang
            if lang isnot# 'C'
                sil lang mess C
            endif
        endif
        " Get char at Cursor, need to use redir, cause we also want
        " to capture combining chars
        let a=execute(':norm! ga')
        let a = substitute(a, '\n', '', 'g')
        " Special case: no character under cursor
        if a == 'NUL'
            call add(msg, "'NUL' U+0000 NULL")
        else
            " Split string, in case cursor was on a combining char
            let pat = 'Oct\(al\)\? \d\+\(, Digr ..\)\?\zs \?'
            let charlen = len(split(a, pat))
            let i       = 0
            for item in split(a, pat)
                let i    += 1
                let glyph = substitute(item, '^<\(<\?[^>]*>\?\)>.*', '\1', '')
                let dec   = substitute(item, '.*>\?> \+\(\d\+\),.*', '\1', '')
                let dig   = <sid>GetDigraphChars(dec)
                let name  = <sid>GetUnicodeName(dec)
                let html  = <sid>GetHtmlEntity(dec, 1)
                let hexl  = strlen(printf("%X", dec))
                let pat   = '/'. unicode#Regex(dec)
                let str   = dec <= 0xFFFF ? printf('"\u%04x"', dec) :
                            \ printf('"\U%*x"', hexl, dec)
                if charlen > 1 && i < charlen
                    let pat .= '\Z'
                endif
                let info  = get(s:info, dec, '')

                let name  .= (empty(name) ? '' : ' ')
                let dig   .= (empty(dig)  ? '' : ' ')
                let html  .= (empty(html) ? '' : ' ')
                let info  .= (empty(info) ? '' : ' ')
                let pat   .= (empty(pat)  ? '' : ' ')
                let str   .= (empty(str)  ? '' : ' ')
                call add(msg, printf("'%s' U+%04X Dec:%d %s%s%s%s%s%s", glyph,
                        \ dec, dec, name, dig, html, info, pat, str))
                if !empty(type)
                    if type==?'v'
                        call add(typelist, dec)
                    elseif type==?'d'
                        " remove () around the digraphs
                        call add(typelist, substitute(dig, '[()]', '', 'g'))
                    elseif type==?'r'
                        " there is a trailing blank in pat
                        call add(typelist, matchstr(pat[1:], '\S\+'))
                    elseif type==?'h'
                        call add(typelist, html)
                    else
                        call add(typelist, name)
                    endif
                endif
            endfor
        endif
        if exists("a:1") && !exists("typelist")
            exe "let @".a:1. "=join(msg)"
        elseif exists("typelist")
            exe "let @".a:1. "=join(typelist)"
        endif
    finally
        let start      = 1
        let s:output_width=1
        if exists('lang') && lang !=# 'C'
            exe "sil lang mess" lang
        endif
        for val in msg
            let list = matchlist(val, '^\(' . "'[^']*'". '\)\(.*\)')
            if len(list) > 3
                call <sid>ScreenOutput(list[1], list[2])
                " force linebreak
                let s:output_width=&columns
                let start = 0
            endif
        endfor
    endtry
endfun
fu! unicode#PrintDigraphs(match, bang) abort "{{{2
    " outputs only first digraph that exists for char
    " makes a difference for e.g. Euro which has (=e Eu)
    let digraphs = <sid>DigraphsInternal(a:match)
    let s:output_width=1

    for item in digraphs
        " remove paranthesis
        let item.dig = substitute(item.dig, '^.\|.$', '', 'g')
        call <sid>ScreenOutput(item.glyph, printf(' %s %s ', item.dig, item.dec))
        if !empty(a:bang)
            " force linebreak
            let s:color_pattern = a:match.'\c'
            call <sid>ScreenOutput(printf(' (%s)', item.name))
            let s:output_width=&columns
        endif
    endfor
    unlet! s:color_pattern
endfu
fu! unicode#PrintUnicode(match, bang) abort "{{{2
    let uni    = <sid>FindUnicodeByInternal(a:match)
    let format = ["% 4S\t", "U+%04X Dec:%06d\t", ' %s']
    let s:color_pattern = a:match.'\c'
    let s:output_width = 1
    let cnt = 1
    for item in uni
        let dig  = get(item, 'dig' , '')
        let html = get(item, 'html', '')
        let width=strlen(len(uni))
        call <sid>ScreenOutput( (a:bang ? printf("%*i", width, cnt) : ''),
                \ printf(format[0], item.glyph),
                \ printf(format[1].format[2], item.dec, item.dec, item.name),
                \ (empty(dig)  ? [] : printf(" %s", dig)),
                \ (empty(html) ? [] : printf(" %s", html)),
                \ (empty(item.info) ? [] : printf(" %s", item.info)))
        let s:output_width = &columns
        let cnt+=1
    endfor
    unlet! s:color_pattern
    if !&l:ro && &l:ma && a:bang
        let input=trim(input('Enter one or more numbers of character(s) to insert: '))
        let result = ''
        let rejected = []
        for num in split(input, '\m\D\+')
            if num <= 0 || num > len(uni)
                call add(rejected,num)
            else
                let result .= uni[num-1].glyph
            endif
        endfor
        if !empty(rejected)
            echo "\ninvalid numbers skipped: " . join(rejected,", ")
        endif
        if !empty(result)
            exe "norm! a". result. "\<esc>"
        endif
    endif
endfu
fu! unicode#GetDigraph(type, ...) abort "{{{2
    " turns a movement or selection into digraphs, each pair of chars
    " will be converted into the belonging digraph, e.g: This line:
    " a:e:o:u:1Sß/\
    " will be converted into:
    " äëöü¹ß×
    let sel_save = &selection
    let &selection = "inclusive"
    let _a = ['a', getreg("a"), getregtype("a")]

    if a:0  " Invoked from Visual mode, use '< and '> marks.
        silent exe "norm! `<" . a:type . '`>"ay'
    elseif a:type == 'line'
        silent exe "norm! '[V']\"ay"
    elseif a:type == 'block'
        silent exe "norm! `[\<C-V>`]\"ay"
    else
        silent exe "normal! `[v`]\"ay"
    endif
 
    let s = ''
    let t = ''
    let chars=split(@a, '\zs')
    while !empty(chars)
        unlet! char0 char1 t
        " need to check the next 2 characters
        for i in range(2)
            let char{i} = remove(chars, 0)
            " ignore space as digraph char
            if char2nr(char{i}) > 126 || char2nr(char{i}) < 20 || char{i} is# ' ' || (empty(chars) && i == 0)
                let s.=char0. (exists("char1") ? char1 : "")
                unlet! char0 char1
                break
            endif
        endfor
        if exists("char0") && exists("char1")
            " How about a digraph() function?
            " e.g. :let s.=digraph(char[0], char[1])
            let t=unicode#Digraph(char0.char1)
            let nr=char2nr(t)
            if nr == 0
                " no digraph with char0 and char1 available
                " try again with the next char
                call insert(chars, char1, 0)
                let s.=char0
                continue
            endif
            if exists("g:Unicode_ConvertDigraphSubset") &&
            \  index(g:Unicode_ConvertDigraphSubset, nr) == -1
                    let s.=char0.char1
            else
                let s.=t
            endif
        endif
    endw

    if s != @a
        " when setting the register, set it to the correct type,
        " do not use ':let @a=s' (this might set it to linewise mode)
        call call("setreg", ['a', s, a:type[0]])
        exe "norm! gv\"ap"
    endif
    let &selection = sel_save
    call call("setreg", _a)
endfu
fu! unicode#PrintUnicodeTable(force) abort "{{{2
    let buffer_name = 'UnicodeTable.txt'
    if s:use_cache && filereadable(s:table_cache_file) && !a:force
        call <sid>FindWindow(buffer_name)
        exe 'noa nos :e' s:table_cache_file
        call <sid>Unitable_Afterload()
        return
    endif
    if !exists("s:UniDict")
        let s:UniDict=<sid>UnicodeDict()
    endif
    let output = [printf("%-7s%-8s%-18s%-57s%s", "Char","Codept","Html", "Name (Digraph)", "Link")]
    for [value,name] in items(s:UniDict) " sort is done later, for performance reasons
        let value  += 0
        let dig     = <sid>GetDigraphChars(value)
        let html    = <sid>GetHtmlEntity(value, 0)
        let codep   = printf('U+%04X', value)
        let name   .= (name[-1:]==?' ' ? '' : ' ') " add trailing whitespace
        let output  += [printf("%-7s%-8s%-18s%-57shttps://unicode-table.com/en/%04X/",
                    \ strtrans(nr2char(value)), codep, html, name.dig, value)]
    endfor
    " Find Window or create a new window
    call <sid>FindWindow(buffer_name)
    " Set up some options 
    setl ma noswapfile buftype=nofile foldcolumn=0 nobuflisted bufhidden=wipe nowrap
    " Just in case
    silent %d _
    call setline(1, output)
    2,$sort x /^.\{,8}U+/
    setl nomodified
    if s:use_cache
        if <sid>MkDir(s:cache_directory)
            call writefile(getline(1,'$'), s:table_cache_file)
        endif
    endif
    call <sid>Unitable_Afterload()
endfu
fu! unicode#MkDigraphNew(arg) abort "{{{2
    " :DigraphNew {char1}{char2}  {pattern}
    " can be used to create a new digraph whose unicode name matches {pattern}.
    let args = matchlist(a:arg, '^\(\S\S\)\s\+\(.\+\S\)\s*$')
    if empty(args)
        echoerr "Usage: DigraphNew {char1}{char2} {Unicode name}"
        return
    endif
    let [ chars, charname ] = args[1:2]
    if charname =~ '^[[:xdigit:]]\+$' && charname+0 < 0xF0000 && charname !~ '^0$'
        " only allow up to private use area
        let value = '0x'. charname
        exe printf(":dig %s %d", chars, value)
        let unichars = unicode#FindUnicodeBy(value)
        if len(unichars) == 1
            let u = unichars[0]
            echo printf('Digraph %s == %s U+%04X %s', chars, u['glyph'], u['dec'], u['name'])
            " unlet s:digdict, so next time :UnicodeName is called, the
            " digraph will be found
            unlet! s:digdict
            return
        endif
    else
        let names = []
        " test for a perl-style short charname
        let short = matchlist(charname, '^\(\S.\{-}\S\)\s*:\s*\(\S.*\S\@<=\)\s*$')
        if empty(short)
            let names = [charname]
        else
            let [thescript, thename] = short[1:2]
            let thecase = thename =~ '\u' ? 'capital' : 'small'
            call add(names, printf('%s %s letter %s', thescript, thecase, thename))
            call add(names, printf('%s letter %s', thescript, thename))
        endif
        call map(names, "substitute(v:val, '\\s\\+', ' ', 'g')")
        for name in names
            let regex = '^' . name
            let unichars = unicode#FindUnicodeBy(regex)
            if len(unichars) == 1
                let u = unichars[0]
                exe printf(":dig %s %d", chars, u['dec'])
                echo printf('Digraph %s == %s U+%04X %s', chars, u['glyph'], u['dec'], u['name'])
                " unlet s:digdict, so next time :UnicodeName is called, the
                " digraph will be found
                unlet! s:digdict
                return
            elseif len(unichars) > 1
                echoerr "Unicode name ambiguous: " . charname. " matches ".join(map(unichars[:], 'string(v:val["name"])'),',')
                return
            endif
        endfor
        echoerr "Unicode name not found: " . charname
    endif
endfu
fu! <sid>Unitable_Afterload() abort "{{{2
    ru syntax/unicode.vim
    call <sid>AirlineStatusline()
    call cursor(1,1)
endfu
fu! <sid>FindWindow(name) abort "{{{2
    " Find Window or create a new window
    let winname = a:name
    let win = bufwinnr('^'.winname.'$')
    if win != -1
        exe 'noa nos ' .win. 'wincmd w'
    else
        exe  'noa nos sp' winname
    endif
endfu
fu! <sid>AddCompleteEntries(dict) abort "{{{2
    " Set Matches for Insert Mode completion of Unicode Characters
    let compl=[]
    let prev_fmt="  Codept\tHTML\t\tName\n%s U+%04X\t%s\t%s"
    let starttime = localtime()
    if 0 && empty(a:type) && !empty(a:base)
        " sort by best match
        " This does not work, would be more efficient,
        " than to do 3 matches against the unicode dicitonary
        let extra = {}
        let extra.base=a:base
        let extra.dict=a:dict
        let list=sort(keys(a:dict), '<sid>CompareListByMatch', extra)
    else
        let list=sort(keys(a:dict), '<sid>CompareListByDec')
    endif
    for value in list
        if value == 0
            continue " Skip NULLs, does not display correctly
        endif
        let name = a:dict[value]
        let html = <sid>GetHtmlEntity(value, 0)
        let dg_char = <sid>GetDigraphChars(value)
        let fstring = printf("U+%04X\t%s%s %s '%s'",
                \ value, name, dg_char, html, nr2char(value))
        if get(g:, 'Unicode_CompleteName',0)
            let dict = {'word':printf("%s (U+%04X)", name, value), 'abbr':fstring}
        else
            let dict = {'word':nr2char(value), 'abbr':fstring}
        endif
        if get(g:,'Unicode_ShowPreviewWindow',0) || &completeopt =~# 'popup'
            call extend(dict, {'info': printf(prev_fmt, nr2char(value), value, html, name)})
        endif
        call add(compl, dict)
        " break too long running search
        if localtime() - starttime > 2
            echohl WarningMsg
            echom "Completing takes too long, stopping now..."
            echohl Normal
            break
        endif
    endfor
    return compl
endfu
fu! <sid>AddDigraphCompleteEntries(list) abort "{{{2
    " Set Matches for Insert Mode completion of Digraphs
    let list = []
    for args in a:list
        for item in args
            let t=matchlist(item, '^\(..\)\s<\?\(..\?\)>\?\s\+\(\d\+\)$')
            let prev_fmt="Abbrev\tGlyph\tCodepoint\tName\n%s\t%s\tU+%04X\t\t%s"
            if !empty(t)
                let name   = <sid>GetUnicodeName(t[3])
                let format = printf("'%s' %s U+%04X %s",t[1], t[2], t[3],name)
                if t[3] == 0 " special case: NULL
                    let t[3] = 10
                endif
                " Dec key will be ignored by complete() function
                call add(list, {'word':nr2char(t[3]), 'abbr':format, 'dec': t[3],
                    \ 'info': printf(prev_fmt, t[1],t[2],t[3],name)})
            endif
        endfor
    endfor
    return sort(list, '<sid>CompareByDecimalKey')
endfu
fu! <sid>AddHTMLCompleteEntries(list, base) abort "{{{2
    " Set Matches for Insert Mode completion of HTML entries
    let list = []
    for value in sort(keys(a:list), '<sid>CompareListByDec')
        let prev_fmt="Entity\tGlyph\tCodepoint\tName\n%s\t%s\t\tU+%04X\t\t%s"
        let name   = <sid>GetUnicodeName(value)
        let index = match(a:list[value], a:base)
        let entity = a:list[value][index]
        let glyph = nr2char(value+0)
        let format = printf("'%s'\t%s U+%04X (%s)", glyph, entity, value, name)
        " Dec key will be ignored by complete() function
        call add(list, {'word':entity, 'abbr':format, 'dec': value+0,
            \ 'info': printf(prev_fmt, entity, glyph, value, name)})
    endfor
    return list
endfu
fu! <sid>Print(fmt, ...) abort "{{{2
    if &verbose
        echomsg call('printf', [a:fmt] + a:000)
    endif
endfu
fu! <sid>DigraphsInternal(match) abort "{{{2
    " Returns a list of digraphs matching a:match
    let outlist = []
    let digit = a:match + 0
    let match = a:match
    let name = ''
    let unidict = {}
    let cnt = 0
    let did_verbose = 0
    if len(a:match) == 1
        " special case for single character: treat regex as very nomagic
        let match = '\V\C'.escape(a:match, '\')
    elseif (len(a:match) > 1 && digit == 0)
        " try to match digest name from unicode name
        if !exists("s:UniDict")
            let s:UniDict = <sid>UnicodeDict()
        endif
        let name    = match
        let unidict = filter(copy(s:UniDict), 'v:val =~? name')
    endif
    let res = <sid>GetDigraphDict()
    if &verbose
        call <sid>Print("Processing %0d digraphs", len(values(res)))
    endif
    for dig in values(res)
        let cnt += 1
        if (cnt%100 == 0 && &verbose)
            call <sid>Print("Processing item %*d", len(printf("%s", len(res))), cnt)
            let did_verbose=1
        endif
        " display digraphs that match value
        " could be a list of 1 or 2 matchings chars,
        " e.g.
        " {'8364': ['=e € 8364','Eu € 8364']}
        if match(dig, match) == -1  && digit == 0 && empty(unidict)
            continue
        endif
        " digraph: xy Z \d\+
        " (x and y are the letters to create the digraph)
        let item = matchlist(dig[0],
            \ '\(..\)\s\(\%(\s\s\)\|.\{,4\}\)\s\+\(\d\+\)$')
        " if digit matches, we only want to display digraphs matching the
        " decimal values
        if (digit > 0 && (item[3]+0) != digit) ||
            \ (!empty(name) && !empty(unidict) && !has_key(unidict, item[3]))
            continue
        endif

        " add trailing  space for item[2] if there isn't one
        " (e.g. needed for digraph 132)
        if item[2][:-1] !=# ' ' || item[3] == 32
            let item[2].= ' '
        endif

        let dict       = {}
        " Space is different
        let dict.glyph = item[3] != 32 ? matchstr(item[2],'\s\?\S*\ze\s*$') : '  '
        let dict.dig   = <sid>GetDigraphChars(item[3])
        let dict.dec   = item[3]
        let dict.hex   = printf("0x%02X", item[3])
        let dict.name  = <sid>GetUnicodeName(item[3])
        call add(outlist, dict)
    endfor
    if did_verbose
        echomsg ""
    endif
    return sort(outlist, '<sid>CompareByDecimalKey')
endfu
fu! <sid>FindUnicodeByInternal(match) abort "{{{2
    " Returns a list of Unicode Characters matching a:match
    " Match is assumed nonempty.
    " If match matches '\d\+', returns the codepoint with that decimal value.
    " If match matches 'U+\x\', returns the codepoint with that hex value.
    " Otherwise, case-insensitively searches for match in the codepoint name.
    if len(a:match) == 0
        echoerr "Argument is empty or unspecified"
        return []
    endif
    let unidict = {}
    let output = []
    if !exists("s:UniDict")
        let s:UniDict = <sid>UnicodeDict()
    endif
    " If the input is not a literal codepoint
    if match(a:match, '^\(\d\+\|U+\x\+\)$') == -1
        " try to match digest name from unicode name
        let name = a:match
        let unidict = filter(copy(s:UniDict), 'v:val =~? name')
    else
        if a:match[0:1] == 'U+'
            let digit = str2nr(a:match[2:], 16)
        else
            let digit = str2nr(a:match, 10)
        endif
        " filter for decimal value
        let unidict = filter(copy(s:UniDict), 'v:key == digit')
    endif
    for decimal in keys(unidict)
        " Try to get digraph char
        let dchar=<sid>GetDigraphChars(decimal)
        " Get html entity
        let html          = <sid>GetHtmlEntity(decimal, 1)
        let dict          = {}
        let dict.name     = s:UniDict[decimal]
        let dict.glyph    = nr2char(decimal)
        let dict.dec      = decimal
        let dict.hex      = printf("0x%02X", decimal)
        let dict.info     = get(s:info, decimal, '')
        if !empty(dchar)
            let dict.dig  = dchar
        endif
        if !empty(html)
            let dict.html = html
        endif
        call add(output, dict)
    endfor
    return sort(output, '<sid>CompareByDecimalKey')
endfu
fu! <sid>Screenwidth(item) abort "{{{2
    " Takes string arguments and calculates the width
    if exists("*strdisplaywidth")
        return strdisplaywidth(a:item)
    else
        " older vim doesn't have strdisplaywidth function
        " return number of chars (which might be wrong 
        " for double width chars...)
        " TODO: Remove once Vim 8.1 has been released
        return len(split(a:item, '\zs'))
    endif
endfu
fu! <sid>GetDigraphChars(code) abort "{{{2
    " Return digraph for given decimal value
    if !exists("s:digdict")
        call <sid>GetDigraphDict()
    endif
    if !has_key(s:digdict, a:code)
        return ''
    endif
    let list=map(deepcopy(get(s:digdict, a:code, [])), 'v:val[0:1]')
    " TODO: remove exists("*uniq") check, once Vim 8.1 has been released
    if exists("*uniq") && !empty(list)
        let list=uniq(list)
    endif
    return (empty(list) ? '' : '('. join(list). ')')
endfu
fu! <sid>UnicodeDict() abort "{{{2
    let dict={}
    " make sure unicodedata.txt is found
    if <sid>CheckDir()
        if s:use_cache &&
            \ filereadable(s:data_cache_file) &&
            \ getftime(s:data_cache_file) >= getftime(s:data_file) &&
            \ getfsize(s:data_cache_file) > 100 " Unicode Cache Dict should be a lot larger
            exe "source" s:data_cache_file
            let dict=g:unicode#unicode#data
            unlet! g:unicode#unicode#data
        else
            let list=readfile(s:data_file)
            let ind = []
            for glyph in list
                let val          = split(glyph, ";")
                let Name         = val[1]
                " Field 3 is General Category Field as defined in https://www.unicode.org/reports/tr44
                if val[2] !=? ''
                    let Name     .=  ' ('. val[2]. ')'
                endif
                let OldName      = val[10] " Unicode_1_Name field (10)
                if Name[0] ==? '<' && OldName !=? ''
                    let Name = split(OldName, '(')[0]
                endif
                if Name[-1:] ==# ' '
                    let Name = substitute(Name, ' *$', '', '')
                endif
                let dec = ('0x'.val[0])+0 " faster than str2nr()
                let dict[dec]   = Name
                let ind += [dec] " faster than add
            endfor
            call <sid>UnicodeWriteCache(dict, ind)
        endif
    endif
    return dict
endfu
fu! <sid>CheckDir() abort "{{{2
    if !<sid>MkDir(s:data_directory)
        return 0
    endif
    return unicode#Download(0)
endfu
fu! <sid>MkDir(dir) abort "{{{2
    try
        if (!isdirectory(a:dir))
            call mkdir(a:dir, 'p')
        endif
    catch
        call s:WarningMsg("Error creating Directory: " . a:dir)
        return 0
    endtry
    return 1
endfu
fu! <sid>GetDigraphDict() abort "{{{2
    " returns a dict of digraphs 
    " as output by :digraphs
    if exists("s:digdict") && !empty(s:digdict)
        return s:digdict
    else
        let digraphs = execute('digraphs')
        " Because of the redir, the next message might not be
        " displayed correctly. So force a redraw now.
        redraw!
        let s:digdict={}
        let dlist=[]
        let dlist=map(split(substitute(digraphs, "\n", ' ', 'g'),
            \ '..\s<\?.\{1,2\}>\?\s\+\d\{1,5\}\zs'),
            \ 'substitute(v:val, "^\\s\\+", "", "")')
        " special case: digraph 57344: starts with 2 spaces
        let idx=match(dlist, '57344$')
        if idx > -1
            let dlist[idx]='   '.dlist[idx]
        endif
        for val in dlist
            let dec=matchstr(val, '\d\+$')+0
            if dec == 10 && val[0:1] ==? 'NU' " Decimal 10 is actually ASCII NUL (0)
                let val = substitute(val, '10', '0', '')
                let dec = 0
            endif
            let dig=get(s:digdict, dec, [])
            let s:digdict[dec] = (empty(dig) ? [val] : s:digdict[dec] + [val])
        endfor
        return s:digdict
    endif
endfu
fu! <sid>CompareByDecimalKey(d1, d2) abort "{{{2
    " Sort function, Sorts dics d1 and d2 by 'dec' key
    return <sid>CompareByValue(a:d1['dec']+0, a:d2['dec']+0)
endfu
fu! <sid>CompareListByMatch(l1, l2) dict abort "{{{2
    " Not used, because it does not work what I'd like to have it done ....
    let pat=self.base
    let val1 = self.dict[a:l1]
    let val2 = self.dict[a:l2]
    if val1 =~? '^'.pat
        if val2 =~? '^'.pat
            return 0
        else
            return 1
        endif
    elseif val1 =~? '\<'. pat
        if val2 =~? '^'. pat
            return -1
        elseif val2 =~? '\<'.pat
            return 0
        else
            return 1
        endif
    elseif val2 =~? '^'.pat
        return -1
    elseif val2 =~? '\<'. pat
        return -1
    else
        return <sid>CompareListByDec(a:l1, a:l2)
    endif
endfu
fu! <sid>CompareListByDec(l1, l2) abort "{{{2
    " Sort function, Sorts l1 and ls by its numeric values
    return <sid>CompareByValue(a:l1+0,a:l2+0)
endfu
fu! <sid>CompareByValue(v1, v2) abort "{{{2
    return (a:v1 == a:v2 ? 0 : (a:v1 > a:v2 ? 1 : -1))
endfu
fu! <sid>ScreenOutput(...) abort "{{{2
    let list=filter(copy(a:000), '!empty(v:val)')
    let i=0
    let width = eval(join(map(copy(list), '<sid>Screenwidth(v:val)'), '+'))
    if s:output_width + width >= &columns
        echon "\n"
        let s:output_width = width+1
    else
        let s:output_width += width
    endif
    for value in list
        exe "echohl ". (i ? "Normal" : "Title")
        if exists("s:color_pattern")
            let start = match(value, s:color_pattern)
            let end   = matchend(value, s:color_pattern)
            echon strpart(value, 0, start)
            echohl WarningMsg
            echon strpart(value, start, end-start)
            exe "echohl ". (i ? "Normal" : "Title")
            echon strpart(value, end)
        else
            echon value
        endif
        let i+=1
    endfor
    echohl NONE
endfu
fu! <sid>WarningMsg(msg) abort "{{{2
    echohl WarningMsg
    let msg = "UnicodePlugin: " . a:msg
    if exists(":unsilent") == 2
        unsilent echomsg msg
    else
        echomsg msg
    endif
    echohl Normal
endfun
fu! <sid>GetHtmlEntity(hex, all) abort "{{{2
    let list = get(s:html, a:hex, [])
    let html = a:all ? join(list, ' ') : get(list, 0, '')
    if empty(html) && (a:hex > 31 ||
        \ a:hex == 9 || a:hex == 10 || a:hex == 13) &&
        \ (a:hex < 127 || a:hex > 159) &&
        \ (a:hex < 55296 || a:hex > 57343)
        " Generate HTML Code only for where it is allowed (see wikipedia)
        let html=printf("&#x%X;", a:hex)
    endif
    return html
endfu
fu! <sid>UnicodeWriteCache(data, ind) abort "{{{2
    if !s:use_cache
        return
    endif
    if !<sid>MkDir(s:cache_directory)
        return
    endif
    " Take unicode dictionary and write it in VimL form
    " so it will be faster to load
    let list = ['" internal cache file for unicode.vim plugin',
        \ '" this file can safely be removed, it will be recreated if needed',
        \ '',
        \ 'let unicode#unicode#data = {}']
    let format = "let unicode#unicode#data[0x%04X] = '%s'"
    let list += map(copy(a:ind), 'printf(format, v:val, a:data[v:val])')
    call writefile(list, s:data_cache_file)
    unlet! list
endfu
fu! <sid>GetUnicodeName(dec) abort "{{{2
    " returns Unicodename for decimal value
    if !exists("s:UniDict")
        let s:UniDict=<sid>UnicodeDict()
    endif
    let name = get(s:UniDict, a:dec, '')
    if !empty(name)
        return name
    endif
    " CJK Unigraphs start at U+4E00 and go until U+9FFF
    if a:dec >= 0x3400 && a:dec <=0x4DB5
        return "Ideograph Extension A"
    elseif a:dec >= 0x4E00 && a:dec <= 0x9FFF
        return "CJK Ideograph"
    elseif a:dec >= 0xAC00 && a:dec <= 0xD7AF
        return "Hangul Syllable"
    elseif a:dec >= 0xD800 && a:dec <= 0xDB7F
        return "Non-Private Use High Surrogates"
    elseif a:dec >= 0xDB80 && a:dec <= 0xDBFF
        return "Private Use High Surrogates"
    elseif a:dec >= 0xDC00 && a:dec <= 0xDFFF
        return "Low Surrogates"
    elseif a:dec >= 0xE000 && a:dec <= 0xF8FF
        return "Private Use Zone"
    elseif a:dec >= 0xFDD0 && a:dec <= 0xFDEF
        return "<No Character>"
    elseif a:dec == 0xFFFE
        return "<No Character (BOM)>"
    elseif a:dec == 0xFFFF
        return "<No Character>"
    elseif a:dec >= 0x17000 && a:dec <= 0x187EC
        return "Tangut Ideograph",
    elseif a:dec >= 0x1FFFE && a:dec <= 0x1FFFF
        return "<No Character>"
    elseif a:dec >= 0x20000 && a:dec <= 0x2A6D6
        return "Ideograph Extension B"
    elseif a:dec >= 0x2FFFE && a:dec <= 0x2FFFF
        return "<No Character>"
    elseif a:dec >= 0x2A700 && a:dec <= 0x2B73F
        return "Ideograph Extension C"
    elseif a:dec >= 0x3FFFE && a:dec <= 0x3FFFF
        return "<No Character>"
    elseif a:dec >= 0x4FFFE && a:dec <= 0x4FFFF
        return "<No Character>"
    elseif a:dec >= 0x5FFFE && a:dec <= 0x5FFFF
        return "<No Character>"
    elseif a:dec >= 0x6FFFE && a:dec <= 0x6FFFF
        return "<No Character>"
    elseif a:dec >= 0x7FFFE && a:dec <= 0x7FFFF
        return "<No Character>"
    elseif a:dec >= 0x8FFFE && a:dec <= 0x8FFFF
        return "<No Character>"
    elseif a:dec >= 0x9FFFE && a:dec <= 0x9FFFF
        return "<No Character>"
    elseif a:dec >= 0xAFFFE && a:dec <= 0xAFFFF
        return "<No Character>"
    elseif a:dec >= 0xBFFFE && a:dec <= 0xBFFFF
        return "<No Character>"
    elseif a:dec >= 0xCFFFE && a:dec <= 0xCFFFF
        return "<No Character>"
    elseif a:dec >= 0xDFFFE && a:dec <= 0xDFFFF
        return "<No Character>"
    elseif a:dec >= 0xEFFFE && a:dec <= 0xEFFFF
        return "<No Character>"
    elseif a:dec >= 0xF0000 && a:dec <= 0xFFFFD
        return "Character from Plane 15 for private use"
    elseif a:dec >= 0xFFFFE && a:dec <= 0xFFFFF
        return "<No Character>"
    elseif a:dec >= 0x100000 && a:dec <= 0x10FFFD
        return "Character from Plane 16 for private use"
    elseif a:dec >= 0x10FFFE && a:dec <= 0x10FFFF
        return "<No Character>"
    else
        return "Character not found"
    endif
endfu
fu! <sid>AirlineStatusline() abort "{{{2
    if exists(":AirlineRefresh")
        AirlineRefresh
    endif
endfunction
fu! <sid>translate(lists) abort "{{{2
    for list in a:lists
        let list[0] = eval('"\U' . printf('%x', list[0]) . '"')
    endfor
    return a:lists
endfu
fu! <sid>inject_unicode_characters(lines) abort "{{{2
    let chars = ''
    try
        for line in a:lines
            try
                let chars .= matchstr(line, '^.')
            catch /^Vim:Interrupt$/
                break
            endtry
        endfor
    finally
        if s:fzf_using_vim_window
            call feedkeys((s:fzf_cursor_col < col('$') ? 'i' : 'A') . chars, 'n')
        else
            call feedkeys(chars, 'n')
        endif
        au! FzfUsingVimWindow
        augroup! FzfUsingVimWindow
    endtry
endfu
fu! <sid>set_fuzzy_source() abort "{{{2
    if !filereadable(s:data_cache_file) | exe 'UnicodeCache' | endif
    if !filereadable(s:data_cache_file)
        let s:fuzzy_source = []
        return s:WarningMsg('Failed to create the cache file')
    endif
    exe 'source ' . s:data_cache_file
    let s:fuzzy_source = s:translate(items(deepcopy(g:unicode#unicode#data)))
    call map(s:fuzzy_source, '"\x1b[38;5;" . s:fuzzy_color . "m" . v:val[0] . "\x1b[0m\t" . v:val[1]')
endfu
" Modeline "{{{1
" vim: ts=4 sts=4 fdm=marker com+=l\:\" fdl=0 et
