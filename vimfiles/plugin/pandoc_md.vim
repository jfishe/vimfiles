function! VimwikiLinkMarkdown()
  py3 from pandoc_md import wikilink_md
  py3 wikilink_md()
  " py3 vim.command('edit!')
  " call pandoc#command#Pandoc(s:cmd, '')
  " redraw!
  " %substitute/\v\\\[(\S|\s)\\]/[\1]/
  " %substitute/ "wikilink")/)/g
  " %substitute/\\'s/'s/g
endfunction

