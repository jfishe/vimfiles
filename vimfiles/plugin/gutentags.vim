command! -nargs=0 GutentagsClearCache call system('rm ' . g:gutentags_cache_dir . '/*')

" See ~/.gutctags
let g:gutentags_ctags_exclude = [ '.git', '.vscode', '.vscode-insiders' ]
" let g:gutentags_trace = 1
