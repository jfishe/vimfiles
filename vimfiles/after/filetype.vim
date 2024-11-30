if exists('did_load_filetypes_userafter')
  finish
else
  let did_load_filetypes_userafter = 1
endif
augroup html5_setup "{{{
  autocmd!
  " autocmd BufNewFile,BufFilePre,BufRead *.html5 set syntax=html
  autocmd BufNewFile,BufFilePre,BufRead *.html5 set filetype=html
augroup END "}}}
augroup markdownpp "{{{
  autocmd!
  autocmd BufNewFile,BufFilePre,BufRead *.mdpp set filetype=vimwiki
augroup END "}}}
augroup mynetrw " {{{
  autocmd!
  autocmd FileType netrw nnoremap <silent><buffer> g? :<C-U>help netrw-quickmap<CR>
augroup END " }}}
augroup myfugitive " {{{
  autocmd!
  autocmd FileType fugitive nmap <silent><buffer> cnv :<C-U>Git commit --no-verify<CR>
augroup END " }}}
