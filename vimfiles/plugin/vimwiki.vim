
let g:vimwiki_ext2syntax = {'.md': 'markdown',
	\ '.mkd': 'markdown',
       	\ '.wiki': 'media'}

let wiki_1 = {}
let my_docs = 'U:/My Documents'
let wiki_1.path = my_docs . '/vimwiki/'
let wiki_1.path__html = my_docs . '/vimwiki_html/'
let wiki_1.index = 'main'
let wiki_1.diary_sort = 'asc'
"let wiki_1.syntax = 'markdown'
"let wiki_1.ext = '.md'
let wiki_1.nested_syntaxes = {'python': 'python'}

let g:vimwiki_list = [wiki_1]
