" Lint with Ruff
let b:ale_linters = {'python': ['ruff']}

" Fix with Ruff (apply auto-fixes) and format with Ruff's formatter
let b:ale_fixers = {'python': ['ruff', 'ruff_format']}
