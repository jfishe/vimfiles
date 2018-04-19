" Create a title header for Journal with date. Add a second Contents header
" for auto_TOC.
function! s:TitleJournal()
    let l:bash = 'bash -c "date --iso-8601"'
    if $COMPUTERNAME ==? '***REMOVED***'
        let l:bash = $LOCALAPPDATA . '\Programs\Git\usr\bin\' . l:bash
    endif
    let l:bash = system(l:bash)[:-2]

    let l:title = 'Journal ' . l:bash
    let l:failed = append(0, l:title)
    execute 'normal! 1G'
    call vimwiki#base#AddHeaderLevel()

    let l:failed = append(1, 'Contents')
    execute 'normal! 2G'
    call vimwiki#base#AddHeaderLevel()
endfunction
nnoremap <buffer> <F3> :call <SID>TitleJournal()<CR>

setlocal spell spelllang=en_us
