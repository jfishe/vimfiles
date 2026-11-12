let b:commentary_format = '<!-- %s -->'

let b:ale_linters = {'markdown': ['rumdl']}
let b:ale_fixers = {'markdown': ['rumdl']}

if pandoc#zk_makefile_settings()
  let b:undo_ftplugin = get(b:, 'undo_ftplugin', '')
  if !empty(b:undo_ftplugin)
    let b:undo_ftplugin ..= ' | '
  endif
  let b:undo_ftplugin ..= 'setlocal makeprg< errorformat<'
endif
