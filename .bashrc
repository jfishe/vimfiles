set -o vi
if hash virtualenvwrapper_lazy.sh 2>/dev/null; then
   source virtualenvwrapper_lazy.sh
fi
alias l.='ls -d .* --color=auto'
alias la='ls -a --color=auto'
export EDITOR='vim'
