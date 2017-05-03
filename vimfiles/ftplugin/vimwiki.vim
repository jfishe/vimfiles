function! s:TitleJournal()
    execute 'normal! ggOJournal '
    read! bash -c "date --iso-8601"
    execute "normal! kJ"
    call vimwiki#base#AddHeaderLevel()
endfunction
nnoremap <buffer> <F3> :call <SID>TitleJournal()<CR>

setlocal spell spelllang=en_us
