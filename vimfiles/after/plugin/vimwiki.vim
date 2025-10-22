" Vimwiki user plugin after file
if exists('g:loaded_vimwiki_user_after') || &compatible
  finish
endif
let g:loaded_vimwiki_user_after = 1

" Set wn.zk as default for :ZettelOpen :ZettelInsertNote.
" silent ZettelSetActiveWiki 2

" Return: list of extension known by vimwiki
function! s:vimwiki_get_known_extensions() abort " {{{
  " Getting all extensions that different wikis could have
  let extensions = {}
  for idx in range(vimwiki#vars#number_of_wikis())
    let ext = vimwiki#vars#get_wikilocal('ext', idx)
    let extensions[ext] = 1
  endfor
  " append extensions from g:vimwiki_ext2syntax
  for ext in keys(vimwiki#vars#get_global('ext2syntax'))
    let extensions[ext] = 1
  endfor
  return keys(extensions)
endfunction " }}}

" Autocommand called when Vim opens a new buffer with a known wiki
" extension. Both when the buffer has never been opened in this session and
" when it has.
function s:setup_nested_syntaxes() abort " {{{
  call vimwiki#vars#set_wikilocal("nested_syntaxes",
        \ vimwiki#vars#get_wikilocal("nested_syntaxes",1))
  silent call vimwiki#u#ft_set()
endfunction " }}}

" Define autocommands for all known wiki extensions
let s:known_extensions = s:vimwiki_get_known_extensions()

augroup myvimwiki "{{{
  autocmd!
  " autocmd BufRead,BufNewFile *.wiki set filetype=vimwiki
  autocmd QuickFixCmdPost [^l]* cwindow
  autocmd QuickFixCmdPost l*    lwindow

  let pat = join(map(s:known_extensions, '"*" . v:val'), ',')
  execute 'autocmd BufEnter,BufNewFile,BufRead,BufWinEnter ' .. pat ..
        \ ' call s:setup_nested_syntaxes()'
augroup END "}}}
" vim:tabstop=2:shiftwidth=2:expandtab:foldmethod=marker:textwidth=79
