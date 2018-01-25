" vim:tabstop=2:shiftwidth=2:expandtab:foldmethod=marker:textwidth=79
" Vimwiki plugin file

au BufRead,BufNewFile *.wiki set filetype=vimwiki

" Locate Documents folder or user home directory {{{
" Finds My Documents or Documents folder even if it's not located in
" $HOMEDRIVE$HOMEPATH or $HOME.
" Defaults to $HOME for non-windows.
" Tested on Windows10 and Windows7
if has('win32') || has('win64') || has('win32unix')
    function! s:GetMyDocuments() "{{{
        let l:KEY_NAME = '"HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders"'
        let l:VALUE_NAME = "Personal"
        let l:cmd = "REG QUERY " . l:KEY_NAME . " /v " . l:VALUE_NAME
        "echo l:cmd
        let l:cmd = systemlist(l:cmd)
        "echo l:cmd
        let l:cmd = systemlist("echo " . split(l:cmd[2], "    ")[2][:-2])
        let l:my_docs = l:cmd[0][:-3]
        return l:my_docs
    endfunction "}}}
    silent let s:my_docs = <SID>GetMyDocuments()
else
    let s:my_docs = $HOME
endif "}}}

" Define g:vimwiki_list {{{
let g:vimwiki_ext2syntax = {'.md': 'markdown',
	\ '.mkd': 'markdown',
       	\ '.wiki': 'media'}

let s:wiki_1 = {}
"let my_docs = 'U:/My Documents'
let s:wiki_1.path = s:my_docs . '/vimwiki/'
let s:wiki_1.path_html = s:my_docs . '/vimwiki_html/'
let s:wiki_1.index = 'main'
let s:wiki_1.diary_sort = 'asc'
"let wiki_1.syntax = 'markdown'
"let wiki_1.ext = '.md'
let s:wiki_1.nested_syntaxes = {'python': 'python'}
let s:wiki_1.template_path = s:wiki_1.path_html . 'templates/'
let s:wiki_1.template_default = 'default'
let s:wiki_1.template_ext = '.tpl'
let s:wiki_1.mathjax_folder = '../mathjax'
let s:wiki_1.auto_tags = 1
let s:wiki_1.list_margin = 0
let s:wiki_1.auto_toc = 1

let g:vimwiki_list = [s:wiki_1] "}}}

" Folding {{{
let g:vimwiki_folding='syntax'"}}}
