if exists('g:loaded_fzf_vim_user') || &compatible
  finish
endif
let g:loaded_fzf_vim_user = 1

let s:cpo_save = &cpo
set cpo&vim

let g:fzf_action = {
      \ 'alt-t': 'tab split',
      \ 'alt-x': 'split',
      \ 'alt-v': 'vsplit' }
" https://github.com/junegunn/fzf.vim/issues/54#issuecomment-164488800
let s:rg_cmd = "rg --column --line-number --no-heading --color=always --smart-case -- "
command! -bang -nargs=* Rg call fzf#vim#grep(
    \ s:rg_cmd..fzf#shellescape(<q-args>),
    \ fzf#vim#with_preview(),
    \ <bang>0
    \ )
command! -bang -nargs=* RG call fzf#vim#grep2(
    \ s:rg_cmd, <q-args>,
    \ fzf#vim#with_preview(),
    \ <bang>0
    \ )

let &cpo = s:cpo_save
unlet s:cpo_save
