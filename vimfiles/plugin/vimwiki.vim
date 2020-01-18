" Vimwiki plugin file

" Locate Documents folder or user home directory {{{
" Finds My Documents or Documents folder even if it's not located in
" $HOMEDRIVE$HOMEPATH or $HOME.
" Defaults to $HOME for non-windows.
" Tested on Windows10 and Windows7
" if has('win32') || has('win64') || has('win32unix')
if has('win32') || has('win64')
    function! s:GetMyDocuments() "{{{
        let l:KEY_NAME = '"HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders"'
        let l:VALUE_NAME = 'Personal'
        let l:cmd = 'REG QUERY ' . l:KEY_NAME . ' /v ' . l:VALUE_NAME
        let l:cmd = systemlist(l:cmd)
        let l:cmd = systemlist('echo ' . split(l:cmd[2], '    ')[2][:-2])
        let l:my_docs = l:cmd[0][:-3]
        return l:my_docs
    endfunction "}}}
    " silent let s:my_docs = <SID>GetMyDocuments()
    let s:my_docs = $USERPROFILE . '/Documents'
else
    let s:my_docs = $HOME
endif "}}}

" Define g:vimwiki_list {{{
" let g:vimwiki_ext2syntax = {
"   \ '.md': 'markdown',
" 	\ '.mkd': 'markdown',
"   \ '.wiki': 'media'}

" Work vimwiki {{{
let s:wiki_1 = {}
" let s:my_docs = 'U:/My Documents'
let s:wiki_1.path = s:my_docs . '/vimwiki/'
let s:wiki_1.path_html = s:my_docs . '/vimwiki_html/html'
let s:wiki_1.index = 'main'
let s:wiki_1.diary_sort = 'asc'
" let s:wiki_1.syntax = 'markdown'
" let s:wiki_1.ext = '.md'
let s:wiki_1.automatic_nested_syntaxes = 1
let s:wiki_1.nested_syntaxes = {'python': 'python', 'bash': 'sh', 'DOS': 'dosbatch', 'powershell': 'ps1'}
let s:wiki_1.template_path = s:my_docs . '/vimwiki_html/templates/'
let s:wiki_1.template_default = 'default'
let s:wiki_1.template_ext = '.tpl'
let s:wiki_1.css_name = '../css/style.css'
let s:wiki_1.auto_tags = 1
let s:wiki_1.list_margin = 0
let s:wiki_1.auto_toc = 1
" }}}
" Home vimwiki {{{
let s:wiki_2 = s:wiki_1
let s:wiki_2.path = s:my_docs . '/vimwiki_home/'
let s:wiki_2.path_html = s:my_docs . '/vimwiki_home_html/html'
let s:wiki_2.template_path = s:my_docs . '/vimwiki_home_html/templates/'
" }}}
let g:vimwiki_list = [ s:wiki_1, s:wiki_2 ]
"}}}

" Folding {{{
let g:vimwiki_folding='syntax'"}}}

" augroup wiki_setup
"     autocmd!
"      " Enable pandoc for all wiki files
"      " autocmd BufNewFile,BufFilePre,BufRead *.wiki set filetype=wiki.pandoc.tex
"      autocmd BufNewFile,BufFilePre,BufRead *.wiki set filetype=vimwiki.pandoc
"      autocmd BufNewFile,BufFilePre,BufRead *.md set filetype=vimwiki.pandoc
"      " Latex-Suite enables automatically on file type setting.
"      " Now enable vimtex plugin to get vimtex keybindings and such
"      " autocmd BufNewFile,BufFilePre,BufRead *.wiki call vimtex#init()
" augroup END


function! VimwikiLinkHandler(link) "{{{
  " Use Vim to open external files with the 'vfile:' scheme.  E.g.:
  "   1) [[vfile:~/Code/PythonProject/abc123.py]]
  "   2) [[vfile:./|Wiki Home]]
  let link = a:link
  if link =~# '^vfile:'
    let link = link[1:]
  else
    return 0
  endif
  let link_infos = vimwiki#base#resolve_link(link)
  if link_infos.filename ==# ''
    echomsg 'Vimwiki Error: Unable to resolve link!'
    return 0
  else
    exe 'edit ' . fnameescape(link_infos.filename)
    return 1
  endif
endfunction "}}}

" vim:tabstop=2:shiftwidth=2:expandtab:foldmethod=marker:textwidth=79
