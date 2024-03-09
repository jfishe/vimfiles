" Vimwiki User Autoload {{{
if exists('g:loaded_vimwiki_user_after_auto') || &compatible
  finish
endif
let g:loaded_vimwiki_user_after_auto = 1

" Helper: for omnicompletion {{{
" omnifunc=pandoc#completion#Complete
" taskwiki#CompleteOmni
" Complete_wikifiles()
function vimwiki#Complete_pandoc(findstart, base) abort
  " Find line context
  " Called: first time
  if a:findstart == 1
    let line = getline('.')[:col('.')-2]

    " Check Citekey:
    " @citekey
    let citekey = pandoc#completion#Complete(a:findstart, a:base)
    if citekey >= 0
      let s:omni_method = 'citekey'
      return citekey
    endif

    " Fallback to vimwiki's omnifunc
    if type(b:pandoc_omnifunc_fallback) is v:t_func
      let s:omni_method = 'fallback'
      return b:pandoc_omnifunc_fallback(a:findstart, a:base)
    else
      let s:omni_method = ''
      return -1
    endif
  else
    if s:omni_method is 'citekey'
      return pandoc#completion#Complete(a:findstart, a:base)
    elseif s:omni_method is 'fallback'
      return b:pandoc_omnifunc_fallback(a:findstart, a:base)
    else
      return []
    endif
  endif
endfunction  " }}}

" Insert Expanded BibLaTeX References: {{{
function vimwiki#insert_references(infile) abort
  return
endfunction  " }}}
" Commands: VimwikiSearch and VWS {{{
" Use Rg and QuickFixWindow instead of lvimgrep in VWS and VWT.
function! vimwiki#searchRg(search_pattern) abort
  if !exists(':Rg')
    call vimwiki#base#search(a:search_pattern)
    return
  endif

  if empty(a:search_pattern)
    let pattern = expand("<cword>")
  else
    let pattern = a:search_pattern
  endif

  " If the pattern does not start with a '/', then we'll assume that a
  " literal search is intended and enclose and escape it:
  if match(pattern, '^/') == -1
    let pattern = shellescape(escape(pattern, '\'))
  else
    let pattern = pattern[1:-2]
    let pattern = shellescape(pattern)
  endif

  let path = shellescape(vimwiki#vars#get_wikilocal('path'))
  let ext  = vimwiki#vars#get_wikilocal('ext')

  let cmd = g:zettel_fzf_command..' --glob '..shellescape('**/*'..ext)
  let cmd ..= ' -- '..pattern..' '..path
  let opts ={
    \   'options': [
    \     '--bind',
    \     'ctrl-a:select-all',
    \     'ctrl-d:deselect-all',
    \     'ctrl-w:toggle-preview'
    \   ]
    \ }
  " command (string), [spec (dict)], [fullscreen (bool)]
  call fzf#vim#grep(cmd, fzf#vim#with_preview(opts), 1)

endfunction

function vimwiki#generate_index() abort
  ZettelGenerateLinks
  ZettelBackLinks
  ZettelInbox
endfunction
" }}}

" Convert Email: selected text to VimWikiLink {{{
" Todo: Limit the length of the URI to 2083 per
"       https://stackoverflow.com/questions/417142/what-is-the-maximum-length-of-a-url-in-different-browsers
"       by splitting into multiple links.
function! vimwiki#myvimwiki_normalize_mail_v()
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
    let l:rxDesc = substitute(l:rxUrl, "'", '', 'g')
    " Escape single quoted e-mail address in URI, so that URI parses correctly
    " when opened. Double-quotes get stripped when URI is parsed anyway.
    let l:rxUrl = 'mailto:' . substitute(l:rxUrl, "'", "''", 'g')

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
          \ l:rxUrl, l:rxDesc, l:rxStyle,
          \ vimwiki#vars#get_wikilocal('ext')
          \ )

    " Put substitution in register " and change text
    call setreg('"', l:sub, 'v')
    normal! `>""pgvd
  finally
    call setreg('"', l:rv, l:rt)
    let &selection = l:sel_save
  endtry
endfunction " }}}
" }}}

" Create today's Journal and compare to previous day. {{{
" Create a title header for Journal with date.
" Copy previous diary day Todo header through EOF.
" Diff today and previous day.
function! vimwiki#TitleJournal() abort "{{{
  if search('^= Journal.* =$', 'w', 0, 500)
    return
  endif

  " help taskwiki_disable
  let l:undo_taskwiki_disable = get(g:, 'taskwiki_disable', '')
  if empty('l:taskwiki_disable')
    let g:taskwiki_disable = 'disable'
  endif
  set filetype=vimwiki

  let l:title = 'Journal ' . expand('%:t:r')
  let l:failed = append(0, l:title)
  execute 'normal! gg'
  call vimwiki#base#AddHeaderLevel(1)

  execute 'normal! 2G'

  " Creates a diary entry for today if calendar.vim started from future date.
  call vimwiki#diary#goto_prev_day()

  " Taskwiki heading for Todo
  " let l:todoheader ='Todo | -COMPLETED -WAITING'
  " let l:todoheader = '^== '..l:todoheader..' ==$\|^## '..l:todoheader..'$'
  let l:todoheader = '^== Todo\|^## Todo'
  let l:todoheader = search(l:todoheader,'w', 0, 500 )
  if l:todoheader
    silent ,$yank m
    call vimwiki#base#go_back_link()
    silent put m
  else
    call vimwiki#base#go_back_link()
  endif

  only
  vsplit
  call vimwiki#diary#goto_prev_day()
  diffthis
  wincmd p
  diffthis
  execute 'normal! gg'
  wincmd p

  if empty('l:taskwiki_disable')
    unlet g:taskwiki_disable
  endif

endfunction "}}}
" }}}
" }}}

" vim:tabstop=2:shiftwidth=2:expandtab:foldmethod=marker:textwidth=79
