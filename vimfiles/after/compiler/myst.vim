" Vim compiler file
" Compiler:	MyST (MyST Markdown)
" Maintainer:   jdfenw@gmail.com
" Last Change:	2025 May 01

" if exists("current_compiler") | finish | endif
let current_compiler = "myst"

let s:cpo_save = &cpo
set cpo&vim

" CompilerSet makeprg=myst
" let &l:makeprg = 'mypy --show-column-numbers '
" 	    \ ..get(b:, 'mypy_makeprg_params', get(g:, 'mypy_makeprg_params', '--strict --ignore-missing-imports'))
let &l:makeprg = 'myst build --site'
exe 'CompilerSet makeprg='..escape(&l:makeprg, ' \|"')

" ⛔ 0x26d4 0xfe0f
CompilerSet errorformat=⛔️\ %f\ %m

" ⚠️  20230929-1034.md:27 Linking "index-structure-or-hub-notes" to an implicit heading reference, best practice is to create an explicit reference.
"    Explicit references do not break when you update the title to a section, they are preferred over using the implicit HTML ID created for headers.
CompilerSet errorformat+=⚠️\ %f:%l\ %m

" ⚠️  20240320-0807.md Duplicate identifier in project "ref-nede-33885p-ar1"
"    In files: 20240320-0807.md, 20240321-0854.md
" ⚠  0x26a0 0xfe0f is a composite character; it doesn't display in Vim.
CompilerSet errorformat+=⚠️\ %f\ %m

let &cpo = s:cpo_save
unlet s:cpo_save
