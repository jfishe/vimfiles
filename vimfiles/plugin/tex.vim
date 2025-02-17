let g:tex_flavor='latex'
let g:vimtex_view_general_viewer = expand('~/.local/bin/sumatrapdf.sh')
if ! filereadable(g:vimtex_view_general_viewer)
    let g:vimtex_view_general_viewer = 'SumatraPDF-64'
endif
let g:vimtex_view_general_options = '-reuse-instance -forward-search @tex @line @pdf'
