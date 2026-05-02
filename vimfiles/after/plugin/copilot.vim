if !exists('g:loaded_copilot')
  finish
endif
if exists('g:loaded_copilot_user_after') || v:version < 800
  finish
endif
let g:loaded_copilot_user_after = 1

" Keep CoC in charge of popup completion and use a Windows-safe explicit
" Copilot accept key that does not rely on Alt/meta terminal mappings.
inoremap <silent><script><expr> <C-L> copilot#Accept('')
