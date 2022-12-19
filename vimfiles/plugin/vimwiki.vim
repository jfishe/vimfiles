" Vimwiki user plugin file
if exists('g:loaded_vimwiki_user') || &compatible
  finish
endif
let g:loaded_vimwiki_user = 1

" Locate Documents folder or user home directory {{{
if has('win32') || has('win64')
  let s:my_docs = $USERPROFILE . '/Documents'
else
  let s:my_docs = $HOME
endif "}}}

" Define g:vimwiki_list {{{
" let g:vimwiki_ext2syntax = {
"   \ '.md': 'markdown',
" 	\ '.mkd': 'markdown',
"   \ '.wiki': 'media'}
" Disable default function
" let g:vimwiki_ext2syntax =
" \ {'.md': 'markdown', '.mkdn': 'markdown',
" \  '.mdwn': 'markdown', '.mdown': 'markdown',
" \  '.markdown': 'markdown', '.mw': 'media'}},
let g:vimwiki_ext2syntax = {}

" Work vimwiki {{{
let s:wiki_1 = {}
let s:wiki_1.path = s:my_docs . '/vimwiki/'
let s:wiki_1.path_html = s:my_docs . '/vimwiki_html/html'
let s:wiki_1.index = 'main'
let s:wiki_1.diary_sort = 'asc'
" let s:wiki_1.syntax = 'markdown'
" let s:wiki_1.ext = '.md'
let s:wiki_1.automatic_nested_syntaxes = 1
let s:wiki_1.nested_syntaxes = {'python': 'python', 'bash': 'sh',
      \ 'vb': 'vb',
      \ 'DOS': 'dosbatch', 'powershell': 'ps1', 'snippets': 'snippets'}
let s:wiki_1.template_path = s:my_docs . '/vimwiki_html/templates'
let s:wiki_1.template_default = 'default'
let s:wiki_1.template_ext = '.tpl'
let s:wiki_1.css_name = '../css/style.css'
let s:wiki_1.auto_tags = 1
let s:wiki_1.list_margin = 0
let s:wiki_1.auto_toc = 1
" }}}
" Home vimwiki {{{
let s:wiki_2 = copy(s:wiki_1)
let s:wiki_2.path = s:my_docs . '/vimwiki_home/'
let s:wiki_2.path_html = s:my_docs . '/vimwiki_home_html/html'
let s:wiki_2.template_path = s:my_docs . '/vimwiki_home_html/templates'
" }}}
" Work & Home vimwiki {{{
let s:wiki_1.name = 'work'
let s:wiki_2.name = 'home'
let g:vimwiki_list = [ s:wiki_1, s:wiki_2 ]
"}}}

let g:vimwiki_folding='syntax'
let g:vimwiki_tags_header_level = 2
let g:vimwiki_links_header_level = 2

let g:panvimwiki_settings = {
      \ 'extra_args': [ '--shift-heading-level-by=1',
      \ '--data-dir=' .. '"' .. s:wiki_1.template_path .. '"',
      \ '--reference-doc', s:wiki_1.template_path .. '/reference.docx',
      \ ],
      \ 'format': 'docx'
      \ }

augroup VimwikiTitleJournal "{{{
  autocmd!
  " Create today's Journal and compare to previous day.
  autocmd BufNewFile */diary/[0-9]\\\{-4\}*.wiki call vimwiki#TitleJournal()
  " Use Vimwiki foldmethod when &diff.
  autocmd BufEnter,BufNew *.wiki if &diff | set foldmethod=syntax |
        \ execute 'normal! zR' | endif
augroup END "}}}

function! VimwikiLinkHandler(link) abort
  let link = a:link
  let islink = 0
  if link =~ '^local:.*'
    let islink = 1
    let local_dir = matchstr(link, '^local:\zs.*')
    let abs_dir = expand('%:p:h').'/'.local_dir
  elseif link =~ '^file:.*'
    let islink = 1
    let abs_dir = matchstr(link, '^file:\zs.*')
  endif
  if islink == 1
    if has('win64') || has('win32')
      execute "!start " . substitute(abs_dir,"/","\\\\",'g')
    elseif executable('wslview')
      execute system('wslview '..shellescape(link))
    else
      return 0
    endif
    return 1
  else
    return 0
  endif
endfunction

" vim:tabstop=2:shiftwidth=2:expandtab:foldmethod=marker:textwidth=79
