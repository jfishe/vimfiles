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

