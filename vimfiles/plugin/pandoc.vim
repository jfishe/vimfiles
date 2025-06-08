" Disable pandoc mapping for j & k.
let g:pandoc#keyboard#display_motions = 0
" The default mappings can be disabled as a whole setting
let g:pandoc#keyboard#use_default_mappings = 0

let g:pandoc#folding#fold_yaml=1
let g:pandoc#folding#fold_fenced_codeblocks=1
let g:pandoc#syntax#codeblocks#embeds#langs = [
      \ 'lua',
      \ 'ruby',
      \ 'literatehaskell=lhaskell',
      \ 'bash=sh',
      \ 'powershell=ps1',
      \ 'DOS=dosbatch'
      \ ]

" let g:pandoc#formatting#extra_equalprg='--atx-headers --standalone --reference-links'
let g:pandoc#formatting#extra_equalprg='--markdown-headings=atx --standalone --reference-links'
let g:pandoc#compiler#arguments = "--to=markdown "
      \ .. "--from=markdown-header_attributes"
      \ ..    "+wikilinks_title_after_pipe-task_lists-citations "
      \ .. "--wrap=preserve --standalone"

let g:pandoc#syntax#conceal#urls = 1
