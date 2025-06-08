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
