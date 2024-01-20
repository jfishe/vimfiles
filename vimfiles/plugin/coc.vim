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
