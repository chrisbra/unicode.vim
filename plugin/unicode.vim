" unicodePlugin : A completion plugin for Unicode glyphs
" Author: C.Brabandt <cb@256bit.org>
" Version: 0.17
" Copyright: (c) 2009 by Christian Brabandt
"            The VIM LICENSE applies to unicode.vim, and unicode.txt
"            (see |copyright|) except use "unicode" instead of "Vim".
"            No warranty, express or implied.
"  *** ***   Use At-Your-Own-Risk!   *** ***
"
" TODO: enable GLVS:
" GetLatestVimScripts: 2822 17 :AutoInstall: unicode.vim

" ---------------------------------------------------------------------
"  Load Once: {{{1
if &cp || exists("g:loaded_unicodePlugin")
 finish
endif
let g:loaded_unicodePlugin = 1
let s:keepcpo              = &cpo
set cpo&vim

let s:enableUnicodeCompletion = (exists("g:enableUnicodeCompletion") ? g:enableUnicodeCompletion : 0)
" ------------------------------------------------------------------------------
" Public Interface: {{{1
com! EnableUnicodeCompletion call unicode#Init(1)
com! DisableUnicodeCompletion call unicode#Init(0)
com! -nargs=? UnicodeName call unicode#GetUniChar(<q-args>)
com! -nargs=? -bang Digraphs call unicode#OutputDigraphs(<q-args>, <q-bang>)

if s:enableUnicodeCompletion
    exe "call unicode#Init(s:enableUnicodeCompletion)"
    "let s:enableUnicodeCompletion = !s:enableUnicodeCompletion
endif

" =====================================================================
" Restoration And Modelines: {{{1
" vim: fdm=marker
let &cpo= s:keepcpo
unlet s:keepcpo
