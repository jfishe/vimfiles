" Vimwiki user syntax file: lazy nested (code block) syntaxes.
" Runs before pack/vimwiki/start/vimwiki/syntax/vimwiki.vim, which does
" `syntax include` for every entry in the wiki's nested_syntaxes. Narrow that
" to the fence languages present in this buffer, mapped through
" g:vimwiki_nested_syntax_aliases (see plugin/vimwiki.vim).
" Do not set b:current_syntax here; Vimwiki's syntax file must still load.
if exists('b:current_syntax') || !exists('*vimwiki#vars#set_wikilocal')
  finish
endif

function! s:nested_syntaxes() abort
  let l:aliases = get(g:, 'vimwiki_nested_syntax_aliases', {})
  let l:nested = {}
  for l:lang in keys(vimwiki#base#detect_nested_syntax())
    let l:syn = get(l:aliases, tolower(l:lang), l:lang)
    if !empty(globpath(&runtimepath, 'syntax/' .. l:syn .. '.vim', 0, 1))
      " Key is the fence word as written; Vimwiki matches it literally.
      let l:nested[l:lang] = l:syn
    endif
  endfor
  return l:nested
endfunction

call vimwiki#vars#set_wikilocal('nested_syntaxes', s:nested_syntaxes())
" Detection is done above; Vimwiki's own pass would add unmapped fence words.
call vimwiki#vars#set_wikilocal('automatic_nested_syntaxes', 0)
" vim:tabstop=2:shiftwidth=2:expandtab:textwidth=79
