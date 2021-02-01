" unicodePlugin : A completion plugin for Unicode glyphs
" Author: C.Brabandt <cb@256bit.org>
" Version: 0.22
" Copyright: (c) 2009-2020 by Christian Brabandt
"            The VIM LICENSE applies to unicode.vim, and unicode.txt
"            (see |copyright|) except use "unicode" instead of "Vim".
"            No warranty, express or implied.
"  *** ***   Use At-Your-Own-Risk!   *** ***
" TODO: enable GLVS:
" GetLatestVimScripts: 2822 21 :AutoInstall: unicode.vim

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
    let g:Unicode_CompleteName = (get(g:, 'Unicode_CompleteName') == '' ? 1 : !g:Unicode_CompleteName)
    echo "Unicode Completion Names " .(g:Unicode_CompleteName?'ON':'OFF')
endfu
fu! <sid>UNCompleteList(A,C,P) "{{{2
    if len(split(a:C)) < 2
        return split("abcdefghijklmnopqrstuvwxyz0123456789\\+*", '\zs')
    else
        return filter(['digraph','regex','name','html','value'],
            \  'v:val=~#a:A')
    endif
endfu
" Public Interface: {{{1
com! -nargs=* -complete=customlist,<sid>UNCompleteList      UnicodeName	    call unicode#GetUniChar(<f-args>)
com! -nargs=? -bang Digraphs	    call unicode#PrintDigraphs(<q-args>, <q-bang>)
" deprecated
com! -nargs=1       SearchUnicode   call unicode#PrintUnicode(<q-args>, '')
com! -nargs=1 -bang UnicodeSearch   call unicode#PrintUnicode(<q-args>, <q-bang>=='!')
com! -bang -bar     UnicodeTable    call unicode#PrintUnicodeTable(<q-bang>=='!')
com! -nargs=1       DigraphNew	    call unicode#MkDigraphNew(<f-args>)
com!                UnicodeCache    call unicode#MkCache()
" deprecated
com!		    DownloadUnicode call unicode#Download(1)
com!		    UnicodeDownload call unicode#Download(1)

" Setup Mappings
nnoremap <unique><script><silent> <Plug>(MakeDigraph)	    :set opfunc=unicode#GetDigraph<CR>g@
vnoremap <unique><script><silent> <Plug>(MakeDigraph)	    :<C-U>call unicode#GetDigraph(visualmode(), 1)<CR>
nnoremap <unique><script><silent> <Plug>(UnicodeGA)	    :<C-U>UnicodeName<CR>
inoremap <unique><script><silent> <Plug>(DigraphComplete)   <C-R>=unicode#CompleteDigraph()<CR>
inoremap <unique><script><silent> <Plug>(UnicodeComplete)   <C-R>=unicode#CompleteUnicode()<CR>
inoremap <unique><script><silent> <Plug>(HTMLEntityComplete)   <C-R>=unicode#CompleteHTMLEntity()<CR>
inoremap <unique><script><silent> <Plug>(UnicodeFuzzy) <C-\><C-O>:call unicode#Fuzzy()<CR>
nnoremap <unique><script><silent> <Plug>(UnicodeSwapCompleteName) :<C-U>call <sid>ToggleUnicodeCompletion()<CR>

if !(exists("g:Unicode_no_default_mappings") && g:Unicode_no_default_mappings)
    if !hasmapto('<Plug>(MakeDigraph)', 'n') && maparg('<f4>', 'n') ==# ''
        nmap <F4> <Plug>(MakeDigraph)
    endif

    if !hasmapto('<Plug>(MakeDigraph)', 'v') && maparg('<f4>', 'v') ==# ''
        vmap <F4> <Plug>(MakeDigraph)
    endif

    if !hasmapto('<Plug>(DigraphComplete)', 'i') && maparg('<c-x><c-g>', 'i') ==# ''
        imap <C-X><C-G> <Plug>(DigraphComplete)
    endif

    if !hasmapto('<Plug>(UnicodeComplete)', 'i') && maparg('<c-x><c-z>', 'i') ==# ''
        imap <C-X><C-Z> <Plug>(UnicodeComplete)
    endif

    if !hasmapto('<Plug>(HTMLEntityComplete)', 'i') && maparg('<c-x><c-b>', 'i') ==# ''
        imap <C-X><C-B> <Plug>(HTMLEntityComplete)
    endif

    if !hasmapto('<Plug>(UnicodeFuzzy)', 'i') && maparg('<c-g><c-f>', 'i') ==# ''
        imap <C-G><C-F> <Plug>(UnicodeFuzzy)
    endif

    if !hasmapto('<Plug>(UnicodeSwapCompleteName)', 'n') && maparg('<leader>un', 'n') ==# ''
        nmap <leader>un <Plug>(UnicodeSwapCompleteName)
    endif

"    if !hasmapto('<Plug>(UnicodeGA)')
"        nmap ga <Plug>(UnicodeGA)
"    endif
endif

" =====================================================================
" Restoration And Modelines: {{{1
" vim: fdm=marker
let &cpo= s:keepcpo
unlet s:keepcpo
