nnoremap <localleader>? :ALEDetail<cr>
nnoremap <silent> <C-k> <Plug>(ale_previous_wrap)
nnoremap <silent> <C-j> <Plug>(ale_next_wrap)
nnoremap <localleader>a <Plug>(ale_toggle)

" ALE refreshes the loclist after vimwiki search, losing the seach results.
" let g:ale_pattern_options = {'\.wiki$': {'ale_enabled': 0}}
