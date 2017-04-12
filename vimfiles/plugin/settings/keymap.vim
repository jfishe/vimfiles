"split navigations
nnoremap <Down> <C-W><C-J>
nnoremap <Up> <C-W><C-K>
nnoremap <Right> <C-W><C-L>
nnoremap <Left> <C-W><C-H>

"navigate within wrapped line
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk
"nnoremap <Down> gj
"nnoremap <Up> gk
"vnoremap <Down> gj
"vnoremap <Up> gk
"inoremap <Down> <C-o>gj
"inoremap <Up> <C-o>gk

" Enable folding with the spacebar
nnoremap <space> za

"Undo some mswin keymapping
if has("gui_running")
  unmap <C-F>
endif
