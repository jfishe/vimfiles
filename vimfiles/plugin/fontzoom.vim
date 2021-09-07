" https://github.com/thinca/vim-fontzoom.git
if exists('g:loaded_fontzoom_user') || !has('gui_running')
  finish
endif
let g:loaded_fontzoom_user = 1

let s:save_cpo = &cpo
set cpo&vim

let g:fontzoom_no_default_key_mappings = 1
silent! nmap <unique> <silent> <Leader>+ <Plug>(fontzoom-larger)
silent! nmap <unique> <silent> <Leader>- <Plug>(fontzoom-smaller)

let &cpo = s:save_cpo
unlet s:save_cpo
