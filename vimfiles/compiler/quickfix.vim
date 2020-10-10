" Vim compiler file
" Compiler:         Quickfix-list errorformat
" Maintainer:
" Latest Revision:  2008-09-10
" http://vim.1045645.n5.nabble.com/Saving-the-Quickfix-List-td1179523.html

if exists("current_compiler")
  finish
endif
let current_compiler = "quickfix"

if exists(":CompilerSet") != 2		" older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

let s:cpo_save = &cpo
set cpo-=C

CompilerSet errorformat=
      \%-G%f:%l:\ All\ of\ '%#%.depend'%.%#,
      \%f%.%l\ col\ %c%.\ %m


let &cpo = s:cpo_save
unlet s:cpo_save
