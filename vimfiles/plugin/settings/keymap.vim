"split navigations
nnoremap <Down> <C-W><C-J>
nnoremap <Up> <C-W><C-K>
nnoremap <Right> <C-W><C-L>
nnoremap <Left> <C-W><C-H>

"navigate within wrapped line
nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'
vnoremap <expr> j v:count ? 'j' : 'gj'
vnoremap <expr> k v:count ? 'k' : 'gk'

" Enable folding with the spacebar
nnoremap <space> za

" Insert current date
if exists('*strftime')
    " 06/11/18 12:08:07
    " call IMAP ('date`', "\<c-r>=strftime('%C')\<cr>", '')
    " RFC822 format:
    " Mon, 11 Jun 2018 12:11:41 -0700
    " call IMAP ('date`', "\<c-r>=strftime('%a, %d %b %Y %H:%M:%S %z')\<cr>", '')
    " ISO8601/W3C format (http://www.w3.org/TR/NOTE-datetime)
    " 2018-06-11T12:08:32-0700
    call IMAP ('date`', "\<c-r>=strftime('%FT%T%z')\<cr>", '')
endif


"Undo some mswin keymapping
if has('gui_running')
  unmap <C-F>
endif
