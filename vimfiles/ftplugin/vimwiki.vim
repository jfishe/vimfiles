" vim:fdm=marker:
" Create a title header for Journal with date. Add a second Contents header
" for auto_TOC.
function! s:TitleJournal() "{{{1
  if exists('*strftime')
    let l:bash = strftime('%Y-%m-%d')
  else
    let l:bash = 'bash -c "date --iso-8601"'
    if $USERDOMAIN ==? '***REMOVED***'
        let l:bash = $LOCALAPPDATA . '\Programs\Git\usr\bin\' . l:bash
    endif
    let l:bash = system(l:bash)[:-2]
  endif

    let l:title = 'Journal ' . l:bash
    let l:failed = append(0, l:title)
    execute 'normal! 1G'
    call vimwiki#base#AddHeaderLevel()

    let l:failed = append(1, 'Contents')
    execute 'normal! 2G'
    call vimwiki#base#AddHeaderLevel()

    execute 'normal! 3G'
endfunction "}}}
nnoremap <silent><buffer> <F3> :call <SID>TitleJournal()<CR>

setlocal spell spelllang=en_us
