" Vim compiler file for zizmor
" Maintainer: jdfenw@gmail.com
" Description: Run zizmor audits via uvx and parse findings into quickfix
" https://docs.zizmor.sh/

if exists("current_compiler")
  finish
endif
let current_compiler = "zizmor"

let s:cpo_save = &cpo
" C, Do not concatenate sourced lines that start with a backslash.
set cpo-=C

" Run zizmor via uvx
CompilerSet makeprg=uvx\ zizmor\ --persona=auditor\ %:p:h:S

" Zizmor findings look like (annotate-snippets style, one per finding):
"
"   warning[dependabot-cooldown]: insufficient cooldown in Dependabot updates
"    --> .github/dependabot.yml:3:5
"     |
"   3 |   - package-ecosystem: "github-actions"
"     |     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ missing cooldown configuration
"     |
"     = note: audit confidence → High
"     = help: audit documentation → https://docs.zizmor.sh/audits/#dependabot-cooldown
"
" Severity keywords map to zizmor's finding levels:
"   error[CODE]:   High
"   warning[CODE]: Medium
"   help[CODE]:    Low
"   info[CODE]:    Informational
"
" The '= note: ...' / '= tip: ...' / '= help: ...' lines are appended to
" the finding's message so they're visible directly in :copen and on the
" command line when jumping to an entry. The source-snippet/caret lines
" in between are absorbed by a bare '%C%.%#' rather than '%-G': a %-G
" match closes the multi-line message, which would stop those trailing
" '= ...' lines from appending to it.

CompilerSet errorformat=
      \%Eerror[%.%#]:\ %m,
      \%Wwarning[%.%#]:\ %m,
      \%Nhelp[%.%#]:\ %m,
      \%Iinfo[%.%#]:\ %m,
      \%C%\\s%#-->\ %f:%l:%c,
      \%C%\\s%#=\ %m,
      \%C%.%#,
      \%-G%.%#

let &cpo = s:cpo_save
unlet s:cpo_save
