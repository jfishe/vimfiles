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

" let b:pandoc_omnifunc_fallback = len(&omnifunc) ? function(&omnifunc) : ''
" setlocal omnifunc=vimwiki#Complete_pandoc
function s:get_bibfiles() abort
  let save_dir = chdir(expand('%:p:h'))
  let bibfiles = pandoc#bibliographies#Find_Bibliographies()
  call chdir(save_dir)
  let bibfiles = join(bibfiles, ' ')
  return shellescape(bibfiles)
endfunction

function! s:bibtex_ls() abort
  if exists('b:pandoc_biblio_bibs')
    let source_cmd = 'bibtex-ls '..<sid>get_bibfiles()
    return source_cmd
  " let bibfiles = (
  "     \ globpath('.', '*.bib', v:true, v:true) +
  "     \ globpath('..', '*.bib', v:true, v:true) +
  "     \ globpath('*/', '*.bib', v:true, v:true)
  "     \ )
  endif
endfunction

function! s:bibtex_markdown_sink(lines) abort
  let r=system("bibtex-markdown "..<sid>get_bibfiles(), a:lines)
  execute ':normal! a' . r
endfunction

function! s:bibtex_cite_sink_insert(lines) abort
  let r=system("bibtex-cite ", a:lines)
  execute ':normal! a' . r
  call feedkeys('a', 'n')
endfunction

inoremap <silent><buffer> @@ <c-g>u<c-o>:call fzf#run({
      \ 'source': <sid>bibtex_ls(),
      \ 'sink*': function('<sid>bibtex_cite_sink_insert'),
      \ 'up': '40%',
      \ 'options': '--ansi --layout=reverse-list --multi --prompt "Cite> "'})<CR>

nnoremap <silent><buffer> <leader>m :call fzf#run({
      \ 'source': <sid>bibtex_ls(),
      \ 'sink*': function('<sid>bibtex_markdown_sink'),
      \ 'up': '40%',
      \ 'options': '--ansi --layout=reverse-list --multi --prompt "Markdown> "'})<CR>

let b:undo_ftplugin = get(b:, 'undo_ftplugin', '')
if !empty('b:undo_ftplugin')
  let b:undo_ftplugin ..= " | "
endif
let b:undo_ftplugin ..= "delcommand VWS"
      \ .. " | delcommand VWT"
      \ .. " | unlet b:did_ftplugin_user_after b:ale_enabled"
      \ .. ' | mapclear <buffer>'
      \ .. " | setlocal spell< spelllang<"
      \ .. " | autocmd! myvimwiki"

let &cpo = s:save_cpo
unlet s:save_cpo
" vim:tabstop=2:shiftwidth=2:expandtab:foldmethod=marker:textwidth=79
" }}}
