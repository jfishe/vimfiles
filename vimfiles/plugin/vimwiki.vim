" Locate Documents folder or user home directory
if has("win32") || has("win64")
    function! s:GetMyDocuments()
        let KEY_NAME = '"HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders"'
        let VALUE_NAME = "Personal"
        let cmd = "REG QUERY " . KEY_NAME . " /v " . VALUE_NAME 
        echo cmd
        let mydocs = systemlist(cmd)
        let mydocs = split(mydocs[2], "    ")[2][:-2]
        echo mydocs
        return mydocs
    endfunction
    silent let my_docs = <SID>GetMyDocuments()
else
    let my_docs = $HOME
endif

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

let g:vimwiki_list = [wiki_1]
