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

" ⛔ 0x26d4 0xfe0f is a composite character.
" ⛔️ 20240815-0706.md:61 Link for "wn.work:diary/2024-08-15" did not resolve.
CompilerSet errorformat=%E⛔️\ %f:%l\ %m
" ⛔️ 20240730-1540.md 'tags.0' must be string (at 20240730-1540.md#frontmatter)
CompilerSet errorformat+=%E⛔️\ %f\ %m

" ⚠  0x26a0 0xfe0f is a composite character; it doesn't display in Vim.
" ⚠️  20250519-1011.md:75:37 Could not link citation with label "FSAR-01".
CompilerSet errorformat+=%W⚠️\ %f:%l:%c\ %m
" ⚠️  20230929-1034.md:27 Linking "index-structure-or-hub-notes" to an implicit heading reference, best practice is to create an explicit reference.
"    Explicit references do not break when you update the title to a section, they are preferred over using the implicit HTML ID created for headers.
CompilerSet errorformat+=%W⚠️\ %f:%l\ %m

" ⚠️  20240320-0807.md Duplicate identifier in project "ref-nede-33885p-ar1"
"    In files: 20240320-0807.md, 20240321-0854.md
CompilerSet errorformat+=%W⚠️\ %f\ %m

CompilerSet errorformat+=%Z\ \ \ %m

" 🌎 Building MyST site
" 🌎 0x0001f30e
" ⏳ Waiting for response from wn.work:diary/2024-04-25
" ⏳ 0x23f3
" 📖 Built 20250417-1424.md in 263 ms.
" 📖 Ox0001f4d6
" 🔗 Checked 2 links in 20250417-1424.md in 2.85 min
" 🔗 0x0001f517
" 📚 Built 69 pages for project in 2.61 s.
" 📚 0x0001f4da
CompilerSet errorformat+=%-G📖\ %m
CompilerSet errorformat+=%-G🔗\ %m
CompilerSet errorformat+=%-G🌎\ %m
CompilerSet errorformat+=%-G📚\ %m
CompilerSet errorformat+=%-G⏳\ %m

let &cpo = s:cpo_save
unlet s:cpo_save
