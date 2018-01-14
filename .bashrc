set -o vi
export EDITOR='vim'

if hash virtualenvwrapper_lazy.sh 2>/dev/null; then
   source virtualenvwrapper_lazy.sh
fi
alias l.='ls -d .* --color=auto'
alias la='ls -a --color=auto'


alias gvim='/c/Windows/gvim.bat --remote-silent'

