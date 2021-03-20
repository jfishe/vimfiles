" Taskwiki user plugin file
if exists('g:loaded_taskwiki_user') || &compatible
  finish
endif
let g:loaded_taskwiki_user = 1

" Taskwiki uses mkview to preserve folds, which conflicts with
" augroup VimwikiTitleJournal set syntax during diff.
let g:taskwiki_dont_preserve_folds = 1

let g:taskwiki_disable_concealcursor = 1

let g:taskwiki_maplocalleader = ',t'
" vim:tabstop=2:shiftwidth=2:expandtab:foldmethod=marker:textwidth=79
