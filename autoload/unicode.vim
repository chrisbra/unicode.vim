" unicodePlugin : A completion plugin for Unicode glyphs
" Author: C.Brabandt <cb@256bit.org>
" Version: 0.18
" Copyright: (c) 2009-2014 by Christian Brabandt
"            The VIM LICENSE applies to unicode.vim, and unicode.txt
"            (see |copyright|) except use "unicode" instead of "Vim".
"            No warranty, express or implied.
"  *** ***   Use At-Your-Own-Risk!   *** ***
" GetLatestVimScripts: 2822 18 :AutoInstall: unicode.vim
" ---------------------------------------------------------------------

" TEST VERSION: Stores unicode in different format (look at new generated cache file)

" initialize Variables {{{1
let s:unicode_URL = get(g:, 'Unicode_URL',
    \ 'http://www.unicode.org/Public/UNIDATA/UnicodeData.txt')
let s:directory   = expand("<sfile>:p:h")."/unicode"
let s:UniFile     = s:directory . '/UnicodeData.txt'

" HTML entitities {{{2
let s:html = {}
let s:html[0x0022] = "&quot;"
let s:html[0x0026] = "&amp;"
let s:html[0x0027] = "&apos;"
let s:html[0x003C] = "&lt;"
let s:html[0x003E] = "&gt;"
let s:html[0x0022] = "&quot;"
let s:html[0x0026] = "&amp;"
let s:html[0x0027] = "&apos;"
let s:html[0x003C] = "&lt;"
let s:html[0x003E] = "&gt;"
let s:html[0x00A0] = "&nbsp;"
let s:html[0x00A1] = "&iexcl;"
let s:html[0x00A2] = "&cent;"
let s:html[0x00A3] = "&pound;"
let s:html[0x00A4] = "&curren;"
let s:html[0x00A5] = "&yen;"
let s:html[0x00A6] = "&brvbar;"
let s:html[0x00A7] = "&sect;"
let s:html[0x00A8] = "&uml;"
let s:html[0x00A9] = "&copy;"
let s:html[0x00AA] = "&ordf;"
let s:html[0x00AB] = "&laquo;"
let s:html[0x00AC] = "&not;"
let s:html[0x00AD] = "&shy;"
let s:html[0x00AE] = "&reg;"
let s:html[0x00AF] = "&macr;"
let s:html[0x00B0] = "&deg;"
let s:html[0x00B1] = "&plusmn;"
let s:html[0x00B2] = "&sup2;"
let s:html[0x00B3] = "&sup3;"
let s:html[0x00B4] = "&acute;"
let s:html[0x00B5] = "&micro;"
let s:html[0x00B6] = "&para;"
let s:html[0x00B7] = "&middot;"
let s:html[0x00B8] = "&cedil;"
let s:html[0x00B9] = "&sup1;"
let s:html[0x00BA] = "&ordm;"
let s:html[0x00BB] = "&raquo;"
let s:html[0x00BC] = "&frac14;"
let s:html[0x00BD] = "&frac12;"
let s:html[0x00BE] = "&frac34;"
let s:html[0x00BF] = "&iquest;"
let s:html[0x00C0] = "&Agrave;"
let s:html[0x00C1] = "&Aacute;"
let s:html[0x00C2] = "&Acirc;"
let s:html[0x00C3] = "&Atilde;"
let s:html[0x00C4] = "&Auml;"
let s:html[0x00C5] = "&Aring;"
let s:html[0x00C6] = "&AElig;"
let s:html[0x00C7] = "&Ccedil;"
let s:html[0x00C8] = "&Egrave;"
let s:html[0x00C9] = "&Eacute;"
let s:html[0x00CA] = "&Ecirc;"
let s:html[0x00CB] = "&Euml;"
let s:html[0x00CC] = "&Igrave;"
let s:html[0x00CD] = "&Iacute;"
let s:html[0x00CE] = "&Icirc;"
let s:html[0x00CF] = "&Iuml;"
let s:html[0x00D0] = "&ETH;"
let s:html[0x00D1] = "&Ntilde;"
let s:html[0x00D2] = "&Ograve;"
let s:html[0x00D3] = "&Oacute;"
let s:html[0x00D4] = "&Ocirc;"
let s:html[0x00D5] = "&Otilde;"
let s:html[0x00D6] = "&Ouml;"
let s:html[0x00D7] = "&times;"
let s:html[0x00D8] = "&Oslash;"
let s:html[0x00D9] = "&Ugrave;"
let s:html[0x00DA] = "&Uacute;"
let s:html[0x00DB] = "&Ucirc;"
let s:html[0x00DC] = "&Uuml;"
let s:html[0x00DD] = "&Yacute;"
let s:html[0x00DE] = "&THORN;"
let s:html[0x00DF] = "&szlig;"
let s:html[0x00E0] = "&agrave;"
let s:html[0x00E1] = "&aacute;"
let s:html[0x00E2] = "&acirc;"
let s:html[0x00E3] = "&atilde;"
let s:html[0x00E4] = "&auml;"
let s:html[0x00E5] = "&aring;"
let s:html[0x00E6] = "&aelig;"
let s:html[0x00E7] = "&ccedil;"
let s:html[0x00E8] = "&egrave;"
let s:html[0x00E9] = "&eacute;"
let s:html[0x00EA] = "&ecirc;"
let s:html[0x00EB] = "&euml;"
let s:html[0x00EC] = "&igrave;"
let s:html[0x00ED] = "&iacute;"
let s:html[0x00EE] = "&icirc;"
let s:html[0x00EF] = "&iuml;"
let s:html[0x00F0] = "&eth;"
let s:html[0x00F1] = "&ntilde;"
let s:html[0x00F2] = "&ograve;"
let s:html[0x00F3] = "&oacute;"
let s:html[0x00F4] = "&ocirc;"
let s:html[0x00F5] = "&otilde;"
let s:html[0x00F6] = "&ouml;"
let s:html[0x00F7] = "&divide;"
let s:html[0x00F8] = "&oslash;"
let s:html[0x00F9] = "&ugrave;"
let s:html[0x00FA] = "&uacute;"
let s:html[0x00FB] = "&ucirc;"
let s:html[0x00FC] = "&uuml;"
let s:html[0x00FD] = "&yacute;"
let s:html[0x00FE] = "&thorn;"
let s:html[0x00FF] = "&yuml;"
let s:html[0x0152] = "&OElig;"
let s:html[0x0153] = "&oelig;"
let s:html[0x0160] = "&Scaron;"
let s:html[0x0161] = "&scaron;"
let s:html[0x0178] = "&Yuml;"
let s:html[0x0192] = "&fnof;"
let s:html[0x02C6] = "&circ;"
let s:html[0x02DC] = "&tilde;"
let s:html[0x0391] = "&Alpha;"
let s:html[0x0392] = "&Beta;"
let s:html[0x0393] = "&Gamma;"
let s:html[0x0394] = "&Delta;"
let s:html[0x0395] = "&Epsilon;"
let s:html[0x0396] = "&Zeta;"
let s:html[0x0397] = "&Eta;"
let s:html[0x0398] = "&Theta;"
let s:html[0x0399] = "&Iota;"
let s:html[0x039A] = "&Kappa;"
let s:html[0x039B] = "&Lambda;"
let s:html[0x039C] = "&Mu;"
let s:html[0x039D] = "&Nu;"
let s:html[0x039E] = "&Xi;"
let s:html[0x039F] = "&Omicron;"
let s:html[0x03A0] = "&Pi;"
let s:html[0x03A1] = "&Rho;"
let s:html[0x03A3] = "&Sigma;"
let s:html[0x03A4] = "&Tau;"
let s:html[0x03A5] = "&Upsilon;"
let s:html[0x03A6] = "&Phi;"
let s:html[0x03A7] = "&Chi;"
let s:html[0x03A8] = "&Psi;"
let s:html[0x03A9] = "&Omega;"
let s:html[0x03B1] = "&alpha;"
let s:html[0x03B2] = "&beta;"
let s:html[0x03B3] = "&gamma;"
let s:html[0x03B4] = "&delta;"
let s:html[0x03B5] = "&epsilon;"
let s:html[0x03B6] = "&zeta;"
let s:html[0x03B7] = "&eta;"
let s:html[0x03B8] = "&theta;"
let s:html[0x03B9] = "&iota;"
let s:html[0x03BA] = "&kappa;"
let s:html[0x03BB] = "&lambda;"
let s:html[0x03BC] = "&mu;"
let s:html[0x03BD] = "&nu;"
let s:html[0x03BE] = "&xi;"
let s:html[0x03BF] = "&omicron;"
let s:html[0x03C0] = "&pi;"
let s:html[0x03C1] = "&rho;"
let s:html[0x03C2] = "&sigmaf;"
let s:html[0x03C3] = "&sigma;"
let s:html[0x03C4] = "&tau;"
let s:html[0x03C5] = "&upsilon;"
let s:html[0x03C6] = "&phi;"
let s:html[0x03C7] = "&chi;"
let s:html[0x03C8] = "&psi;"
let s:html[0x03C9] = "&omega;"
let s:html[0x03D1] = "&thetasym;"
let s:html[0x03D2] = "&upsih;"
let s:html[0x03D6] = "&piv;"
let s:html[0x2002] = "&ensp;"
let s:html[0x2003] = "&emsp;"
let s:html[0x2009] = "&thinsp;"
let s:html[0x200C] = "&zwnj;"
let s:html[0x200D] = "&zwj;"
let s:html[0x200E] = "&lrm;"
let s:html[0x200F] = "&rlm;"
let s:html[0x2013] = "&ndash;"
let s:html[0x2014] = "&mdash;"
let s:html[0x2018] = "&lsquo;"
let s:html[0x2019] = "&rsquo;"
let s:html[0x201A] = "&sbquo;"
let s:html[0x201C] = "&ldquo;"
let s:html[0x201D] = "&rdquo;"
let s:html[0x201E] = "&bdquo;"
let s:html[0x2020] = "&dagger;"
let s:html[0x2021] = "&Dagger;"
let s:html[0x2022] = "&bull;"
let s:html[0x2026] = "&hellip;"
let s:html[0x2030] = "&permil;"
let s:html[0x2032] = "&prime;"
let s:html[0x2033] = "&Prime;"
let s:html[0x2039] = "&lsaquo;"
let s:html[0x203A] = "&rsaquo;"
let s:html[0x203E] = "&oline;"
let s:html[0x2044] = "&frasl;"
let s:html[0x20AC] = "&euro;"
let s:html[0x2111] = "&image;"
let s:html[0x2118] = "&weierp;"
let s:html[0x211C] = "&real;"
let s:html[0x2122] = "&trade;"
let s:html[0x2135] = "&alefsym;"
let s:html[0x2190] = "&larr;"
let s:html[0x2191] = "&uarr;"
let s:html[0x2192] = "&rarr;"
let s:html[0x2193] = "&darr;"
let s:html[0x2194] = "&harr;"
let s:html[0x21B5] = "&crarr;"
let s:html[0x21D0] = "&lArr;"
let s:html[0x21D1] = "&uArr;"
let s:html[0x21D2] = "&rArr;"
let s:html[0x21D3] = "&dArr;"
let s:html[0x21D4] = "&hArr;"
let s:html[0x2200] = "&forall;"
let s:html[0x2202] = "&part;"
let s:html[0x2203] = "&exist;"
let s:html[0x2205] = "&empty;"
let s:html[0x2207] = "&nabla;"
let s:html[0x2208] = "&isin;"
let s:html[0x2209] = "&notin;"
let s:html[0x220B] = "&ni;"
let s:html[0x220F] = "&prod;"
let s:html[0x2211] = "&sum;"
let s:html[0x2212] = "&minus;"
let s:html[0x2217] = "&lowast;"
let s:html[0x221A] = "&radic;"
let s:html[0x221D] = "&prop;"
let s:html[0x221E] = "&infin;"
let s:html[0x2220] = "&ang;"
let s:html[0x2227] = "&and;"
let s:html[0x2228] = "&or;"
let s:html[0x2229] = "&cap;"
let s:html[0x222A] = "&cup;"
let s:html[0x222B] = "&int;"
let s:html[0x2234] = "&there4;"
let s:html[0x223C] = "&sim;"
let s:html[0x2245] = "&cong;"
let s:html[0x2248] = "&asymp;"
let s:html[0x2260] = "&ne;"
let s:html[0x2261] = "&equiv;"
let s:html[0x2264] = "&le;"
let s:html[0x2265] = "&ge;"
let s:html[0x2282] = "&sub;"
let s:html[0x2283] = "&sup;"
let s:html[0x2284] = "&nsub;"
let s:html[0x2286] = "&sube;"
let s:html[0x2287] = "&supe;"
let s:html[0x2295] = "&oplus;"
let s:html[0x2297] = "&otimes;"
let s:html[0x22A5] = "&perp;"
let s:html[0x22C5] = "&sdot;"
let s:html[0x2308] = "&lceil;"
let s:html[0x2309] = "&rceil;"
let s:html[0x230A] = "&lfloor;"
let s:html[0x230B] = "&rfloor;"
let s:html[0x2329] = "&lang;"
let s:html[0x232A] = "&rang;"
let s:html[0x25CA] = "&loz;"
let s:html[0x2660] = "&spades;"
let s:html[0x2663] = "&clubs;"
let s:html[0x2665] = "&hearts;"
let s:html[0x2666] = "&diams;" "}}}2
" public functions {{{1
fu! unicode#FindDigraphBy(match) "{{{2
    return <sid>DigraphsInternal(a:match)
endfu
fu! unicode#FindUnicodeBy(match) "{{{2
    return <sid>FindUnicodeByInternal(a:match)
endfu
fu! unicode#Digraph(char1, char2) "{{{2
    if empty(a:char1) || empty(a:char2)
        return ''
    endif
    let s=''
    " How about a digrpah() function?
    " already sent a patch to Bram
    exe "sil! norm! :let s.='\<c-k>".a:char1.a:char2."'\<cr>"
    if s == a:char1
        return ''
    endif
    return (s ==# a:char1 ? '' : s)
endfu
fu! unicode#UnicodeName(val) "{{{2
    return <sid>GetUnicodeName(a:val)
endfu
fu! unicode#Download(force) "{{{2
    call <sid>CheckUniFile(a:force)
endfu
" internal functions {{{1
fu! unicode#CompleteUnicode() "{{{2
    " Completion function for Unicode characters
    let numeric=0
    if !exists("s:UniDict")
        let s:UniDict=<sid>UnicodeDict()
    endif
    let line = getline('.')
    let start = col('.') - 1
    let prev_fmt="Char\tCodepoint  Digraph\tName\n%s\tU+%04X\t  %s\t\t%s"
    while start > 0 && line[start - 1] =~ '\w\|+'
        let start -= 1
    endwhile
    if line[start] =~# 'U' && line[start+1] == '+' && col('.')-1 >=start+2
        let numeric=1
    endif
    let base = line[start : (col('.')-1)]
    if empty(base)
        let complete_list = s:UniDict
        echom '(Checking all Unicode Names... this might be slow)'
    else
        if numeric
            let complete_list = filter(copy(s:UniDict),
                \ 'printf("%04X", v:key) =~? "^0*".base[2:]')
        else
            let complete_list = filter(copy(s:UniDict), 'v:val =~? base')
        endif
        echom printf('(Checking Unicode Names for "%s"... this might be slow)', base)
    endif
    let compl = <sid>AddCompleteEntries(complete_list, numeric)
    call complete(start+1, compl)
    return ""
endfu
fu! unicode#CompleteDigraph() "{{{2
    " Completion function for digraphs
    let prevchar=getline('.')[col('.')-2]
    let prevchar1=getline('.')[col('.')-3]
    let dlist=values(<sid>GetDigraphDict())
    if !exists("s:UniDict")
        let s:UniDict=<sid>UnicodeDict()
    endif
    if prevchar !~ '\s' && !empty(prevchar)
        let filter1 =  '(v:val[0] == prevchar1 && v:val[1] == prevchar)'
        let filter2 = 'v:val[0] == prevchar || v:val[1] == prevchar'
        let dlist1  = filter(copy(dlist), filter1)
        if empty(dlist1)
            let dlist = filter(dlist, filter2)
            let col=col('.')-1
        else
            let dlist = dlist1
            let col=col('.')-2
        endif
        unlet dlist1
    else
        let col=col('.')
    endif
    let tlist=[]
    for args in dlist
        let t=matchlist(args, '^\(..\)\s<\?\(..\?\)>\?\s\+\(\d\+\)$')
        let prev_fmt="Abbrev\tGlyph\tCodepoint\tName\n%s\t%s\tU+%04X\t\t%s"
        if !empty(t)
            let format = printf("'%s' %s U+%04X",t[1], t[2], t[3])
            let name   = <sid>GetUnicodeName(t[3])
            call add(tlist, {'word':nr2char(t[3]), 'abbr':format,
                \ 'info': printf(prev_fmt, t[1],t[2],t[3],name)})
       endif
    endfor
    call complete(col, tlist)
    return ''
endfu
fu! unicode#GetUniChar(...) "{{{2
    " Return Unicode Name of Character under cursor
    " :UnicodeName
    if exists("a:1") && !empty(a:1) && (len(a:1)>1 || a:1 !~# '[a-zA-Z0-9]')
        call <sid>WarningMsg("No valid register specified")
        return
    endif
    let msg        = []
    let msg_script = []
    try
        if !exists("s:UniDict")
            let s:UniDict=<sid>UnicodeDict()
            if empty(s:UniDict)
                call add(msg,
                    \ printf("Can't determine char under cursor,".
                    \ "%s not found", s:UniFile))
                return
            endif
        endif
        " Get char at Cursor, need to use redir, cause we also want
        " to capture combining chars
        redir => a | exe "silent norm! ga" | redir end 
        let a = substitute(a, '\n', '', 'g')
        " Special case: no character under cursor
        if a == 'NUL'
            call add(msg, "'NUL' U+0000 NULL")
        else
            " Split string, in case cursor was on a combining char
            for item in split(a, 'Octal \d\+\zs \?')
                let glyph = substitute(item, '^<\(<\?[^>]*>\?\)>.*', '\1', '')
                let dec   = substitute(item, '.*>\?> \+\(\d\+\),.*', '\1', '')
                if dec == 0
                    let dec = 10
                endif
                let dig   = <sid>GetDigraphChars(dec)
                let name  = <sid>GetUnicodeName(dec)
                let html  = <sid>GetHtmlEntity(dec)
                call add(msg, printf("'%s' U+%04X, Dec:%d %s %s %s", glyph,
                        \ dec, dec, name, dig, html))
            endfor
        endif
        if exists("a:1") && !empty(a:1)
            if len(a:1) > 1 || a:1 !~# '[a-zA-Z0-9]'
                call <sid>WarningMsg("No valid register specified")
                return
            endif
            exe "let @".a:1. "=join(msg)"
        endif
    finally
        let start      = 1
        for val in msg
            let l=split(val)
            call <sid>ScreenOutput((start ? 0 : 1), l[0], ' '.join(l[1:]))
            let start = 0
        endfor
    endtry
endfun
fu! unicode#PrintDigraphs(match, bang) "{{{2
    " outputs only first digraph that exists for char
    " makes a difference for e.g. Euro which has (=e Eu)
    let digraphs = <sid>DigraphsInternal(a:match)
    let screenwidth = 0
    let format = ['%s',' %s %s ']
    let start = 1

    for item in digraphs
        let output = printf(format[0].format[1], split(item.dig)[0], item.glyph, item.decimal)
        " if the output is too wide, echo a linebreak
        if screenwidth + <sid>Screenwidth(output) >= &columns
            \ || (!empty(a:bang) && start == 0)
            let screenwidth = 0
        endif
        let screenwidth += <sid>ScreenOutput(
                \ (start == 0 && screenwidth == 0 ? 1 : 0), item.glyph,
                \ printf(format[1], split(item.dig)[0], item.decimal))
        let start = 0
    endfor
endfu
fu! unicode#PrintUnicode(match) "{{{2
    let uni    = <sid>FindUnicodeByInternal(a:match)
    let format = ["% 4S\t", "Dec:%06d, Hex:%06X\t", ' %s']
    let i      = 0
    if (v:version == 703 && !has("patch713")) || v:version < 703
        " patch 7.3.713 introduced the %S modifier for printf
        let format[0] = substitute(format[0], 'S', 's', '')
    endif
    for item in sort(uni, '<sid>CompareListsByHex')
        let dig  = get(item, 'dig' , '')
        let html = get(item, 'html', '')
        call <sid>ScreenOutput(i<len(uni) && i > 0, printf(format[0], item.glyph),
                \ printf(format[1].format[2], item.dec, item.dec, item.name),
                \ (empty(dig)  ? [] : printf(" %s", dig)),
                \ (empty(html) ? [] : printf(" %s", html)))
        let i+=1
    endfor
endfu
fu! unicode#GetDigraph(type, ...) "{{{2
    " turns a movement or selection into digraphs, each pair of chars
    " will be converted into the belonging digraph, e.g: This line:
    " a:e:o:u:1Sß/\
    " will be converted into:
    " äëöü¹ß×
    let sel_save = &selection
    let &selection = "inclusive"
    let _a = [getreg("a"), getregtype("a")]

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
    while !empty(@a)
        " need to check the next 2 characters
        for i in range(2)
            let char{i} = matchstr(@a, '^.')
            if char2nr(char{i}) > 126 || char2nr(char{i}) < 20 || char2nr(char{i}) == 0x20
                let s.=char0. (exists("char1") ? "char1" : "")
                let @a=substitute(@a, '^.', '', '')
                break
            endif
            let @a=substitute(@a, '^.', '', '')
            if empty(@a)
                break
            endif
        endfor
        if exists("char0") && exists("char1")
            " How about a digraph() function?
            " e.g. :let s.=digraph(char[0], char[1])
            let s.=unicode#Digraph(char0, char1)
        endif
        unlet! char0 char1
    endw

    if s != @a
        let @a = s
        exe "norm! gv\"ap"
    endif
    let &selection = sel_save
    call call("setreg", ["a"]+_a)
endfu
fu! unicode#PrintUnicodeTable() "{{{2
    let winname = 'UnicodeTable.txt'
	let win = bufwinnr('^'.winname.'$')
	if win != -1
		exe ":noa ". win. 'wincmd w'
	else
        exe  'noa sp' winname
    endif

    " just in case, a global nomodifiable was set 
    setl ma
    " Just in case
    silent %d _
    " Set up some options 
    setl noswapfile buftype=nofile foldcolumn=0 nobuflisted bufhidden=wipe
    if !exists("s:UniDict")
        let s:UniDict=<sid>UnicodeDict()
    endif
    call append(1, "Char\tCodept\tDigraph\tHtml\t\tName")
    for value in sort(keys(s:UniDict), '<sid>CompareListByDec')
        let value += 0
        let dig   = <sid>GetDigraphChars(value)
        let html  = <sid>GetHtmlEntity(value)
        let html  = html. repeat(' ', &ts-len(html))
        let codep = printf('U+%04X', value)
        let codep = codep. repeat(' ', &ts-len(codep))
        call append('$', printf("%s\t%s%s\t%s\t%s", strtrans(nr2char(value)),
                \ codep, dig, html, s:UniDict[value]))
    endfor
    :noa 1
    syn match Title /\%(^\%2l.*\)\|\%(^\%>2l\S\+\)/         " highlight Heading and Character
    syn match Title /\%>2l(\zs\(\S\+\s*\)\+\ze)\|&\w*;/     " highlight html and digraph
    noa wincmd p
endfu
fu! <sid>AddCompleteEntries(dict, numeric) "{{{2
    let compl=[]
    let starttime = localtime()
    for [value, name] in sort(items(a:dict), "<sid>CompareList")
        let dg_char=<sid>GetDigraphChars(value)
        let fstring = printf("U+%04X %s%s:'%s'",
                \ value, name, dg_char, nr2char(value))
        if get(g:, 'Unicode_CompleteName',0)
            let dict = {'word':printf("%s (U+%04X)", name, value), 'abbr':fstring}
        else
            let dict = {'word':nr2char(value), 'abbr':fstring}
        endif
        if get(g:,'Unicode_ShowPreviewWindow',0)
            call extend(dict, {'info': printf(prev_fmt, nr2char(value),value,
                    \ substitute(dg_char, '(\(..\).*', '\1', ''), name)})
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
fu! <sid>DigraphsInternal(match) "{{{2
    let outlist = []
    let digit = a:match + 0
    let name = ''
    let unidict = {}
    let tchar = {}
    if (len(a:match > 1 && digit == 0) || print_out == 0)
        " try to match digest name from unicode name
        if !exists("s:UniDict")
            let s:UniDict = <sid>UnicodeDict()
        endif
    endif
    if (len(a:match) > 1 && digit == 0)
        let name    = a:match
        let unidict = filter(copy(s:UniDict), 'v:val =~? name')
    endif
    for dig in sort(values(<sid>GetDigraphDict()), '<sid>CompareDigraphs')
        " display digraphs that match value
        if dig !~# a:match && digit == 0 && empty(unidict)
            continue
        endif
        " digraph: xy Z \d\+
        " (x and y are the letters to create the digraph)
        let item = matchlist(dig,
            \ '\(..\)\s\(\%(\s\s\)\|.\{,4\}\)\s\+\(\d\+\)$')
        " if digit matches, we only want to display digraphs matching the
        " decimal values
        if (digit > 0 && item[3] !~ '^'.digit.'$') ||
            \ (!empty(name) &&  match(keys(unidict), '^'.item[3].'$') == -1)
            continue
        endif

        if !empty(name)
            let tchar = filter(copy(unidict), 'v:key == item[3]')
        endif

        " add trailing  space for item[2] if there isn't one
        " (e.g. needed for digraph 132)
        if item[2] !~? '\s$' || item[3] == 32
            let item[2].= ' '
        endif

        let clist=[]
        if !empty(name)
            let name = values(tchar)[0]
            let clist=filter(copy(outlist), 'v:val["name"] ==? name')
        endif
        if empty(clist)
            let dict         = {}
            " Space is different
            let dict.glyph   = item[3] != 32 ? matchstr(item[2],'\s\?\S*\ze\s*$') : '  '
            let dict.dig     = item[1]
            let dict.decimal = item[3]
            let dict.hex     = printf("0x%02X", item[3])
            let dict.name    = name
            call add(outlist, dict)
        else
            let cdict = clist[0]
            " digraph already in list, get index and add
            " digraph characters
            let outlist[index(outlist, cdict)].dig.=' '.item[1]
        endif
    endfor
    return outlist
endfu
fu! <sid>FindUnicodeByInternal(match) "{{{2
    let digit = a:match + 0
    if a:match[0:1] == 'U+'
        let digit = str2nr(a:match[2:], 16)
    endif
    let unidict = {}
    let name = ''
    let output = []
    if !exists("s:UniDict")
        let s:UniDict = <sid>UnicodeDict()
    endif
    if len(a:match) > 1 && digit == 0
        " try to match digest name from unicode name
        let name = a:match
    endif
    if (digit == 0 && empty(name))
        echoerr "No argument was specified!"
        return
    endif
    if !empty(name)
        let unidict = filter(copy(s:UniDict), 'v:val =~? name')
    else
        " filter for decimal value
        let unidict = filter(copy(s:UniDict), 'v:key == digit')
    endif
    for [decimal, name] in items(unidict)
        " Try to get digraph char
        let dchar=<sid>GetDigraphChars(decimal)
        " Get html entity
        let html          = <sid>GetHtmlEntity(decimal)
        let dict          = {}
        let dict.name     = name
        let dict.glyph    = nr2char(decimal)
        let dict.dec      = decimal
        let dict.hex      = printf("0x%02X", decimal)
        if !empty(dchar)
            let dict.dig  = dchar
        endif
        if !empty(html)
            let dict.html = html
        endif
        call add(output, dict)
    endfor
    return output
endfu
fu! <sid>Screenwidth(item) "{{{2
    " Takes string arguments and calculates the width
    if exists("*strdisplaywidth")
        return strdisplaywidth(a:item)
    else
        " old vims doen't have strdisplaywidth function
        " return number of chars (which might be wrong 
        " for double width chars...)
        return len(split(a:item, '\zs'))
    endif
endfu
fu! <sid>GetDigraphChars(code) "{{{2
    "returns digraph for given decimal value
    if !exists("s:digdict")
        call <sid>GetDigraphDict()
    endif
    if !has_key(s:digdict, a:code)
        return ''
    endif
    let dig = split(get(s:digdict, a:code))[0]
    return (empty(dig) ? '' : '('. join(split(dig, '..\zs'), ' '). ')')
endfu
fu! <sid>UnicodeDict() "{{{2
    let dict={}
    " make sure unicodedata.txt is found
    if <sid>CheckDir()
        let uni_cache_file = s:directory. '/UnicodeData.vim'
        if filereadable(uni_cache_file) &&
            \ getftime(uni_cache_file) > getftime(s:UniFile) &&
            \ getfsize(uni_cache_file) > 100 " Unicode Cache Dict should be a lot larger
            exe "source" uni_cache_file
            let dict=g:unicode#unicode#data
            unlet! g:unicode#unicode#data
        else
            let list=readfile(s:UniFile)
            for glyph in list
                let val          = split(glyph, ";")
                let Name         = val[1]
                let OldName      = val[10] " Unicode_1_Name field (10)
                if Name[0] == '<' && !empty(OldName)
                    let Name = substitute(OldName, ' ([^)]*)', '', 'g')
                endif
                let dict[str2nr(val[0],16)]   = Name
            endfor
            call <sid>UnicodeWriteCache(dict)
    endif
    return dict
endfu
fu! <sid>CheckUniFile(force) "{{{2
    if (!filereadable(s:UniFile) || (getfsize(s:UniFile) == 0)) || a:force
        call s:WarningMsg("File " . s:UniFile . " does not exist or is zero.")
        call s:WarningMsg("Let's see, if we can download it.")
        call s:WarningMsg("If this doesn't work, you should download ")
        call s:WarningMsg(s:unicode_URL . " and save it as " . s:UniFile)
        sleep 10
        if filereadable(s:directory. '/UnicodeData.vim')
            call delete(s:directory. '/UnicodeData.vim')
        endif
        if exists(":Nread")
            sp +enew
            " Use the default download method. You can specify a different
            " one, using :let g:netrw_http_cmd="wget"
            exe ":lcd " . s:directory
            exe "0Nread " . s:unicode_URL
            $d _
            exe ":noa :keepalt :sil w! " . s:UniFile
            if getfsize(s:UniFile)==0
                call s:WarningMsg("Error fetching File from ". s:unicode_URL)
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
fu! <sid>CheckDir() "{{{2
    try
        if (!isdirectory(s:directory))
            call mkdir(s:directory)
        endif
    catch
        call s:WarningMsg("Error creating Directory: " . s:directory)
        return 0
    endtry
    return <sid>CheckUniFile(0)
endfu
fu! <sid>GetDigraphDict() "{{{2
    " returns a dict of digraphs 
    " as output by :digraphs
    if exists("s:digdict") && !empty(s:digdict)
        return s:digdict
    else
        redir => digraphs
            silent digraphs
        redir END
        " Because of the redir, the next message might not be
        " displayed correctly. So force a redraw now.
        redraw!
        let s:digdict={}
        let dlist=[]
        let dlist=map(split(substitute(digraphs, "\n", ' ', 'g'),
            \ '..\s<\?.\{1,2\}>\?\s\+\d\{1,5\}\zs'),
            \ 'substitute(v:val, "^\\s\\+", "", "")')
        " special case: digraph 57344: starts with 2 spaces
        "return filter(dlist, 'v:val =~ "57344$"')
        let idx=match(dlist, '57344$')
        if idx > -1
            let dlist[idx]='   '.dlist[idx]
        endif
        for val in dlist
            let dec=matchstr(val, '\d\+$')
            let dig=matchstr(get(s:digdict, dec, ''), '^\S\+')
            let s:digdict[dec] = (empty(dig) ? val : dig.val)
        endfor
        return s:digdict
    endif
endfu
fu! <sid>CompareList(l1, l2) "{{{2
    return <sid>CompareByValue((a:l1[0]+0),(a:l2[0]+0))
endfu
fu! <sid>CompareDigraphs(d1, d2) "{{{2
    let d1=matchstr(a:d1, '\d\+$')+0
    let d2=matchstr(a:d2, '\d\+$')+0
    return <sid>CompareByValue(d1,d2)
endfu
fu! <sid>CompareListByDec(l1, l2) "{{{2
    return <sid>CompareByValue(a:l1+0,a:l2+0)
endfu
fu! <sid>CompareListsByHex(l1, l2) "{{{2
    let d1 = str2nr(a:l1["hex"], 16)
    let d2 = str2nr(a:l2["hex"], 16)
    return <sid>CompareByValue(d1,d2)
endfu
fu! <sid>CompareByValue(v1, v2) "{{{2
    return (a:v1 == a:v2 ? 0 : (a:v1 > a:v2 ? 1 : -1))
endfu
fu! <sid>ScreenOutput(...) "{{{2
    if a:1 "first argument indicates whether we need a linebreak
        echon "\n"
    endif
    let list=filter(a:000[1:], '!empty(v:val)')
    let i=0
    for value in list
        exe "echohl ". (i ? "Normal" : "Title")
        echon value
        let i+=<sid>Screenwidth(value)
    endfor
    return i
endfu
fu! <sid>WarningMsg(msg) "{{{2
    echohl WarningMsg
    let msg = "UnicodePlugin: " . a:msg
    if exists(":unsilent") == 2
        unsilent echomsg msg
    else
        echomsg msg
    endif
    echohl Normal
endfun
fu! <sid>GetHtmlEntity(hex) "{{{2
    return get(s:html, a:hex, '')
endfu
fu! <sid>UnicodeWriteCache(data) "{{{2
    " Take unicode dictionary and write it in VimL form
    " so it will be faster to load
    let list = ['" internal cache file for unicode.vim plugin',
        \ '" this file can safely be removed, it will be recreated if needed',
        \ '',
        \ 'let unicode#unicode#data = {}']
    for items in items(a:data)
        call add(list, printf("let unicode#unicode#data['%d'] = '%s'",
            \ items[0]+0, items[1]))
    endfor
    call writefile(list, s:directory. '/UnicodeData.vim')
    unlet! list
endfu
fu! <sid>GetUnicodeName(dec) "{{{2
    " returns Unicodename for decimal value
    " Check for control char (has no name)
    if a:dec <= 0x1F || (a:dec >= 0x7F && a:dec <= 0x9F)
        return "<Control Char>"
    " CJK Unigraphs start at U+4E00 and go until U+9FFF
    elseif a:dec >= 0x3400 && a:dec <=0x4DB5
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
    elseif a:dec >= 0xFFFE && a:dec <= 0xFFFD
        return "<No Character (BOM)>"
    elseif a:dec >= 0xE000 && a:dec <= 0xF8FF
        return "Private Use Zone"
    elseif a:dec >= 0x20000 && a:dec <= 0x2A6D6
        return "Ideograph Extension B"
    elseif a:dec >= 0x2A700 && a:dec <= 0x2B73F
        return "Ideograph Extension C"
    elseif a:dec >= 0xF0000 && a:dec <= 0xFFFFD
        return "Character from Plane 15 for private use"
    elseif a:dec >= 0x100000 && a:dec <= 0x10FFFD
        return "Character from Plane 16 for private use"
    else
        let name = get(s:UniDict, a:dec, '')
        return empty(name) ? "Character not found" : name
    endif
endfu
" Modeline "{{{1
" vim: ts=4 sts=4 fdm=marker com+=l\:\" fdl=0 et
