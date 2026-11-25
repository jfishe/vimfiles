" Vimwiki user plugin after file
if exists('g:loaded_vimwiki_user_after') || &compatible
  finish
endif
let g:loaded_vimwiki_user_after = 1

" Set wn.zk as default for :ZettelOpen :ZettelInsertNote.
" silent ZettelSetActiveWiki 2

" Nested code block syntaxes are loaded lazily by syntax/vimwiki.vim.

augroup myvimwiki "{{{
  autocmd!
  " autocmd BufRead,BufNewFile *.wiki set filetype=vimwiki
  autocmd QuickFixCmdPost [^l]* cwindow
  autocmd QuickFixCmdPost l*    lwindow
augroup END "}}}
" vim:tabstop=2:shiftwidth=2:expandtab:foldmethod=marker:textwidth=79
