let b:ale_linters = {
\   'sh': [
\       'language_server',
\       'shell'
\   ],
\}
let b:ale_fixers = {
\   'sh': [
\       'shfmt'
\   ],
\}
let b:ale_sh_shfmt_options = '-i 2 -ci'
