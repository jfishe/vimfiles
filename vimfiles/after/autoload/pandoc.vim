" Pandoc User Autoload
if exists('g:loaded_pandoc_user_after_auto') || &compatible
  finish
endif
let g:loaded_pandoc_user_after_auto = 1

function pandoc#unescape_markdown() abort
  " Suppress :he E486.
  " Remove backslash from \[@abc\] and \@abc.
  %substitute/\\\[\(@.\{-1,}\)\\]/[\1]/ge
  %substitute/\\@/@/ge
  " Remove backslash and uppercase \[x\].
  %substitute/\\\[x\\]/[X]/e
  " Prettier lower cases tasks [x], which Vimwiki does not support.
  call CocAction('format')
  %substitute/\(\[x]\)/\U\1/Ie
endfunction

function pandoc#myst_header_anchor() abort
  " Convert ATX header attribute to MyST anchor.
  %substitute/\(^#\{1,}\s.\{1,}\)\s{#\(.\{1,}\)}/(\2)=\r\1/e
endfunction

function pandoc#zk_makefile_settings() abort
  if !exists('b:vimwiki_wiki_nr')
    return 0
  endif

  let l:makefile = resolve(vimwiki#path#join_path(
        \ vimwiki#vars#get_wikilocal('path'),
        \ 'Makefile'))
  if !filereadable(l:makefile)
    return 0
  endif

  let l:buffer_makefile = findfile('Makefile', expand('%:p:h')..';')

  if empty(l:buffer_makefile)
    return 0
  endif

  let l:buffer_makefile = resolve(fnamemodify(l:buffer_makefile, ':p'))
  if l:buffer_makefile !=# l:makefile
    return 0
  endif

  let &l:makeprg = 'make -C ' .. fnameescape(fnamemodify(l:makefile, ':h'))
        \ .. ' $*/%:t:r.$*'
  let &l:errorformat = join([
        \ '%-Gmake: Entering directory %.%#',
        \ '%-Gmake: Leaving directory %.%#',
        \ '%-Gpandoc %.%# -> %.%#',
        \ '%W[WARNING] %m',
        \ '%E\"%f\"\\, line %l: %m',
        \ '%E%f:%l:%c: %m',
        \ '%E%f:%l: %m',
        \ '%Emake: *** %m',
        \ '%-G%.%#',
        \ ], ',')

  return 1
endfunction
