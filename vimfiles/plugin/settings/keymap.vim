" UltiSnips {{{
let g:UltiSnipsExpandTrigger = '<c-j>'
let g:UltiSnipsListSnippets = '<c-a>'
let g:UltiSnipsJumpForwardTrigger = '<c-j>'
let g:UltiSnipsJumpBackwardTrigger = '<c-k>'
" }}}

" Split navigations {{{
nnoremap <Down> <C-W><C-J>
nnoremap <Up> <C-W><C-K>
nnoremap <Right> <C-W><C-L>
nnoremap <Left> <C-W><C-H>
" }}}

" Navigate within wrapped line {{{
" nnoremap <expr> j v:count ? 'j' : 'gj'
" nnoremap <expr> k v:count ? 'k' : 'gk'
" vnoremap <expr> j v:count ? 'j' : 'gj'
" vnoremap <expr> k v:count ? 'k' : 'gk'
nnoremap <expr> j (v:count > 4 ? "m'" . v:count . 'j' : 'gj')
nnoremap <expr> k (v:count > 4 ? "m'" . v:count . 'k' : 'gk')
vnoremap <expr> j (v:count > 4 ? "m'" . v:count . 'j' : 'gj')
vnoremap <expr> k (v:count > 4 ? "m'" . v:count . 'k' : 'gk')
" }}}

" Curated settings from mswin keymapping {{{
" set the 'cpoptions' to its Vim default
if 1	" only do this when compiled with expression evaluation
  let s:save_cpo = &cpoptions
endif
set cpo&vim

" set 'selection', 'selectmode', 'mousemodel' and 'keymodel' for MS-Windows
if !has('nvim') 
  behave mswin
endif

" backspace and cursor keys wrap to previous/next line
set backspace=indent,eol,start whichwrap+=<,>,[,]

" backspace in Visual mode deletes selection
vnoremap <BS> d

if has("clipboard")

    " CTRL-C and CTRL-Insert are Copy
    vnoremap <C-C> "+y
    vnoremap <C-Insert> "+y

    " CTRL-V and SHIFT-Insert are Paste
    map <C-V>		"+gP
    map <S-Insert>		"+gP

    cmap <C-V>		<C-R>+
    cmap <S-Insert>		<C-R>+
endif

" Pasting blockwise and linewise selections is not possible in Insert and
" Visual mode without the +virtualedit feature.  They are pasted as if they
" were characterwise instead.
" Uses the paste.vim autoload script.
" Use CTRL-G u to have CTRL-Z only undo the paste.

if 1
    exe 'inoremap <script> <C-V> <C-G>u' . paste#paste_cmd['i']
    exe 'vnoremap <script> <C-V> ' . paste#paste_cmd['v']
endif

imap <S-Insert>		<C-V>
vmap <S-Insert>		<C-V>

" Use CTRL-Q to do what CTRL-V used to do
noremap <C-Q>		<C-V>

" restore 'cpoptions'
set cpo&
if 1
  let &cpoptions = s:save_cpo
  unlet s:save_cpo
endif
" }}}

" Delete inner line {{{
nmap dil ^d$
nmap yil ^y$
" }}}

" Prompt for selection after showing list items. {{{
" Vim_pushing_built-in_features_beyond_their_limits.markdown
" https://gist.github.com/Konfekt/d8ce5626a48f4e56ecab31a89449f1f0#file-vim_pushing_built-in_features_beyond_their_limits-markdown
" https://gist.github.com/romainl/047aca21e338df7ccf771f96858edb86
function! <sid>CCR()
  if getcmdtype() isnot# ':'
    return "\<CR>"
  endif
  let cmdline = getcmdline()
  if cmdline =~# '\v^\s*(ls|files|buffers)!?\s*(\s[+\-=auhx%#]+)?$'
    " like :ls but prompts for a buffer command
    let newline = "\<CR>:b"
  elseif cmdline =~# '\v/(#|nu%[mber])$'
    " like :g//# but prompts for a command
    let newline = "\<CR>:"
  elseif cmdline =~# '\v^\s*(dli%[st]|il%[ist])!?\s+\S'
    " like :dlist or :ilist but prompts for a count for :djump or :ijump
    let newline = "\<CR>:" . cmdline[0] . 'j  ' . split(cmdline, ' ')[1] . "\<S-Left>\<Left>"
  elseif cmdline =~# '\v^\s*(cli|lli)%[st]!?\s*(\s\d+(,\s*\d+)?)?$'
    " like :clist or :llist but prompts for an error/location number
    let newline = "\<CR>:sil " . repeat(cmdline[0], 2) . "\<Space>"
  elseif cmdline =~# '\v^\s*ol%[dfiles]\s*$'
    " like :oldfiles but prompts for an old file to edit
    " set nomore
    let newline = "\<CR>:silent set more|e #<"
  elseif cmdline =~# '^\s*changes\s*$'
    " like :changes but prompts for a change to jump to
    " set nomore
    let newline = "\<CR>:silent set more|norm! g;\<S-Left>"
  elseif cmdline =~# '\v^\s*ju%[mps]'
    " like :jumps but prompts for a position to jump to
    " set nomore
    let newline = "\<CR>:silent set more|norm! \<C-o>\<S-Left>"
  elseif cmdline =~# '\v^\s*marks\s*(\s\w+)?$'
    " like :marks but prompts for a mark to jump to
    let newline = "\<CR>:norm! `"
  elseif cmdline =~# '\v^\s*undol%[ist]'
    " like :undolist but prompts for a change to undo
    let newline = "\<CR>:u "
  elseif cmdline =~# '\C^reg'
    " like :registers but prompts for a register to paste
    let newline = "\<CR>:norm! \"p\<Left>"
  elseif cmdline =~# '\C^scr'
    " like :scriptnames but prompts for a register to paste
    let newline = "\<CR>:scriptnames"
  else
    let newline = "\<c-]>\<CR>"
  endif
  noautocmd return newline
endfunction

cnoremap <expr> <CR> <sid>CCR()
" }}}

" Change local directory {{{
nnoremap <silent> <leader>cd :lcd %:p:h<CR>:pwd<CR>
" Always add the current file's directory to the path and tags list
" if not already there. Add it to the beginning to speed up searches.
" Use :find rather than :edit.
augroup localdirectory
  autocmd!

  let s:default_path = escape(&path, '\ ') " store default value of 'path'

  autocmd BufRead *
        \ let s:tempPath=escape(escape(expand("%:p:h"), ' '), '\ ') |
        \ exec "set path-=".s:tempPath |
        \ exec "set path-=".s:default_path |
        \ exec "set path^=".s:tempPath |
        \ exec "set path^=".s:default_path
augroup END
" }}}
