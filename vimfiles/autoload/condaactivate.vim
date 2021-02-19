" Check and add conda enviroment required by python3/dyn
function! condaactivate#AddConda2Vim() abort
  let l:apppath = "$LOCALAPPDATA/Microsoft/WindowsApps/*vim*"
  echomsg 'Searching: ' . l:apppath
  let l:python = 'call conda activate vim_python'
  execute 'vimgrep /rem -- Run Vim --/j ' . l:apppath
  let l:bufflist = map(getqflist(), 'v:val.bufnr')

  for l:buffer in l:bufflist
    execute 'buffer ' . l:buffer
    let l:searchresult = search(l:python, 'w')
    if l:searchresult == 0
      echomsg 'Add ' . l:python . ' to ' . bufname(l:buffer + 0)
      call append(1, l:python)
      update
    else
      echomsg 'Already added ' . l:python . ' to ' . bufname(l:buffer + 0)
    endif

    bdelete

  endfor
endfunction
