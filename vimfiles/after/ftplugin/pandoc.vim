" Lint with ALE's markdown rumdl linter using rumdl's pandoc flavor.
let b:ale_linter_aliases = ['markdown']
let b:ale_linters = ['rumdl']
let b:ale_fixers = ['rumdl']
let s:rumdl_flavor = "--config 'flavor = \"pandoc\"'"
let b:ale_markdown_rumdl_options = s:rumdl_flavor
let b:ale_markdown_rumdl_fmt_options = '--silent ' .. s:rumdl_flavor

let b:undo_ftplugin = get(b:, 'undo_ftplugin', '')
if !empty(b:undo_ftplugin)
  let b:undo_ftplugin ..= ' | '
endif
let b:undo_ftplugin ..= 'unlet! b:ale_linter_aliases b:ale_linters b:ale_fixers'
      \ .. ' b:ale_markdown_rumdl_options b:ale_markdown_rumdl_fmt_options'

if pandoc#zk_makefile_settings()
  let b:undo_ftplugin ..= ' | setlocal makeprg< errorformat<'
endif
