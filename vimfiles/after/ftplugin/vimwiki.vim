" VimWiki ftplugin {{{
if exists('b:did_ftplugin_user_after')
  finish
endif
let b:did_ftplugin_user_after = 1  " Don't load another plugin for this buffer

let s:save_cpo = &cpo
set cpo&vim

if vimwiki#vars#get_wikilocal('syntax') ==# 'markdown'
  UltiSnipsAddFiletypes markdown.vimwiki
endif

" VimwikiRemaps {{{
" [[https://github.com/vimwiki/vimwiki/issues/1093#issuecomment-876211106|anton-fomin]].
" Unmap tab in insert mode.
silent! iunmap <buffer> <Tab>
" Remap table tab mappings to M-n M-p.
inoremap <silent><expr><buffer> <M-n> vimwiki#tbl#kbd_tab()
inoremap <silent><expr><buffer> <M-p> vimwiki#tbl#kbd_shift_tab()
" On enter if completion is open, complete first element otherwise use
" default vimwiki mapping.
" Use coc#pum#visible() to prevent remapping by coc#ui#check_pum_keymappings().
" inoremap <silent><expr><buffer> <cr> pumvisible() ? coc#_select_confirm()
"       \: "<C-]><Esc>:VimwikiReturn 1 5<CR>"
inoremap <silent><expr><buffer> <CR> coc#pum#visible() ? '<CR>'
      \: '<C-]><Esc>:VimwikiReturn 3 5<CR>'
inoremap <silent><expr><buffer> <S-CR> coc#pum#visible() ? '<CR>'
      \: '<Esc>:VimwikiReturn 2 2<CR>'
"}}}

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
"}}}

setlocal spell spelllang=en_us

" let b:pandoc_omnifunc_fallback = len(&omnifunc) ? function(&omnifunc) : ''
" setlocal omnifunc=vimwiki#Complete_pandoc
function s:get_bibfiles() abort
  if empty(b:pandoc_biblio_bibs)
    let save_dir = chdir(expand('%:p:h'))
    let bibfiles = pandoc#bibliographies#Find_Bibliographies()
    call chdir(save_dir)
  else
    let bibfiles = b:pandoc_biblio_bibs
  endif
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
