" unicodePlugin : A completion plugin for Unicode glyphs
" Author: C.Brabandt <cb@256bit.org>
" Version: 0.18
" Copyright: (c) 2009 by Christian Brabandt
"            The VIM LICENSE applies to unicode.vim, and unicode.txt
"            (see |copyright|) except use "unicode" instead of "Vim".
"            No warranty, express or implied.
"  *** ***   Use At-Your-Own-Risk!   *** ***
"
" TODO: enable GLVS:
" GetLatestVimScripts: 2822 18 :AutoInstall: unicode.vim

" ---------------------------------------------------------------------
"  Load Once: {{{1
if &cp || exists("g:loaded_unicodePlugin")
 finish
endif
let g:loaded_unicodePlugin = 1
let s:keepcpo              = &cpo
set cpo&vim
" ------------------------------------------------------------------------------
" Public Interface: {{{1
com! EnableUnicodeCompletion call unicode#Init(1)
com! DisableUnicodeCompletion call unicode#Init(0)
com! -nargs=? UnicodeName call unicode#GetUniChar(<q-args>)
com! -nargs=? -bang Digraphs call unicode#OutputDigraphs(<q-args>, <q-bang>)
com! -nargs=? SearchUnicode call unicode#FindUnicodeByName(<q-args>)

if get(g:, 'enableUnicodeCompletion', 0)
    " prevent sourcing autoload file
    exe "call unicode#Init(s:enableUnicodeCompletion)"
endif

" Setup Mappings
nnoremap <silent> <Plug>(MakeDigraph) :set opfunc=unicode#GetDigraph<CR>g@
vnoremap <silent> <Plug>(MakeDigraph) :<C-U>call unicode#GetDigraph(visualmode(), 1)<CR>

if !hasmapto('<Plug>(MakeDigraph)', 'n')
    nmap <F4> <Plug>(MakeDigraph)
endif

if !hasmapto('<Plug>(MakeDigraph)', 'v')
    vmap <F4> <Plug>(MakeDigraph)
endif

" =====================================================================
" Restoration And Modelines: {{{1
" vim: fdm=marker
let &cpo= s:keepcpo
unlet s:keepcpo
