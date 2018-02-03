" vim:tabstop=2:shiftwidth=2:expandtab:foldmethod=marker:textwidth=79
" Use lgrep so that ag peforms search
augroup myvimwiki
  autocmd!
  autocmd QuickFixCmdPost [^l]* cwindow
  autocmd QuickFixCmdPost l*    lwindow
augroup END
" The Silver Searcher
" See plugin/tex.vim.
" set grepprg=ag\ --nogroup\ --nocolor\ $*
if executable('ag')
  exe 'command! -buffer -nargs=+ VWS silent lgrep! <args> -G '.
      \ escape('"^.*/*'.VimwikiGet('ext').'"', ' '). ' '.
      \ shellescape(VimwikiGet('path'), ' ')
  command! -buffer -nargs=* -complete=custom,vimwiki#tags#complete_tags
      \ VWT VWS :<args>:
endif

" Convert selected text in VimWikiLink

" s:safesubstitute
" function! s:safesubstitute(text, search, replace, mode) "{{{
"   " Substitute regexp but do not interpret replace
"   let escaped = escape(a:replace, '\&')
"   return substitute(a:text, a:search, escaped, a:mode)
" endfunction " }}}

" templates for the creation of wiki links
" [[URL]]
" let g:vimwiki_WikiLinkTemplate1 = s:wikilink_prefix . '__LinkUrl__'.
"       \ s:wikilink_suffix
" " [[URL|DESCRIPTION]]
" let g:vimwiki_WikiLinkTemplate2 = s:wikilink_prefix . '__LinkUrl__'.
"       \ s:wikilink_separator . '__LinkDescription__' . s:wikilink_suffix

function! Nnormalize_mail_v() " {{{
  let sel_save = &selection
  let &selection = 'old'
  let rv = @"
  let rt = getregtype('"')

  " let regex_mail = '%s/\%V <\p\{-}@\p\{-}>//g'
  let regex_mail = ' <\p\{-}@\p\{-}>'

  try
      " Save selected text to register "
      normal! gv""y

      " Set substitution]]
      " let sub = s:safesubstitute(g:vimwiki_WikiLinkTemplate1,
      "       \ '__LinkUrl__', @", '')
      let rxUrl = 'mailto:' . @"
      let rxDesc = substitute(@", regex_mail, '', 'g')
      let rxStyle = ''
      let sub = vimwiki#base#apply_template(g:vimwiki_WikiLinkTemplate2,
        \ rxUrl, rxDesc, rxStyle)

      " Put substitution in register " and change text
      call setreg('"', sub, 'v')
      normal! `>""pgvd
  finally
      call setreg('"', rv, rt)
      let &selection = sel_save
  endtry
endfunction " }}}
