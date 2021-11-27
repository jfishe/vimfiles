set -o vi
export EDITOR='vim'

if hash virtualenvwrapper_lazy.sh 2>/dev/null; then
   source virtualenvwrapper_lazy.sh
fi
alias l.='ls -d .* --color=auto'
alias la='ls -a --color=auto'


# alias gvim='/c/Windows/gvim.bat --remote-silent'
gvim() {
    opt=''
    #if [ \`expr "\$*" : '.*tex\\>'\` -gt 0 ] ; then
    #    opt='--servername LATEX '
    #fi
    # cyg-wrapper.sh "C:\Program Files\Vim\vim80\gvim.exe" --binary-opt=-c,--cmd,-T,-t,--servername,--remote-send,--remote-expr --cyg-verbose --fork=2 $opt "$@"
    # cyg-wrapper2.sh "C:\Program Files\Vim\vim80\gvim.exe" --binary-opt=-c,--cmd,-T,-t,--servername,--remote-send,--remote-expr --cyg-verbose --fork=2 $opt "$@"
    cyg-wrapper2.sh "gvim.bat" --binary-opt=-c,--cmd,-T,-t,--servername,--remote-send,--remote-expr --cyg-verbose --fork=1 $opt "$@"
}

# Initialze conda
declare -a arr=(
        "`cygpath ${LOCALAPPDATA}`/Continuum/anaconda3/Scripts"
        "$HOME/Anaconda3/Scripts"
        "$HOME/Miniconda3/Scripts"
        )
for i in "${arr[@]}"; do
    [[ -x "$i/conda.exe" ]] && eval "$($i/conda.exe shell.bash hook)"
done
unset arr i
