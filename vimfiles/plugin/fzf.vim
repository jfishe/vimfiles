if exists('g:loaded_fzf_vim_user') || &compatible
  finish
endif
let g:loaded_fzf_vim_user = 1

let s:cpo_save = &cpo
set cpo&vim

" https://github.com/junegunn/fzf.vim/issues/54#issuecomment-164488800
let s:rg_cmd = "rg --column --line-number --no-heading --color=always --smart-case -- "
let s:opts ={
    \ 'options':
    \ ['--bind', 'ctrl-a:select-all,ctrl-d:deselect-all,ctrl-w:toggle-preview']
    \ }
if executable('awk')
    " Shorten ripgrep output path.
    let s:transformer = "| awk -F: 'BEGIN { OFS = FS } {\":\" $2 \":\" $3; print}'"
else
    let s:transformer = ''
endif
command! -bang -nargs=* Rg call fzf#vim#grep(
    \ s:rg_cmd..fzf#shellescape(<q-args>)..s:transformer,
    \ fzf#vim#with_preview(s:opts),
    \ <bang>0
    \ )
command! -bang -nargs=* RG call fzf#vim#grep2(
    \ s:rg_cmd, <q-args>,
    \ fzf#vim#with_preview(s:opts),
    \ <bang>0
    \ )

let &cpo = s:cpo_save
unlet s:cpo_save
