nnoremap <localleader>? :ALEDetail<cr>
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)
let g:ale_fixers = {
\   'markdown': [
\       'prettier'
\   ],
\}
