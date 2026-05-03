if exists('b:did_ftplugin_user') || !executable('task')
  finish
endif
let b:did_ftplugin_user = 1  " Don't load another plugin for this buffer

let s:save_cpo = &cpo
set cpo&vim

function! s:is_temp_wiki() abort
  return exists('b:vimwiki_wiki_nr')
        \ && vimwiki#vars#get_wikilocal('is_temporary_wiki', b:vimwiki_wiki_nr)
endfunction

function! s:undo_temp_taskwiki_disable() abort
  unlet! b:did_ftplugin_taskwiki_after b:taskwiki_temp_wiki_disable
endfunction

if s:is_temp_wiki()
  let b:taskwiki_temp_wiki_disable = get(g:, 'taskwiki_disable', '')
  if empty(b:taskwiki_temp_wiki_disable)
    let g:taskwiki_disable = 'disable'
  endif
  let b:did_ftplugin_taskwiki_after = 1

  let b:undo_ftplugin = get(b:, 'undo_ftplugin', '')
  if ! empty(b:undo_ftplugin)
    let b:undo_ftplugin ..= " | "
  endif
  let b:undo_ftplugin ..= 'call '
        \ .. string(function('<SID>undo_temp_taskwiki_disable')) .. '()'
        \ .. " | unlet b:did_ftplugin_user"

  let &cpo = s:save_cpo
  unlet s:save_cpo
  finish
endif

" Taskwarrior Taskwiki TASKRC TASKDATA {{{1
let b:undo_taskwiki_taskrc_location = get(g:, 'taskwiki_taskrc_location', '')
let b:undo_taskwiki_data_location  = get(g:, 'taskwiki_data_location', '')

let g:taskwiki_taskrc_location = vimwiki#path#path_norm(
  \ vimwiki#path#join_path(
  \ vimwiki#vars#get_wikilocal('path'), '.taskrc'
  \ ))
let g:taskwiki_data_location = vimwiki#path#path_norm(
  \ vimwiki#path#join_path(
  \ vimwiki#vars#get_wikilocal('path'), '.task'
  \ ))

function s:undo_set_var_taskwiki() abort " {{{2
  if !empty(b:undo_taskwiki_taskrc_location)
    let g:taskwiki_taskrc_location = b:undo_taskwiki_taskrc_location
  else
    unlet g:taskwiki_taskrc_location
  endif
  if !empty(b:undo_taskwiki_data_location)
    let g:taskwiki_data_location = b:undo_taskwiki_data_location
  else
    unlet g:taskwiki_data_location
  endif
  unlet b:undo_taskwiki_taskrc_location b:undo_taskwiki_data_location
endfunction " }}}

let b:undo_ftplugin = get(b:, 'undo_ftplugin', '')
if ! empty(b:undo_ftplugin)
  let b:undo_ftplugin ..= " | "
endif
let b:undo_ftplugin ..= 'call '..string(function('<SID>undo_set_var_taskwiki'))..'()'
      \ .. " | unlet b:did_ftplugin_user"
      \ .. " | mapclear <buffer>"
" }}}

" Commands {{{
command! -buffer VimwikiRemoveTaskwiki call vimwiki#RemoveTaskwikiViewport()
" }}}

let &cpo = s:save_cpo
unlet s:save_cpo
" vim:tabstop=2:shiftwidth=2:expandtab:foldmethod=marker:textwidth=79
