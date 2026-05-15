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

let g:pandoc#formatting#equalprg = 'pandoc'
      \ .. ' --from=commonmark_x'
      \ .. '+wikilinks_title_after_pipe-task_lists'
      \ .. ' --to=commonmark_x'

let g:pandoc#formatting#extra_equalprg='--markdown-headings=atx '
      \ .. '--standalone --reference-links --wrap=preserve'
      \ .. ' --lua-filter=reorder_metadata.lua'

let s:pandoc_compiler = ' --from=commonmark_x'
      \ .. '+wikilinks_title_after_pipe-task_lists'
      \ .. ' --wrap=preserve --standalone'

let g:pandoc#compiler#arguments = '--to=commonmark_x' .. s:pandoc_compiler

" Expand citations.
" let g:pandoc#compiler#arguments = '--to=markdown-citations'
"       \ .. " --citeproc --metadata='link-citations:true' " .. s:pandoc_compiler

let g:pandoc#syntax#conceal#urls = 1
