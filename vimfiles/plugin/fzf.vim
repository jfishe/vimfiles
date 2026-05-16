if exists('g:loaded_fzf_vim_user') || &compatible
  finish
endif
let g:loaded_fzf_vim_user = 1

let s:cpo_save = &cpo
set cpo&vim

if executable('rg')
  set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case
  set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

if !exists('g:fzf_history_dir')
  let g:fzf_history_dir = vim#XdgSubdir('state', 'fzf')
endif

" let g:fzf_action = {
"       \ 'ctrl-t': 'tab split',
"       \ 'ctrl-x': 'split',
"       \ 'ctrl-v': 'vsplit' }
" https://github.com/junegunn/fzf.vim/issues/54#issuecomment-164488800

let g:fzf_vim = get(g:, 'fzf_vim', {})
let g:fzf_vim.preview_window = ['hidden,right,50%,<70(up,40%)', 'ctrl-w']
let g:fzf_vim.rg_options = ['--bind', 'ctrl-a:select-all,ctrl-d:deselect-all']
let g:fzf_vim['history-files_options'] =
       \ ['--bind', 'ctrl-a:select-all,ctrl-d:deselect-all']


let &cpo = s:cpo_save
unlet s:cpo_save
