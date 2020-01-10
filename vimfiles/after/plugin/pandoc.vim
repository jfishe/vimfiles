let g:pandoc#command#templates_file = split(&runtimepath, ",")[0]."/vim-pandoc-templates"

let g:coc_filetype_map = {
  \ 'pandoc.markdown': 'markdown',
  \ 'pandoc': 'markdown'
  \}

" augroup pandoc_setup
"     autocmd!
"      " Enable markdown so ale will apply prettier, etc.
"      autocmd BufNewFile,BufFilePre,BufRead *.md set filetype=pandoc.markdown
"      autocmd BufNewFile,BufFilePre,BufRead *.mdpp set filetype=pandoc.markdown
" augroup END
