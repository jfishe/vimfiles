" For commands VimwikiSearch and VWS
" Use Rg and QuickFixWindow instead of lvimgrep in VWS and VWT.
function! vimwiki#searchRg(search_pattern) abort
  if !exists(':Rg')
    call vimwiki#base#search(a:search_pattern)
    return
  endif

  if empty(a:search_pattern)
    let pattern = expand("<cword>")
  else
    let pattern = a:search_pattern
  endif

  " If the pattern does not start with a '/', then we'll assume that a
  " literal search is intended and enclose and escape it:
  if match(pattern, '^/') == -1
    let pattern = shellescape(escape(pattern, '\'))
  else
    let pattern = pattern[1:-2]
    let pattern = shellescape(pattern)
  endif

  let path = fnameescape(vimwiki#vars#get_wikilocal('path'))
  let ext  = vimwiki#vars#get_wikilocal('ext')

  let cmd  = 'Rg '.pattern.' '.path.' --glob '.shellescape('**/*'.ext)
  execute cmd
endfunction
