" GitHub Copilot user plugin file
if exists('g:loaded_copilot_user') || &compatible || !executable('copilot')
  finish
endif
let g:loaded_copilot_user = 1

function! s:coc_pum_visible() abort
  return exists('*coc#pum#visible') && coc#pum#visible()
endfunction

function! s:coc_inline_visible() abort
  return exists('*coc#inline#visible') && coc#inline#visible()
endfunction

function! s:copilot_visible() abort
  return exists('*copilot#GetDisplayedSuggestion')
        \ && !empty(get(copilot#GetDisplayedSuggestion(), 'text', ''))
endfunction

function! s:copilot_next(fallback) abort
  return <SID>copilot_visible() ? copilot#Next() : a:fallback
endfunction

function! s:copilot_previous(fallback) abort
  return <SID>copilot_visible() ? copilot#Previous() : a:fallback
endfunction

function! s:copilot_dismiss(fallback) abort
  return <SID>copilot_visible() ? copilot#Dismiss() : a:fallback
endfunction

function! s:copilot_accept(fallback) abort
  return exists('*copilot#Accept') ? copilot#Accept(a:fallback) : a:fallback
endfunction

inoremap <silent><expr> <C-n>
      \ <SID>coc_pum_visible() ? coc#pum#next(1) :
      \ <SID>coc_inline_visible() ? coc#inline#next() :
      \ <SID>copilot_next("\<C-n>")
inoremap <silent><expr> <C-p>
      \ <SID>coc_pum_visible() ? coc#pum#prev(1) :
      \ <SID>coc_inline_visible() ? coc#inline#prev() :
      \ <SID>copilot_previous("\<C-p>")
inoremap <silent><expr> <Down>
      \ <SID>coc_pum_visible() ? coc#pum#next(0) :
      \ <SID>coc_inline_visible() ? coc#inline#next() :
      \ <SID>copilot_next("\<Down>")
inoremap <silent><expr> <Up>
      \ <SID>coc_pum_visible() ? coc#pum#prev(0) :
      \ <SID>coc_inline_visible() ? coc#inline#prev() :
      \ <SID>copilot_previous("\<Up>")
inoremap <silent><expr> <C-e>
      \ <SID>coc_pum_visible() ? coc#pum#cancel() :
      \ <SID>coc_inline_visible() ? coc#inline#cancel() :
      \ <SID>copilot_dismiss("\<C-e>")
inoremap <silent><expr> <C-y>
      \ <SID>coc_pum_visible() ? coc#pum#confirm() :
      \ <SID>coc_inline_visible() ? coc#inline#accept() :
      \ <SID>copilot_accept("\<C-y>")
inoremap <silent><expr> <PageDown>
      \ <SID>coc_pum_visible() ? coc#pum#scroll(1) :
      \ <SID>copilot_next("\<PageDown>")
inoremap <silent><expr> <PageUp>
      \ <SID>coc_pum_visible() ? coc#pum#scroll(0) :
      \ <SID>copilot_previous("\<PageUp>")

" Keep CoC in charge of popup completion and use a Windows-safe explicit
" Copilot accept key that does not rely on Alt/meta terminal mappings.
inoremap <silent><script><expr> <C-L> copilot#Accept('')
