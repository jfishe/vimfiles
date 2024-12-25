if exists('g:loaded_fzf_vim_user_after') || &compatible
  finish
endif
let g:loaded_fzf_vim_user_after = 1

let s:cpo_save = &cpo
set cpo&vim

nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)
imap <c-x><c-k> <plug>(fzf-complete-word)

if executable('fdfind')
  inoremap <expr> <c-x><c-f> fzf#vim#complete#path('fdfind')
elseif executable('fd')
  inoremap <expr> <c-x><c-f> fzf#vim#complete#path('fd')
else
  " imap <c-x><c-f> <plug>(fzf-complete-path)
  inoremap <expr> <c-x><c-f> fzf#vim#complete#path('rg --files')
endif

let &cpo = s:cpo_save
unlet s:cpo_save
