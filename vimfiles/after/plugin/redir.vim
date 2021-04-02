" https://gist.github.com/romainl/eae0a260ab9c135390c30cd370c20cd7
command! -nargs=1 -complete=command -bar -range Redir
            \ silent call redir#Redir(<q-args>, <range>, <line1>, <line2>)
" vim:tabstop=2:shiftwidth=2:expandtab:foldmethod=marker:textwidth=79
