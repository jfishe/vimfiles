if exists('b:did_ftplugin_user') || !executable('task')
  finish
endif
let b:did_ftplugin_user = 1  " Don't load another plugin for this buffer

let s:save_cpo = &cpo
set cpo&vim

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

function s:undo_set_var_taskwiki() abort " {{{
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

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><buffer><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR> \| <C-]><Esc>:VimwikiReturn 1 5<CR>"

let b:undo_ftplugin = get(b:, 'undo_ftplugin', '')
if !empty('b:undo_ftplugin')
  let b:undo_ftplugin ..= " | "
endif
let b:undo_ftplugin ..= 'call '..string(function('<SID>undo_set_var_taskwiki'))..'()'
      \ .. " | unlet b:did_ftplugin_user"
      \ .. " | mapclear <buffer>"

let &cpo = s:save_cpo
unlet s:save_cpo
" vim:tabstop=2:shiftwidth=2:expandtab:foldmethod=marker:textwidth=79
