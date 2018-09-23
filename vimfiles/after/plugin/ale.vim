nnoremap <localleader>? :ALEDetail<cr>
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)
nmap <localleader>a <Plug>(ale_toggle)

" ALE refreshes the loclist after vimwiki search, losing the seach results.
" let g:ale_pattern_options = {'\.wiki$': {'ale_enabled': 0}}
