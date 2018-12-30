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

# Anaconda: Setup conda
# conda activate to enable
# condaprofile="`cygpath ${LOCALAPPDATA}`/Continuum/anaconda3/etc/profile.d/conda.sh"
condaprofile="`cygpath ${LOCALAPPDATA}`/Continuum/anaconda3/Scripts/conda.exe"
homecondaprofile=~/Anaconda3/Scripts/conda.exe
if [ -f ${condaprofile} ]; then
    eval "$($condaprofile shell.bash hook)"
elif [ -f ${homecondaprofile} ]; then
    eval "$($homecondaprofile shell.bash hook)"
fi
