" Create a title header for Journal with date. Add a second Contents header
" for auto_TOC.
function! s:TitleJournal()
    execute 'normal! ggOJournal '
    read! bash -c "date --iso-8601"
    execute 'normal! kJ'
    call vimwiki#base#AddHeaderLevel()
    execute 'normal! j'
    execute 'normal! ggoContents'
    call vimwiki#base#AddHeaderLevel()
    execute 'normal! j'
endfunction
nnoremap <buffer> <F3> :call <SID>TitleJournal()<CR>

setlocal spell spelllang=en_us
