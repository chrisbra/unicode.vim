" unicodePlugin : A completion plugin for Unicode glyphs
" Author: C.Brabandt <cb@256bit.org>
" Version: 0.17
" Copyright: (c) 2009 by Christian Brabandt
"			 The VIM LICENSE applies to unicode.vim, and unicode.txt
"			 (see |copyright|) except use "unicode" instead of "Vim".
"			 No warranty, express or implied.
"  *** ***	 Use At-Your-Own-Risk!	 *** ***
"
" GetLatestVimScripts: 2822 17 :AutoInstall: unicode.vim

" ---------------------------------------------------------------------


if exists("g:unicode_URL")
	let s:unicode_URL=g:unicode_URL
else
	"let s:unicode_URL='http://www.unicode.org/Public/UNIDATA/Index.txt'
	let s:unicode_URL='http://www.unicode.org/Public/UNIDATA/UnicodeData.txt'
endif
if !exists("g:UnicodeShowPreviewWindow")
	let g:UnicodeShowPreviewWindow = 0
endif

" HTML entitities
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
let s:html[0x2666] = "&diams;"


let s:file=matchstr(s:unicode_URL, '[^/]*$')

let s:directory  = expand("<sfile>:p:h")."/unicode"
let s:UniFile	 = s:directory . '/UnicodeData.txt'

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
	if s:numeric
		let complete_list = filter(copy(s:UniDict),
			\ 'printf("%04X", v:val) =~? "^0*".a:base[2:]')
	else
		let complete_list = filter(copy(s:UniDict), 'v:key =~? a:base')
	endif
	for [key, value] in sort(items(complete_list), "<sid>CompareList")
		"let key=matchstr(key, "^[^0-9 ]*")
		let dg_char=<sid>GetDigraphChars(value)
		if s:showDigraphCode
			if !empty(dg_char)
				let fstring = printf("U+%04X %s (%s):'%s'", value, key, dg_char,
					\ nr2char(value))
			else
				let fstring=printf("U+%04X %s:%s", value, key, nr2char(value))
			endif
		else
			let fstring=printf("U+%04X %s:'%s'", value, key, nr2char(value))
		endif
		let istring = printf("U+%04X %s%s:'%s'", value, key,
			\ empty(dg_char) ? '' : '('.dg_char.')', nr2char(value))
	
		if s:unicode_complete_name
			let dict = {'word':key, 'abbr':fstring}
			if g:UnicodeShowPreviewWindow
				call extend(dict, {'info': istring})
			endif
			call complete_add(dict)
		else
			let dict = {'word':nr2char(value), 'abbr':fstring}
			if g:UnicodeShowPreviewWindow
				call extend(dict, {'info': istring})
			endif
			call complete_add(dict)
		endif
		if complete_check()
			break
		endif
	endfor

	return {}
  endif
endfu

fu! unicode#CompleteDigraph() "{{{1
	let prevchar=getline('.')[col('.')-2]
	let prevchar1=getline('.')[col('.')-3]
	let dlist=<sid>GetDigraph()
	if prevchar !~ '\s' && !empty(prevchar)
		let filter1 =  '( v:val[0] == prevchar1 && v:val[1] == prevchar)'
		let filter2 = 'v:val[0] == prevchar || v:val[1] == prevchar'

		let dlist1 = filter(copy(dlist), filter1)
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
		if !empty(t)
			let format=printf("'%s' %s U+%04X",t[1], t[2], t[3])
			call add(tlist, {'word':nr2char(t[3]), 'abbr':format,
				\ 'info': printf("Abbrev\tGlyph\tCodepoint\n%s\t%s\tU+%04X",
				\ t[1],t[2],t[3])})
	   endif
	endfor
	call complete(col, tlist)
	return ''
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
		if (<sid>CheckDir())
			let s:UniDict = <sid>UnicodeDict()
			setl completefunc=unicode#CompleteUnicode
			set completeopt+=menuone
			inoremap <C-X><C-G> <C-R>=unicode#CompleteDigraph()<CR>
			nnoremap <leader>un :call unicode#SwapCompletion()<CR>
		endif
	else
		if exists("b:oldfunc") && !empty(b:oldfunc)
			let &l:cfu=b:oldfunc
		else
			setl completefunc=
		endif
		unlet! s:UniDict
		if maparg("<leader>un", 'n')
			nunmap <leader>un
		endif
		if maparg("<C-X><C-G>")
			iunmap <C-X><C-G>
		endif
	endif
	echo "Unicode Completion " . (a:enable? 'ON' : 'OFF')
endfu

fu! unicode#GetUniChar(...) "{{{1
	try
		if (<sid>CheckDir())
			if !exists("s:UniDict")
				let s:UniDict=<sid>UnicodeDict()
			endif
			let msg = []

		" Get glyph at Cursor
		" need to use redir, cause we also want to capture combining chars
			redir => a | exe "silent norm! ga" | redir end 
			let a = substitute(a, '\n', '', 'g')
			" Special case: no character under cursor
			if a == 'NUL'
				call add(msg, "'NUL' U+0000 NULL")
				"call add(msg, "No character under cursor!")
				return
			endif
			let dlist = <sid>GetDigraph()
			" Split string, in case cursor was on a combining char
			for item in split(a, 'Octal \d\+\zs \?')

				let glyph = substitute(item, '^<\(<\?[^>]*>\?\)>.*', '\1', '')
				let dec   = substitute(item, '.*>\?> \+\(\d\+\),.*', '\1', '')
				" Check for control char (has no name)
				if dec <= 0x1F || ( dec >= 0x7F && dec <= 0x9F)
					if dec == 0
						let dec = 10
					endif
					let dig = filter(copy(dlist), 'v:val =~ ''\D''.dec.''$''')
					call add(msg, printf("'%s' U+%04X <Control Char> %s", glyph, dec,
							\ empty(dig) ? '' : '('.dig[0][0:1].')'))
				" CJK Unigraphs start at U+4E00 and go until U+9FFF
				elseif dec >= 0x4E00 && dec <= 0x9FFF
					call add(msg, printf("'%s' U+%04X CJK Ideograph", glyph, dec))
				elseif dec >= 0xF0000 && dec <= 0xFFFFD
					call add(msg, printf("'%s' U+%04X character from Plane 15 for private use",
					\ glyph, dec))
				elseif dec >= 0x100000 && dec <= 0x10FFFD
					call add(msg, printf("'%s' U+%04X character from Plane 16 for private use",
				\ glyph, dec))
				else
					let dict = filter(copy(s:UniDict), 'v:val == dec')
					if empty(dict)
					" not found
						call add(msg, printf("Character '%s' U+%04X not found", glyph, dec))
						return
					endif
					let dig = filter(copy(dlist), 'v:val =~ ''\D''.dec.''$''')
					if !empty(dig)
						let dchar = printf("(%s)", dig[0][0:1])
					else
						let dchar = ''
					endif
					let html = <sid>GetHtmlEntity(dec)
					call add(msg, printf("'%s' U+%04X %s %s %s", glyph, values(dict)[0],
					\ keys(dict)[0], dchar, html))
				endif
			endfor
			if exists("a:1") && !empty(a:1)
				exe "let @".a:1. "=join(msg)"
			endif

			"call <sid>OutputMessage(msg)
		else
			call add(msg, printf("Can't determine char under cursor, %s not found", s:UniFile))
		endif
	finally
		call <sid>OutputMessage(msg)
	endtry
endfun

fu! unicode#OutputDigraphs(match, bang) "{{{1
	let screenwidth = 0
	let digit = a:match + 0
	for dig in sort(<sid>GetDigraph(), '<sid>CompareDigraphs')
		" display digraphs that match value
		if dig !~# a:match && digit == 0
			continue
		endif
		let item = matchlist(dig, '\(..\)\s\(\%(\s\s\)\|.\{,4\}\)\s\+\(\d\+\)$')

		" if digit matches, we only want to display digraphs matching the
		" decimal values
		if digit > 0 && digit !~ item[3]
			continue
		endif

		let screenwidth += strdisplaywidth(dig) + 2

		" if the output is too wide, echo an output
		if screenwidth > &columns || !empty(a:bang)
			let screenwidth = 0
			echon "\n"
		endif

		echohl Title
		echon item[2]
		echohl Normal
		echon item[1]. " ". item[3] . " "
	endfor
endfu

fu! <sid>GetDigraphChars(code) "{{{1
	let dlist = <sid>GetDigraph()
	let ddict = {}
	for digraph in dlist
		let key=matchstr(digraph, '\d\+$')+0
		let val=split(digraph)
		let ddict[key] = val[0]
	endfor
	return get(ddict, a:code, '')
endfu

fu! <sid>UnicodeDict() "{{{1
	let dict={}
	let list=readfile(s:UniFile)
	for glyph in list
	let val			 = split(glyph, ";")
	let Name		 = val[1]
	let dict[Name]	 = str2nr(val[0],16)
	endfor
	return dict
endfu

fu! <sid>CheckUniFile(force) "{{{1
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

fu! <sid>CheckDir() "{{{1
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

fu! <sid>GetDigraph() "{{{1
	if exists("s:dlist") && !empty(s:dlist)
		return s:dlist
	else
		redir => digraphs
			silent digraphs
		redir END
		let s:dlist=[]
		let s:dlist=map(split(substitute(digraphs, "\n", ' ', 'g'),
			\ '..\s<\?.\{1,2\}>\?\s\+\d\{1,5\}\zs'),
			\ 'substitute(v:val, "^\\s\\+", "", "")')
		" special case: digraph 57344: starts with 2 spaces
		"return filter(dlist, 'v:val =~ "57344$"')
		let idx=match(s:dlist, '57344$')
		let s:dlist[idx]='	 '.s:dlist[idx]

		return s:dlist
	endif
endfu

fu! <sid>CompareList(l1, l2) "{{{1
	return a:l1[1] == a:l2[1] ? 0 : a:l1[1] > a:l2[1] ? 1 : -1
endfu

fu! <sid>CompareDigraphs(d1, d2) "{{{1
	let d1=matchstr(a:d1, '\d\+$')+0
	let d2=matchstr(a:d2, '\d\+$')+0
	if d1 == d2
		return 0
	elseif d1 > d2
		return 1
	else
		return -1
	endif
endfu

fu! <sid>OutputMessage(msg) " {{{1
	redraw
	echohl Title
	if type(a:msg) == type([])
		" List
		for item in a:msg
			echom item
		endfor
	elseif type(a:msg) == type("")
		" string
		echom a:msg
	endif
	echohl Normal
endfu

fu! <sid>WarningMsg(msg) "{{{1
	echohl WarningMsg
	let msg = "UnicodePlugin: " . a:msg
	if exists(":unsilent") == 2
		unsilent echomsg msg
	else
		echomsg msg
	endif
	echohl Normal
endfun

fu! <sid>GetHtmlEntity(hex) "{{{1
	return get(s:html, a:hex, '')
endfu
" Modeline "{{{1
" vim: ts=4 sts=4 fdm=marker com+=l\:\" fdl=0
