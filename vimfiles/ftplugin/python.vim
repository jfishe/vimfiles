if exists('b:did_ftplugin_user') || !executable('task')
  finish
endif
let b:did_ftplugin_user = 1  " Don't load another plugin for this buffer

set foldmethod=indent
