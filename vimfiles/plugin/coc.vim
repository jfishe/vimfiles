" Conquer of Completion (coc) user plugin file
if exists('g:loaded_coc_user') || &compatible
  finish
endif
let g:loaded_coc_user = 1

" coc.nvim requires at least Vim 9.0.0438 or Neovim 0.8.0, but you're using an older version.
" Please upgrade your (neo)vim.
" You can add this to your vimrc to avoid this message:
"     let g:coc_disable_startup_warning = 1
" Note that some features may error out or behave incorrectly.
" Please do not report bugs unless you're using at least Vim 9.0.0438 or Neovim 0.8.0.
let g:coc_disable_startup_warning = 1

if executable('node')
  packadd coc.nvim
else
  finish
endif

" augroup VimwikiCocEnable should set b:coc_enabled=0 for Vimwiki default
" syntax to avoid linting errors.
let g:coc_filetype_map = {
      \ 'powershell': 'ps1',
      \ 'vimwiki': 'markdown',
      \ 'pandoc.markdown': 'markdown',
      \ 'pandoc': 'markdown'
      \ }
