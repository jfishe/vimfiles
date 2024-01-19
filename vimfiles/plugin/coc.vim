if executable('node')
  packadd coc.nvim
else
  finish
endif

let g:coc_filetype_map = {
      \ 'powershell': 'ps1',
      \ 'vimwiki': 'markdown',
      \ 'pandoc.markdown': 'markdown',
      \ 'pandoc': 'markdown'
      \ }
