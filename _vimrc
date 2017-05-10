"set pythonthreedll='c:\users\fishe\anaconda3\envs\test'
source $VIMRUNTIME/vimrc_example.vim
source $VIMRUNTIME/mswin.vim
behave mswin

set fileformat=unix		"LF EOL only
set visualbell			"No sounds

au BufRead,BufNewFile *.wiki set filetype=vimwiki

"Turn off keep backup files unless write fails
set writebackup
set nobackup

" ================ Persistent Undo ==================
" Keep undo history across sessions, by storing in file.
" Only works all the time.
if has('persistent_undo') && !isdirectory(expand('~').'/vimfiles/backups')
  silent exe "!mkdir " . $HOME . '\vimfiles\backups > NUL 2>&1'
endif

if has('persistent_undo')
  set undodir=~/vimfiles/backups
  set undofile
endif

"Load bundles
runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()
execute pathogen#helptags()

" ================ Indentation ======================
" Commented lines relocated to sensible.vim

"set autoindent
set autochdir  " change directory to the file in the current
set smartindent
"set smarttab
set shiftwidth=4
set softtabstop=4
set tabstop=4
set expandtab
"set backspace=indent,eol,start " Proper backspace behavior.

" ================ Buffers ======================
" Commented lines relocated to sensible.vim

set hidden                     " Possibility to have more than one
                               " unsaved buffers.
"set ruler                      " Shows the current line number at the bottom.
                               " right of the screen.

" Display tabs and trailing spaces visually
if has("multi_byte")
  if &termencoding == ""
    let &termencoding = &encoding
  endif
  set encoding=utf-8
  setglobal fileencoding=utf-8
  "setglobal bomb
  set fileencodings=ucs-bom,utf-8,latin1
endif
"set list listchars=tab:\ \ ,trail:·

" ================ Completion =======================

set wildmode=list:longest
set wildmenu                "enable ctrl-n and ctrl-p to scroll thru matches
set wildignore=*.o,*.obj,*~ "stuff to ignore when tab completing
set wildignore+=*vim/backups*
set wildignore+=*sass-cache*
set wildignore+=*DS_Store*
set wildignore+=log/**
set wildignore+=tmp/**
set wildignore+=*.png,*.jpg,*.gif

"
" ================ Scrolling ========================

set scrolloff=8         "Start scrolling when we're 8 lines away from margins
set sidescrolloff=15
set sidescroll=1

" ================ Search ===========================
" Commented lines relocated to sensible.vim

"set incsearch       " Find the next match as we type the search
set hlsearch        " Highlight searches by default
set ignorecase      " Ignore case when searching...
set smartcase       " ...unless we type a capital

"Get listing of map assignments
function MyMaps()
    redir @" | silent map | redir END | new | put!
endfunction

" diff current buffer and saved file
" use DiffOrig
