" VimWiki ftplugin {{{
if exists('b:did_ftplugin_user_after')
  finish
endif
let b:did_ftplugin_user_after = 1  " Don't load another plugin for this buffer

let s:save_cpo = &cpo
set cpo&vim

augroup myvimwiki "{{{
  autocmd!
  " autocmd BufRead,BufNewFile *.wiki set filetype=vimwiki
  autocmd QuickFixCmdPost [^l]* cwindow
  autocmd QuickFixCmdPost l*    lwindow
augroup END "}}}

" Use vim-ripgrep for VimwikiSearch {{{
command! -buffer -nargs=* VWS call vimwiki#searchRg(<q-args>)
command! -buffer -nargs=* -complete=custom,vimwiki#tags#complete_tags
      \ VWT VWS /:<args>:/
" }}}

" Convert selected text to VimWikiLink {{{
let g:maplocalleader = ','
vnoremap <silent><buffer> <localleader>m
  \ :call vimwiki#myvimwiki_normalize_mail_v()<CR>
"}}}

let b:ale_enabled=0

" Create today's Journal and compare to previous day. {{{
nnoremap <silent><buffer> <F3> :call vimwiki#TitleJournal()<CR>
"}}}

setlocal spell spelllang=en_us

let b:undo_ftplugin = get(b:, 'undo_ftplugin', '')
if !empty('b:undo_ftplugin')
  let b:undo_ftplugin ..= " | "
endif
let b:undo_ftplugin ..= "delcommand VWS"
      \ .. " | delcommand VWT"
      \ .. " | unlet b:did_ftplugin_user_after b:ale_enabled"
      \ .. ' | execute "nunmap <buffer> <F3>"'
      \ .. " | setlocal spell< spelllang<"
      \ .. " | autocmd! myvimwiki"

let &cpo = s:save_cpo
unlet s:save_cpo
" vim:tabstop=2:shiftwidth=2:expandtab:foldmethod=marker:textwidth=79
" }}}
