" Check and add conda enviroment required by python3/dyn
function! condaactivate#AddConda2Vim() abort
  let l:conda_prefix = $CONDA_PREFIX
  if stridx(l:conda_prefix, 'vim_python') < 0
    echoerr 'CONDA_PREFIX does not contain vim_python'
    echomsg 'Exit Vim; conda activate vim_python; Retry'
    return
  endif
  let l:apppath = "$LOCALAPPDATA/Microsoft/WindowsApps/*vi*.bat"
  " evim.bat
  " gview.bat
  " gvim.bat
  " gvimdiff.bat
  " view.bat
  " vim.bat
  " vimdiff.bat
  " vimtutor.bat
  echo 'Searching:' expand(l:apppath, )

  silent execute 'vimgrep /rem -- Run Vim --/j ' l:apppath
  let l:bufflist = map(getqflist(), 'v:val.bufnr')

  let l:python = 'call conda activate --stack '..l:conda_prefix

  for l:buffer in l:bufflist
    silent execute 'buffer' l:buffer
    let l:searchresult = search(escape(l:python, '\'), 'w')
    if l:searchresult == 0
      echohl  WarningMsg
      echomsg 'Add' l:python 'to' bufname(l:buffer + 0)
      echohl  None
      call append(1, l:python)
      silent update
    else
      echo 'Already added' l:python 'to' bufname(l:buffer + 0)
    endif

    silent bdelete

  endfor
endfunction
