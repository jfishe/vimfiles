" Only do this when not done yet for this buffer
if exists("b:did_ftplugin_userafter") | finish | endif

" Don't load another plug-in for this buffer
let b:did_ftplugin_userafter = 1

set foldmethod=syntax

let b:ale_enabled=0
" let g:ale_linter_aliases = {'ps1': 'powershell'}
" let g:ale_powershell_powershell_executable = 'powershell.exe'
" let g:ale_powershell_psscriptanalyzer_executable = 'powershell.exe'
