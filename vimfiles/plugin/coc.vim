if executable('node')
  packadd coc.nvim-release
else
  finish
endif

let g:coc_filetype_map = {
      \ 'powershell': 'ps1',
      \ 'pandoc.markdown': 'markdown',
      \ 'pandoc': 'markdown'
      \ }
