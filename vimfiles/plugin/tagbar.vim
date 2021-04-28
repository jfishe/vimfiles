" Tagbar user plugin file

if exists('g:loaded_tagbar_user') || &compatible
  finish
endif
let g:loaded_tagbar_user = 1

" Whether line numbers should be shown in the Tagbar window.
let g:tagbar_show_tag_linenumbers = -1

" vim:tabstop=2:shiftwidth=2:expandtab:foldmethod=marker:textwidth=79
