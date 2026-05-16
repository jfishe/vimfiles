" Pandoc User Autoload
if exists('g:loaded_vim_user_after_auto') || &compatible
  finish
endif
let g:loaded_vim_user_after_auto = 1

" kind must be one of: 'data', 'config', 'cache', 'state'
function! vim#XdgPath(kind) abort
  let l:kind = a:kind
  let l:is_win = has('win32') || has('win64')

  if exists('*stdpath')
    let l:path = stdpath(l:kind)
  elseif l:is_win
    " Windows XDG-equivalent defaults
    if l:kind ==# 'data'
      let l:path = exists('$LOCALAPPDATA') ? $LOCALAPPDATA : $APPDATA
    elseif l:kind ==# 'config'
      let l:path = exists('$APPDATA') ? $APPDATA : $LOCALAPPDATA
    elseif l:kind ==# 'cache'
      let l:path = exists('$LOCALAPPDATA') ? $LOCALAPPDATA : $TEMP
    elseif l:kind ==# 'state'
      " No Windows equivalent → use LOCALAPPDATA/state
      let l:base = exists('$LOCALAPPDATA') ? $LOCALAPPDATA : $APPDATA
      let l:path = l:base . '/state'
    else
      throw 'Invalid XDG kind: ' . l:kind
    endif
  else
    " POSIX XDG defaults
    if l:kind ==# 'data'
      let l:path = exists('$XDG_DATA_HOME') ? $XDG_DATA_HOME : ($HOME . '/.local/share')
    elseif l:kind ==# 'config'
      let l:path = exists('$XDG_CONFIG_HOME') ? $XDG_CONFIG_HOME : ($HOME . '/.config')
    elseif l:kind ==# 'cache'
      let l:path = exists('$XDG_CACHE_HOME') ? $XDG_CACHE_HOME : ($HOME . '/.cache')
    elseif l:kind ==# 'state'
      let l:path = exists('$XDG_STATE_HOME') ? $XDG_STATE_HOME : ($HOME . '/.local/state')
    else
      throw 'Invalid XDG kind: ' . l:kind
    endif
  endif

  " Normalize slashes and resolve ~
  return fnamemodify(l:path, ':p')
endfunction

function! vim#XdgSubdir(kind, path) abort
  let l:base = substitute(vim#XdgPath(a:kind), '[/\\]\+$', '', '')
  return l:base .. '/' .. a:path
endfunction

function! vim#RgCommandPrefix() abort
  return 'rg --column --line-number --smart-case --no-heading --color=always'
endfunction
