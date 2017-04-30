#!/bin/bash
for a in \
"https://github.com/tpope/vim-pathogen.git" \
"https://github.com/mattn/calendar-vim.git" \
"https://github.com/davidhalter/jedi-vim.git" \
"https://github.com/tpope/vim-fugitive.git" \
"https://github.com/vim-latex/vim-latex.git" \
"https://github.com/vim-pandoc/vim-pandoc.git" \
"https://github.com/vim-pandoc/vim-pandoc-syntax.git" \
"https://github.com/altercation/vim-colors-solarized.git" \
"https://github.com/tpope/vim-surround.git" \
"https://github.com/vimwiki/vimwiki.git" \
"https://github.com/w0rp/ale.git" \
"https://github.com/tpope/vim-sensible.git" \
"https://github.com/jfishe/vim-conda.git"
do
    git submodule add ${a}
done
