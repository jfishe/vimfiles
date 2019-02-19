" Invoke :helptags on all non-$VIM doc directories in pack/*/opt.
function! myhelptags#helptags() abort
  let sep = pathogen#slash()
  let l:vimfiles = fnamemodify(expand('$MYVIMRC'), ':p:h') . sep . 'pack' .sep
  for glob in pathogen#split(glob(l:vimfiles . '*/opt/*' , 1, 1))
    for dir in map(split(glob(glob), "\n"), 'v:val.sep."/doc/".sep')
      if (dir)[0 : strlen($VIMRUNTIME)] !=# $VIMRUNTIME.sep && filewritable(dir) == 2 && !empty(split(glob(dir.'*.txt'))) && (!filereadable(dir.'tags') || filewritable(dir.'tags'))
        silent! execute 'helptags' pathogen#fnameescape(dir)
      endif
    endfor
  endfor
endfunction

" vim:set et sw=2 foldmethod=expr foldexpr=getline(v\:lnum)=~'^\"\ Section\:'?'>1'\:getline(v\:lnum)=~#'^fu'?'a1'\:getline(v\:lnum)=~#'^endf'?'s1'\:'=':
