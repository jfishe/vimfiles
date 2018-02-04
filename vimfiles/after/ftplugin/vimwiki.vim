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
function! Nnormalize_mail_v() " {{{
  let l:sel_save = &selection
  let &selection = 'old'
  let l:rv = @"
  let l:rt = getregtype('"')

  " Regex to select e-mail addresses bounded by <...>
  let l:regex_mail = ' <\p\{-}@\p\{-}>'

  try
      " Save selected text to register "
      normal! gv""y

      " Set substitution]]
      " let sub = s:safesubstitute(g:vimwiki_WikiLinkTemplate1,
      "       \ '__LinkUrl__', @", '')
      let l:rxUrl = 'mailto:' . @"

      " Check whether e-mail address is Outlook format, i.e., contains ;
      if match(l:rxUrl, ';') > -1
        " Regex to select , and ; and normalize to mailto URI
        " Todo: Works to find, except without trailing ;
        let l:regex_outlook = '\(\(.*' . l:regex_mail . '\[;$].*\)\@!\),'
        let l:rxUrl = substitute(l:rxUrl, l:regex_outlook, '', 'g')
      endif

      let l:rxDesc = substitute(@", l:regex_mail, '', 'g')
      let l:rxStyle = ''
      let l:sub = vimwiki#base#apply_template(g:vimwiki_WikiLinkTemplate2,
        \ l:rxUrl, l:rxDesc, l:rxStyle)

      " Put substitution in register " and change text
      call setreg('"', l:sub, 'v')
      normal! `>""pgvd
  finally
      call setreg('"', l:rv, l:rt)
      let &selection = l:sel_save
  endtry
endfunction " }}}
