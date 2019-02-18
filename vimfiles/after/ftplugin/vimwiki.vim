" vim:tabstop=2:shiftwidth=2:expandtab:foldmethod=marker:textwidth=79
augroup myvimwiki
  autocmd!
  autocmd QuickFixCmdPost [^l]* cwindow
  autocmd QuickFixCmdPost l*    lwindow
augroup END

" Use lgrep so that ag peforms search
" The Silver Searcher
" See plugin/tex.vim.
" set grepprg=ag\ --nogroup\ --nocolor\ $*
if executable('ag')
  exe 'command! -buffer -nargs=+ VWS silent lgrep! <args> -G '.
      \ escape('"^.*/*'.vimwiki#vars#get_wikilocal('ext').'"', ' '). ' '.
      \ '"'.vimwiki#vars#get_wikilocal('path')[:-2].'"'
  command! -buffer -nargs=* -complete=custom,vimwiki#tags#complete_tags
      \ VWT VWS :<args>:
endif

" Convert selected text to VimWikiLink
" Todo: Limit the length of the URI to 2083 per
"       https://stackoverflow.com/questions/417142/what-is-the-maximum-length-of-a-url-in-different-browsers
"       by splitting into multiple links.
function! s:myvimwiki_normalize_mail_v() " {{{
  let l:sel_save = &selection
  let &selection = 'old'
  let l:rv = @"
  let l:rt = getregtype('"')

  " Regex to select e-mail addresses bounded by <...>
  let l:regex_mail = ' <\p\{-}@\p\{-}>'

  try
    " Save selected text to register "
    normal! gv""y

    " Set substitution
    let l:rxUrl = @"

    " Strip single quoted e-mail address in Description for style.
    let l:rxDesc = substitute(l:rxUrl, "'", "", "g")
    " Escape single quoted e-mail address in URI, so that URI parses correctly
    " when opened. Double-quotes get stripped when URI is parsed anyway.
    let l:rxUrl = 'mailto:' . substitute(l:rxUrl, "'", "''", "g")

    " Check whether e-mail address is Outlook format, i.e., contains ;
    if match(l:rxUrl, ';') > -1
      " Regex to select ; and normalize to mailto URI format. Gmail, e.g.
      " does not allow commas in the address, since that is the address
      " separator. Gmail doesn't care whether , or ; is used as the address
      " separator.
      let l:regex_outlook = '\(\(.*' . l:regex_mail . '\[;$].*\)\@!\),'
      let l:rxUrl = substitute(l:rxUrl, l:regex_outlook, '', 'g')
    endif

    let l:rxDesc = substitute(l:rxDesc, l:regex_mail, '', 'g')
    let l:rxStyle = ''
    let l:sub = vimwiki#base#apply_template(
          \ vimwiki#vars#get_global('WikiLinkTemplate2'),
          \ l:rxUrl, l:rxDesc, l:rxStyle)

    " Put substitution in register " and change text
    call setreg('"', l:sub, 'v')
    normal! `>""pgvd
  finally
      call setreg('"', l:rv, l:rt)
      let &selection = l:sel_save
  endtry
endfunction " }}}
vnoremap <silent><localleader>m
  \ :call <SID>myvimwiki_normalize_mail_v()<CR>

setlocal isfname+=32         "so gf treats spaces as part of valid file name.
let g:ale_enabled=0

" Create a title header for Journal with date. Add a second Contents header
" for auto_TOC.
function! s:TitleJournal() "{{{1
  if exists('*strftime')
    let l:bash = strftime('%Y-%m-%d')
  else
    let l:bash = 'bash -c "date --iso-8601"'
    if $USERDOMAIN ==? '***REMOVED***'
        let l:bash = $LOCALAPPDATA . '\Programs\Git\usr\bin\' . l:bash
    endif
    let l:bash = system(l:bash)[:-2]
  endif

    let l:title = 'Journal ' . l:bash
    let l:failed = append(0, l:title)
    execute 'normal! 1G'
    call vimwiki#base#AddHeaderLevel()

    let l:failed = append(1, 'Contents')
    execute 'normal! 2G'
    call vimwiki#base#AddHeaderLevel()

    execute 'normal! 3G'
endfunction "}}}
nnoremap <silent><buffer> <F3> :call <SID>TitleJournal()<CR>

setlocal spell spelllang=en_us
