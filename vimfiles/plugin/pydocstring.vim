let s:vimfiles=fnamemodify(expand('$MYVIMRC'), ':p:h')
let g:pydocstring_templates_dir = s:vimfiles . '/template/pydocstring'
let g:pydocstring_doq_path = expand("$HOME/.local/bin/doq")
