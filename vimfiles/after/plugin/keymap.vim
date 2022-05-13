" Workaround for |UltiSnips-trigger-key-mappings| interferes with <c-k>.
inoremap <c-x><c-k> <c-x><c-k>

" Override <C-L> from vim-sensible to clear popup artifact from [LS].
function s:Redraw() abort
  if has('diff')
    diffupdate
  endif
  if has('popupwin')
    call popup_clear()
  endif
  redraw!
endfunction
nnoremap <C-L> :nohlsearch <Bar> call <SID>Redraw()<CR>
