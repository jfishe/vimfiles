command! -nargs=0 GutentagsClearCache call system('rm ' . g:gutentags_cache_dir . '/*')

" See ~/.ctags.d/default.ctags for global Universal Ctags defaults.
let g:gutentags_ctags_exclude = [ '.git', '.vscode', '.vscode-insiders' ]
" let g:gutentags_trace = 1
