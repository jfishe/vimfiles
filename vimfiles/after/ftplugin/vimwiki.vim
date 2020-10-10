" VimWiki ftplugin {{{
if exists('b:did_ftplugin_user_after')
  finish
endif
let b:did_ftplugin_user_after = 1  " Don't load another plugin for this buffer

augroup myvimwiki "{{{
  autocmd!
  " autocmd BufRead,BufNewFile *.wiki set filetype=vimwiki
  autocmd QuickFixCmdPost [^l]* cwindow
  autocmd QuickFixCmdPost l*    lwindow
augroup END "}}}

" Use vim-ripgrep for VimwikiSearch {{{
command! -buffer -nargs=* VWS call vimwiki#searchRg(<q-args>)
command! -buffer -nargs=* -complete=custom,vimwiki#tags#complete_tags
      \ VWT VWS /:<args>:/
" }}}

" Convert selected text to VimWikiLink {{{
vnoremap <silent><localleader>m
  \ :call vimwiki#myvimwiki_normalize_mail_v()<CR>
"}}}

" setlocal isfname+=32         "so gf treats spaces as part of valid file name.
let g:ale_enabled=0

" Create today's Journal and compare to previous day. {{{
nnoremap <silent><buffer> <F3> :call vimwiki#TitleJournal()<CR>
"}}}

setlocal spell spelllang=en_us
" vim:tabstop=2:shiftwidth=2:expandtab:foldmethod=marker:textwidth=79
" }}}
