"Use lgrep so that ag peforms search
augroup myvimwiki
    autocmd!
    autocmd QuickFixCmdPost [^l]* cwindow
    autocmd QuickFixCmdPost l*    lwindow
augroup END
" The Silver Searcher
" See plugin/tex.vim.
" set grepprg=ag\ --nogroup\ --nocolor\ $*
if executable('ag')
    exe 'command! -buffer -nargs=+ VWS silent lgrep! <args> -G '.
        \ escape('"^.*/*'.VimwikiGet('ext').'"', ' '). ' '.
        \ shellescape(VimwikiGet('path'), ' ')
    command! -buffer -nargs=* -complete=custom,vimwiki#tags#complete_tags
        \ VWT VWS /:<args>:/
endif
