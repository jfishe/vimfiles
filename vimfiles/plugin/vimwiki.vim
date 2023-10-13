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
      \ 'html': 'html',
      \ 'DOS': 'dosbatch', 'powershell': 'ps1', 'snippets': 'snippets'}
let s:wiki_1.template_path = s:my_docs . '/vimwiki_html/templates'
let s:wiki_1.template_default = 'default'
let s:wiki_1.template_ext = '.tpl'
let s:wiki_1.css_name = '../css/style.css'
let s:wiki_1.auto_tags = 0
let s:wiki_1.list_margin = 0
let s:wiki_1.auto_toc = 1
" }}}
" Home vimwiki {{{
let s:wiki_2 = copy(s:wiki_1)
let s:wiki_2.index = 'index'
let s:wiki_2.path = s:my_docs .. '/vimwiki_home/'
let s:wiki_2.path_html = s:wiki_2.path .. 'docs'
let s:wiki_2.css_name = 'css/style.css'
let s:wiki_2.template_path = s:wiki_2.path .. '/templates'
" }}}
" Zettelkasten vimwiki {{{
let s:wiki_3 = copy(s:wiki_1)
let s:wiki_3.syntax = 'markdown'
let s:wiki_3.ext = '.md'
let s:wiki_3.index = 'index'
let s:wiki_3.path = s:my_docs .. '/zk/'
let s:wiki_3.path_html = s:wiki_3.path .. 'docs'
let s:wiki_3.css_name = 'css/style.css'
let s:wiki_3.template_path = s:wiki_3.path .. 'templates'
" }}}
" Initialize vimwiki {{{
let s:wiki_1.name = 'work'
let s:wiki_2.name = 'home'
let s:wiki_3.name = 'zk'
let g:vimwiki_list = [ s:wiki_1, s:wiki_2, s:wiki_3 ]
"}}}

" Vimwiki global options {{{
let g:vimwiki_folding='syntax'
let g:vimwiki_tags_header_level = 2
let g:vimwiki_links_header_level = 2
let g:vimwiki_toc_header_level = 2
" [[https://github.com/vimwiki/vimwiki/issues/1093#issuecomment-876211106|anton-fomin]].
" disable table mappings
let g:vimwiki_key_mappings = {
      \ 'all_maps': 1,
      \ 'global': 1,
      \ 'headers': 1,
      \ 'text_objs': 1,
      \ 'table_format': 1,
      \ 'table_mappings': 0,
      \ 'lists': 1,
      \ 'links': 1,
      \ 'html': 1,
      \ 'mouse': 0,
      \ }
" }}}

" Vim-zettel global options {{{
let g:zettel_options = [{}, {},
      \{"front_matter" : [["tags", ""], ["type","note"]], "disable_front_matter": 1,
      \ "template" :  s:wiki_3.template_path .. "/note.tpl"}]

let g:zettel_fzf_command = "rg --column --line-number --ignore-case --no-heading --color=always"
let g:zettel_format = "%Y%m%d-%H%M"
let g:zettel_generated_index_title_level = 2
let g:zettel_backlinks_title_level = 2
let g:zettel_unlinked_notes_title_level = 2
let g:zettel_generated_tags_title_level = 2
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }
" }}}

" Panvimiki global options {{{
let g:panvimwiki_settings = {
      \ 'extra_args': [ '--shift-heading-level-by=1',
      \ '--data-dir=' .. '"' .. s:wiki_1.template_path .. '"',
      \ '--reference-doc', s:wiki_1.template_path .. '/reference.docx',
      \ ],
      \ 'format': 'docx'
      \ }
" }}}

" VimwikiRemaps {{{
" [[https://github.com/vimwiki/vimwiki/issues/1093#issuecomment-876211106|anton-fomin]].
augroup VimwikiRemaps
  autocmd!
  " unmap tab in insert mode
  autocmd Filetype vimwiki silent! iunmap <buffer> <Tab>
  " remap table tab mappings to M-n M-p
  autocmd Filetype vimwiki inoremap <silent><expr><buffer> <M-n> vimwiki#tbl#kbd_tab()
  autocmd Filetype vimwiki inoremap <silent><expr><buffer> <M-p> vimwiki#tbl#kbd_shift_tab()
  " on enter if completion is open, complete first element otherwise use
  " default vimwiki mapping
  autocmd Filetype vimwiki inoremap <silent><expr><buffer> <cr> pumvisible() ? coc#_select_confirm()
        \: "<C-]><Esc>:VimwikiReturn 1 5<CR>"
augroup end "}}}

augroup VimwikiTitleJournal "{{{
  autocmd!
  " Create today's Journal and compare to previous day.
  autocmd BufNewFile */diary/[0-9]\\\{-4\}*.wiki call vimwiki#TitleJournal()
  " Use Vimwiki foldmethod when &diff.
  if v:version < 900 && !has('nvim')
    autocmd BufEnter,BufNew,BufLeave,BufWinEnter,BufWinLeave *.wiki if &diff |
          \ set foldmethod=syntax |
          \ foldopen! |
          \ endif
  endif
augroup end "}}}

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
