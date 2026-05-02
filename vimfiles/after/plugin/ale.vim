" nnoremap <localleader>? :ALEDetail<cr>
" nmap <silent> <C-k> <Plug>(ale_previous_wrap)
" nmap <silent> <C-j> <Plug>(ale_next_wrap)
" nmap <localleader>a <Plug>(ale_toggle)

" ALE refreshes the loclist after vimwiki search, losing the seach results.
" let g:ale_pattern_options = {'\.wiki$': {'ale_enabled': 0}}
let g:ale_linters_explicit = 1

let g:ale_echo_cursor = v:false
let g:ale_virtualtext_cursor = 'disabled'

" let g:ale_set_signs = v:false
" let g:ale_set_highlights = v:false
