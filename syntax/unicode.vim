" Start: Standard vim script cruft {{{2
let s:cpo_save = &cpo
set cpo&vim

scriptencoding utf8
if version < 600
    syn clear
elseif exists("b:current_syntax")
    finish
endif

" Simple syntax highlighting for UnicodeTable command {{{2
syn match UnicodeHeader /\%(^\%1l.*\)\|\%(^\%>2l\S\+\)/   " highlight Heading and Character
syn match UnicodeDigraph /\%>1l(\zs\(\S\+\s*\)\+\ze)/     " highlight html and digraph
syn match UnicodeHtmlEntity /&\w*;\|&#x\x\+;/             " highlight html
syn match UnicodeCodepoint /U+\x\+/                       " highlight U+FFFE
syn match UnicodeLink   /http:.*$/                        " highlight html link

hi def link UnicodeHeader     Title
hi def link UnicodeDigraph    Statement
hi def link UnicodeHtmlEntity Statement
hi def link UnicodeCodepoint  Constant
hi def link UnicodeLink       Underlined

" Set the syntax variable
let b:current_syntax="unicode"

" End: Standard vim script cruft {{{2
let &cpo = s:cpo_save
unlet s:cpo_save
