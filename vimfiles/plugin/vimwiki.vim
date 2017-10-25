" vim:tabstop=2:shiftwidth=2:expandtab:foldmethod=marker:textwidth=79
" Vimwiki plugin file

au BufRead,BufNewFile *.wiki set filetype=vimwiki

" Locate Documents folder or user home directory {{{
" Finds My Documents or Documents folder even if it's not located in
" $HOMEDRIVE$HOMEPATH or $HOME.
" Defaults to $HOME for non-windows.
" Tested on Windows10 and Windows7
if has("win32") || has("win64") || has('win32unix')
    function! s:GetMyDocuments() "{{{
        let KEY_NAME = '"HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders"'
        let VALUE_NAME = "Personal"
        let cmd = "REG QUERY " . KEY_NAME . " /v " . VALUE_NAME
        "echo cmd
        let cmd = systemlist(cmd)
        "echo cmd
        let cmd = systemlist("echo " . split(cmd[2], "    ")[2][:-2])
        let my_docs = cmd[0][:-3]
        return my_docs
    endfunction "}}}
    silent let my_docs = <SID>GetMyDocuments()
else
    let my_docs = $HOME
endif "}}}

" Define g:vimwiki_list {{{
let g:vimwiki_ext2syntax = {'.md': 'markdown',
	\ '.mkd': 'markdown',
       	\ '.wiki': 'media'}

let wiki_1 = {}
"let my_docs = 'U:/My Documents'
let wiki_1.path = my_docs . '/vimwiki/'
let wiki_1.path_html = my_docs . '/vimwiki_html/'
let wiki_1.index = 'main'
let wiki_1.diary_sort = 'asc'
"let wiki_1.syntax = 'markdown'
"let wiki_1.ext = '.md'
let wiki_1.nested_syntaxes = {'python': 'python'}
let wiki_1.template_path = wiki_1.path_html . 'templates/'
let wiki_1.template_default = 'default'
let wiki_1.template_ext = '.tpl'
let wiki_1.mathjax_folder = '../mathjax'
let wiki_1.auto_tags = 1
let wiki_1.list_margin = 0

let g:vimwiki_list = [wiki_1] "}}}

" Folding {{{
let g:vimwiki_folding='syntax'"}}}
