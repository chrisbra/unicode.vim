" unicodePlugin : A completion plugin for Unicode glyphs
" Author: C.Brabandt <cb@256bit.org>
" Version: 0.20
" Copyright: (c) 2009-2014 by Christian Brabandt
"            The VIM LICENSE applies to unicode.vim, and unicode.txt
"            (see |copyright|) except use "unicode" instead of "Vim".
"            No warranty, express or implied.
"  *** ***   Use At-Your-Own-Risk!   *** ***
" GetLatestVimScripts: 2822 20 :AutoInstall: unicode.vim
" ---------------------------------------------------------------------

" initialize Variables {{{1
let s:unicode_URL  = get(g:, 'Unicode_URL',
        \ 'http://www.unicode.org/Public/UNIDATA/UnicodeData.txt')
let s:directory    = expand("<sfile>:p:h")."/unicode"
let s:UniFile      = s:directory . '/UnicodeData.txt'
" patch 7.3.713 introduced the %S modifier for printf
let s:printf_S_mod = (v:version == 703 && !has("patch713")) || v:version < 703

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
" Additional Information {{{2
" some additional information for certain characters
let s:info = {}
let s:info[0xfeff] = "(Byte Order Mark: BOM)" "}}}2
" public functions {{{1
fu! unicode#FindDigraphBy(match) "{{{2
    return <sid>DigraphsInternal(a:match)
endfu
fu! unicode#FindUnicodeBy(match) "{{{2
    return <sid>FindUnicodeByInternal(a:match)
endfu
fu! unicode#Digraph(char) "{{{2
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
fu! unicode#UnicodeName(val) "{{{2
    return <sid>GetUnicodeName(a:val)
endfu
fu! unicode#Download(force) "{{{2
    if (!filereadable(s:UniFile) || (getfsize(s:UniFile) == 0)) || a:force
        if !a:force
            call s:WarningMsg("File " . s:UniFile . " does not exist or is zero.")
        else
            call s:WarningMsg("Updating ". s:UniFile)
        endif
        call s:WarningMsg("Let's see, if we can download it.")
        call s:WarningMsg("If this doesn't work, you should download ")
        call s:WarningMsg(s:unicode_URL . " and save it as " . s:UniFile)
        sleep 5
        " remove cache file
        " (will be re-created later)
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
    let compl = <sid>AddCompleteEntries(complete_list)
    call complete(start+1, compl)
    return ""
endfu
fu! unicode#CompleteDigraph() "{{{2
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
fu! unicode#GetUniChar(...) "{{{2
    " Return Unicode Name of Character under cursor
    " :UnicodeName
    if exists("a:1") && !empty(a:1) && (len(a:1)>1 || a:1 !~# '[a-zA-Z0-9]')
        call <sid>WarningMsg("No valid register specified")
        return
    endif
    let type=''
    if exists("a:2") && !empty(a:2) && a:2 !~? 'd\%[igraph]\|r\%[egex]\|n\%[ame]\|h\%[tml]\|v\%[alue]'
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
                    \ "%s not found", s:UniFile))
                return
            endif
        endif
        " set locale to english
        let lang=v:lang
        if lang isnot# 'C'
            sil lang mess C
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
            let charlen = len(split(a, 'Octal \d\+\zs \?'))
            let i       = 0
            for item in split(a, 'Octal \d\+\zs \?')
                let i    += 1
                let glyph = substitute(item, '^<\(<\?[^>]*>\?\)>.*', '\1', '')
                let dec   = substitute(item, '.*>\?> \+\(\d\+\),.*', '\1', '')
                let dig   = <sid>GetDigraphChars(dec)
                let name  = <sid>GetUnicodeName(dec)
                let html  = <sid>GetHtmlEntity(dec)
                let hexl  = strlen(printf("%X", dec))
                let pat   = dec <= 0xFFFF ? printf('/\%%u%*x', hexl, dec):
                        \printf('/\%%U%*x', hexl, dec)
                if charlen > 1 && i < charlen
                    let pat .= '\Z'
                endif
                let info  = get(s:info, dec, '')

                let name  .= (empty(name) ? '' : ' ')
                let dig   .= (empty(dig)  ? '' : ' ')
                let html  .= (empty(html) ? '' : ' ')
                let info  .= (empty(info) ? '' : ' ')
                let pat   .= (empty(pat)  ? '' : ' ')
                call add(msg, printf("'%s' U+%04X Dec:%d %s%s%s%s%s", glyph,
                        \ dec, dec, name, dig, html, info, pat))
                if !empty(type)
                    if type==?'v'
                        call add(typelist, dec)
                    elseif type==?'d'
                        " remove () around the digraphs
                        call add(typelist, substitute(dig, '[()]', '', 'g'))
                    elseif type==?'r'
                        call add(typelist, pat[1:])
                    elseif type==?'h'
                        call add(typelist, html)
                    else
                        call add(typelist, name)
                    endif
                endif
            endfor
        endif
        if exists("a:1") && !empty(a:1)
            exe "let @".a:1. "=join(msg)"
        endif
        if exists("a:2") && !empty(a:2)
            exe "let @".a:1. "=join(typelist)"
        endif
    finally
        let start      = 1
        let s:output_width=1
        if lang !=# 'C'
            exe "sil lang mess" lang
        endif
        for val in msg
            let list = matchlist(val, '^\(' . "'[^']*'". '\)\(.*\)')
            call <sid>ScreenOutput(list[1], list[2])
            " force linebreak
            let s:output_width=&columns
            let start = 0
        endfor
    endtry
endfun
fu! unicode#PrintDigraphs(match, bang) "{{{2
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
fu! unicode#PrintUnicode(match) "{{{2
    let uni    = <sid>FindUnicodeByInternal(a:match)
    let format = ["% 4S\t", "U+%04X Dec:%06d\t", ' %s']
    let s:color_pattern = a:match.'\c'
    if s:printf_S_mod
        let format[0] = substitute(format[0], 'S', 's', '')
    endif
    let s:output_width = 1
    for item in uni
        let dig  = get(item, 'dig' , '')
        let html = get(item, 'html', '')
        call <sid>ScreenOutput(printf(format[0], item.glyph),
                \ printf(format[1].format[2], item.dec, item.dec, item.name),
                \ (empty(dig)  ? [] : printf(" %s", dig)),
                \ (empty(html) ? [] : printf(" %s", html)),
                \ (empty(item.info) ? [] : printf(" %s", item.info)))
        let s:output_width = &columns
    endfor
    unlet! s:color_pattern
endfu
fu! unicode#GetDigraph(type, ...) "{{{2
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
fu! unicode#PrintUnicodeTable() "{{{2
    let winname = 'UnicodeTable'
	let win = bufwinnr('^'.winname.'$')
	if win != -1
		exe 'noa ' .win. 'wincmd w'
	else
        exe  'noa sp' winname
    endif

    " just in case, a global nomodifiable was set 
    setl ma
    " Just in case
    silent %d _
    " Set up some options 
    setl noswapfile buftype=nofile foldcolumn=0 nobuflisted bufhidden=wipe nowrap
    if !exists("s:UniDict")
        let s:UniDict=<sid>UnicodeDict()
    endif
    call append(0, printf("%-7s%-8s%-10s%-57s%s",
            \ "Char","Codept","Html", "Name (Digraph)", "Link"))
    let output = []
    for [value,name] in items(s:UniDict) " sort is done later, for performance reasons
        let value  += 0
        let dig     = <sid>GetDigraphChars(value)
        let html    = <sid>GetHtmlEntity(value)
        let codep   = printf('U+%04X', value)
        let name   .= (name[-1:]==?' ' ? '' : ' ') " add trailing whitespace
        let output += [printf("%-7s%-8s%-10s%-57shttp://unicode-table.com/en/%04X/",
                    \ strtrans(nr2char(value)), codep, html, name.dig, value)]
    endfor
    call append(1, output)
    2,$-sort x /^.\{,8}U+/
    $d _
    setl nomodified
    ru syntax/unicode.vim
    noa 1
    call <sid>AirlineStatusline()
endfu
fu! <sid>AddCompleteEntries(dict) "{{{2
    let compl=[]
    let prev_fmt="Glyph\tCodepoint\tName\n%s\tU+%04X\t\t%s"
    let starttime = localtime()
    for value in sort(keys(a:dict), '<sid>CompareListByDec')
        if value==0
            continue " Skip NULLs, does not display correctly
        endif
        let name = a:dict[value]
        let dg_char=<sid>GetDigraphChars(value)
        let fstring = printf("U+%04X %s%s:'%s'",
                \ value, name, dg_char, nr2char(value))
        if get(g:, 'Unicode_CompleteName',0)
            let dict = {'word':printf("%s (U+%04X)", name, value), 'abbr':fstring}
        else
            let dict = {'word':nr2char(value), 'abbr':fstring}
        endif
        if get(g:,'Unicode_ShowPreviewWindow',0)
            call extend(dict, {'info': printf(prev_fmt, nr2char(value),value,name)})
        endif
        call add(compl, dict)
        " break too long running search
        if localtime() - starttime > 5
            echohl WarningMsg
            echom "Completing takes too long, stopping now..."
            echohl Normal
            break
        endif
    endfor
    return compl
endfu
fu! <sid>AddDigraphCompleteEntries(list) "{{{2
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
fu! <sid>Print(fmt, ...) "{{{2
    if &verbose
        echomsg call('printf', [a:fmt] + a:000)
    endif
endfu
fu! <sid>DigraphsInternal(match) "{{{2
    let outlist = []
    let digit = a:match + 0
    let name = ''
    let unidict = {}
    let cnt = 0
    let did_verbose = 0
    if (len(a:match > 1 && digit == 0))
        " try to match digest name from unicode name
        if !exists("s:UniDict")
            let s:UniDict = <sid>UnicodeDict()
        endif
        let name    = a:match
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
        if match(dig, a:match) == -1  && digit == 0 && empty(unidict)
            continue
        endif
        " digraph: xy Z \d\+
        " (x and y are the letters to create the digraph)
        let item = matchlist(dig[0],
            \ '\(..\)\s\(\%(\s\s\)\|.\{,4\}\)\s\+\(\d\+\)$')
        " if digit matches, we only want to display digraphs matching the
        " decimal values
        if (digit > 0 && (item[3]+0) != digit) ||
            \ (!empty(name) && !empty(unidict) && index(keys(unidict), item[3]) == -1)
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
        return []
    endif
    if !empty(name)
        let unidict = filter(copy(s:UniDict), 'v:val =~? name')
    else
        " filter for decimal value
        let unidict = filter(copy(s:UniDict), 'v:key == digit')
    endif
    for decimal in keys(unidict)
        " Try to get digraph char
        let dchar=<sid>GetDigraphChars(decimal)
        " Get html entity
        let html          = <sid>GetHtmlEntity(decimal)
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
    let list=map(deepcopy(get(s:digdict, a:code, [])), 'v:val[0:1]')
    return (empty(list) ? '' : '('. join(list). ')')
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
            let ind = []
            for glyph in list
                let val          = split(glyph, ";")
                let Name         = val[1]
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
    return dict
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
    return unicode#Download(0)
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
fu! <sid>CompareByDecimalKey(d1, d2) "{{{2
    return <sid>CompareByValue(a:d1['dec']+0, a:d2['dec']+0)
endfu
fu! <sid>CompareListByDec(l1, l2) "{{{2
    return <sid>CompareByValue(a:l1+0,a:l2+0)
endfu
fu! <sid>CompareByValue(v1, v2) "{{{2
    return (a:v1 == a:v2 ? 0 : (a:v1 > a:v2 ? 1 : -1))
endfu
fu! <sid>ScreenOutput(...) "{{{2
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
    let html=get(s:html, a:hex, '')
    if empty(html) && (a:hex > 31 ||
        \ a:hex == 9 || a:hex == 10 || a:hex == 13) &&
        \ (a:hex < 127 || a:hex > 159) &&
        \ (a:hex < 55296 || a:hex > 57343)
        " Generate HTML Code only for where it is allowed (see wikipedia)
        let html=printf("&#x%X;", a:hex)
    endif
    return html
endfu
fu! <sid>UnicodeWriteCache(data, ind) "{{{2
    " Take unicode dictionary and write it in VimL form
    " so it will be faster to load
    let list = ['" internal cache file for unicode.vim plugin',
        \ '" this file can safely be removed, it will be recreated if needed',
        \ '',
        \ 'let unicode#unicode#data = {}']
    let format = "let unicode#unicode#data[0x%04X] = '%s'"
    let list += map(copy(a:ind), 'printf(format, v:val, a:data[v:val])')
    call writefile(list, s:directory. '/UnicodeData.vim')
    unlet! list
endfu
fu! <sid>GetUnicodeName(dec) "{{{2
    " returns Unicodename for decimal value
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
        let name = get(s:UniDict, a:dec, '')
        return empty(name) ? "Character not found" : name
    endif
endfu
fu! <sid>AirlineStatusline() "{{{2
	if exists(":AirlineRefresh")
        AirlineRefresh
	endif
endfunction
" Modeline "{{{1
" vim: ts=4 sts=4 fdm=marker com+=l\:\" fdl=0 et
