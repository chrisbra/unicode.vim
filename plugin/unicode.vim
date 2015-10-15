" unicodePlugin : A completion plugin for Unicode glyphs
" Author: C.Brabandt <cb@256bit.org>
" Version: 0.20
" Copyright: (c) 2009 by Christian Brabandt
"            The VIM LICENSE applies to unicode.vim, and unicode.txt
"            (see |copyright|) except use "unicode" instead of "Vim".
"            No warranty, express or implied.
"  *** ***   Use At-Your-Own-Risk!   *** ***
"
" TODO: enable GLVS:
" GetLatestVimScripts: 2822 20 :AutoInstall: unicode.vim

" ---------------------------------------------------------------------
"  Load Once: {{{1
if &cp || exists("g:loaded_unicodePlugin")
 finish
endif
let g:loaded_unicodePlugin = 1
let s:keepcpo              = &cpo
set cpo&vim
" ------------------------------------------------------------------------------
" Internal Functions: {{{1
fu! <sid>ToggleUnicodeCompletion() "{{{2
    let g:Unicode_complete_name = (get(g:, 'Unicode_complete_name') == '' ? 1 : !g:Unicode_complete_name)
    echo "Unicode Completion Names " .(g:Unicode_complete_name?'ON':'OFF')
endfu
fu! <sid>UNCompleteList(A,C,P) "{{{2
    if len(split(a:C)) < 2
        return split("abcdefghijklmnopqrstuvwxyz0123456789", '\zs')
    else
        return filter(['digraph','regex','name','html','value'],
            \  'v:val=~#a:A')
    endif
endfu
" Public Interface: {{{1
com! -nargs=* -complete=customlist,<sid>UNCompleteList      UnicodeName	    call unicode#GetUniChar(<f-args>)
com! -nargs=? -bang Digraphs	    call unicode#PrintDigraphs(<q-args>, <q-bang>)
com! -nargs=1       SearchUnicode   call unicode#PrintUnicode(<q-args>)
com!		    UnicodeTable    call unicode#PrintUnicodeTable()
com!		    DownloadUnicode call unicode#Download(1)

" Setup Mappings
nnoremap <unique><script><silent> <Plug>(MakeDigraph)	    :set opfunc=unicode#GetDigraph<CR>g@
vnoremap <unique><script><silent> <Plug>(MakeDigraph)	    :<C-U>call unicode#GetDigraph(visualmode(), 1)<CR>
nnoremap <unique><script><silent> <Plug>(UnicodeGA)	    :<C-U>UnicodeName<CR>
inoremap <unique><script><silent> <Plug>(DigraphComplete)   <C-R>=unicode#CompleteDigraph()<CR>
inoremap <unique><script><silent> <Plug>(UnicodeComplete)   <C-R>=unicode#CompleteUnicode()<CR>
nnoremap <unique><script><silent> <Plug>(UnicodeSwapCompleteName) :<C-U>call <sid>ToggleUnicodeCompletion()<CR>

if !hasmapto('<Plug>(MakeDigraph)', 'n')
    nmap <F4> <Plug>(MakeDigraph)
endif

if !hasmapto('<Plug>(MakeDigraph)', 'v')
    vmap <F4> <Plug>(MakeDigraph)
endif

if !hasmapto('<Plug>(DigraphComplete)', 'i')
    imap <C-X><C-G> <Plug>(DigraphComplete)
endif

if !hasmapto('<Plug>(UnicodeComplete)', 'i')
    imap <C-X><C-Z> <Plug>(UnicodeComplete)
endif

if !hasmapto('<Plug>(UnicodeSwapCompleteName))', 'n')
    nmap <leader>un <Plug>(UnicodeSwapCompleteName)
endif

"if !hasmapto('<Plug>(UnicodeGA)')
"    nmap ga <Plug>(UnicodeGA)
"endif

" =====================================================================
" Restoration And Modelines: {{{1
" vim: fdm=marker
let &cpo= s:keepcpo
unlet s:keepcpo
