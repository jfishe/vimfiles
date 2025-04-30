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
" let g:vimwiki_ext2syntax = {}

" Work vimwiki {{{
let s:wiki_1 = {}
let s:wiki_1.path = expand(s:my_docs .. '/vimwiki/')
let s:wiki_1.path_html = expand(s:my_docs .. '/vimwiki_html/html')
let s:wiki_1.index = 'main'
let s:wiki_1.diary_sort = 'asc'
" let s:wiki_1.syntax = 'markdown'
" let s:wiki_1.ext = '.md'
let s:wiki_1.automatic_nested_syntaxes = 1
let s:wiki_1.nested_syntaxes = {'python': 'python', 'bash': 'sh',
      \ 'vb': 'vb',
      \ 'html': 'html',
      \ 'DOS': 'dosbatch', 'ini': 'dosini',
      \ 'powershell': 'ps1', 'snippets': 'snippets'}
let s:wiki_1.template_path = expand(s:my_docs .. '/vimwiki_html/templates')
let s:wiki_1.template_default = 'default'
let s:wiki_1.template_ext = '.tpl'
let s:wiki_1.css_name = expand('../css/style.css')
let s:wiki_1.auto_tags = 0
let s:wiki_1.list_margin = 0
let s:wiki_1.auto_toc = 1
" }}}
" Home vimwiki {{{
let s:wiki_2 = copy(s:wiki_1)
let s:wiki_2.index = 'index'
let s:wiki_2.path = expand(s:my_docs .. '/vimwiki_home')
let s:wiki_2.path_html = expand(s:wiki_2.path .. '/docs')
let s:wiki_2.css_name = expand('css/style.css')
let s:wiki_2.template_path = expand(s:wiki_2.path .. '/templates')
" }}}
" Zettelkasten vimwiki {{{
let s:wiki_3 = copy(s:wiki_1)
let s:wiki_3.syntax = 'markdown'
let s:wiki_3.ext = '.md'
let s:wiki_3.index = 'index'
let s:wiki_3.path = expand(s:my_docs .. '/zk')
let s:wiki_3.path_html = expand(s:wiki_3.path .. '/docs')
let s:wiki_3.css_name = expand('css/style.css')
let s:wiki_3.template_path = expand(s:wiki_3.path .. '/templates')
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
let g:vimwiki_valid_html_tags='iframe'
" [[https://github.com/vimwiki/vimwiki/issues/1093#issuecomment-876211106|anton-fomin]].
" Disable table mappings
" Disable VimwikiReturn mapping to prevent coc.nvim applying to all filetypes.
" Use coc mapping to prevent remapping by coc#ui#check_pum_keymappings().
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
      \ 'lists_return': 0,
      \ 'mouse': 0,
      \ }
" }}}

" Vim-zettel global options {{{
let g:zettel_options = [{}, {},
      \ {"front_matter" : [["tags", ""], ["type","note"]], "disable_front_matter": 1,
      \ "template" :  s:wiki_3.template_path .. "/note.tpl"}]

let g:zettel_fzf_command = "rg --column --line-number --ignore-case --no-heading --color=always"
let g:zettel_format = "%Y%m%d-%H%M"
let g:zettel_generated_index_title_level = 2
let g:zettel_backlinks_title_level = 2
let g:zettel_unlinked_notes_title_level = 2
let g:zettel_generated_tags_title_level = 2
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

augroup VimwikiCocEnable "{{{
  " Assuming g:coc_filetype_map enables CoC for Vimwiki markdown syntax,
  " disable for Vimwiki default syntax.
  autocmd!
  autocmd BufAdd,BufEnter,BufNew,BufLeave,BufWinEnter,BufWinLeave  *.wiki
        \ let b:coc_enabled=0
augroup end "}}}

augroup VimwikiTitleJournal "{{{
  autocmd!
  " Create today's Journal and compare to previous day.
  autocmd BufNewFile */diary/[0-9]\\\{-4\}*.wiki call vimwiki#TitleJournal()
  " Use Vimwiki foldmethod when &diff.
  if !has('nvim')
    autocmd BufEnter,BufNew,BufLeave,BufWinEnter,BufWinLeave *.wiki if &diff |
          \ let &foldmethod = 'syntax' |
          \ foldopen! |
          \ endif
  endif
augroup end "}}}

" Disable Taskwiki when Diff and Fugitive buffers exist. {{{
function! s:disable_taskwiki() abort
  " Remember taskwiki_disable value
  let l:disable_status = [
        \ get(g:, 'taskwiki_disable', ''),
        \ get(g:, 'undo_taskwiki_disable', '')
        \ ]
  if empty(list2str(l:disable_status))
    let g:undo_taskwiki_disable = 'empty'
  elseif ! empty(l:disable_status[0])
    let g:undo_taskwiki_disable = g:taskwiki_disable
  endif

  for l:bufnr in range(1, bufnr('$'))
    if !empty(getbufvar(l:bufnr, 'fugitive_type'))
      let g:taskwiki_disable = 1
      return
    endif
  endfor
  call s:restore_disable_taskwiki()
endfunction

function! s:restore_disable_taskwiki() abort
  let l:disable_status = [
        \ get(g:, 'taskwiki_disable', ''),
        \ get(g:, 'undo_taskwiki_disable', '')
        \ ]
  if empty(list2str(l:disable_status))
    return
  elseif l:disable_status[1] == 'empty'
    unlet g:taskwiki_disable
    unlet g:undo_taskwiki_disable
  elseif ! empty(l:disable_status[1])
    let g:taskwiki_disable = g:undo_taskwiki_disable
    unlet g:undo_taskwiki_disable
  endif
endfunction

augroup myTaskwiki
  autocmd!
  " Taskwiki causes vim-Fugitive to write the Git index path to disk:
  "   fugitive://*/.git/*//
  " So disable when fugitive buffer exists.
  autocmd BufEnter,BufWinEnter,BufNew * call s:disable_taskwiki()
augroup END " }}}

function! VimwikiLinkHandler(link) abort " {{{
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
endfunction " }}}
" vim:tabstop=2:shiftwidth=2:expandtab:foldmethod=marker:textwidth=79
