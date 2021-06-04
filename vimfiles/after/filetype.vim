if exists('did_load_filetypes_userafter')
  finish
endif
augroup html5_setup
  autocmd!
  " autocmd BufNewFile,BufFilePre,BufRead *.html5 set syntax=html
  autocmd BufNewFile,BufFilePre,BufRead *.html5 set filetype=html
augroup END
augroup json_comment
  autocmd!
  autocmd BufNewFile,BufRead *.json set filetype=jsonc
augroup END
