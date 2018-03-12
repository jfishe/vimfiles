"vim-LaTex
"set shellslash
let g:tex_flavor='latex'

" The Silver Searcher
if executable('ag')
    set grepprg=ag\ --vimgrep\ $*
    set grepformat=%f:%l:%c:%m

    " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
    let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

    " ag is fast enough that CtrlP doesn't need to cache
    let g:ctrlp_use_caching = 0
else
    set grepprg=grep\ -nH\ $*
endif
"let g:Tex_UsePython=0
