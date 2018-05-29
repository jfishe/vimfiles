if [ $USERDOMAIN == '***REMOVED***' ]
then
    # Set these in ~/.bash_profile or ~/.bashrc to overide ~/.gitconfig:
    # GIT_AUTHOR_NAME is the human-readable name in the “author” field.
    GIT_AUTHOR_NAME='John D. Fisher'
    # GIT_AUTHOR_EMAIL is the email for the “author” field.
    GIT_AUTHOR_EMAIL='jdfisher@energy-northwest.com'
    # GIT_AUTHOR_DATE is the timestamp used for the “author” field.
    # GIT_COMMITTER_NAME sets the human name for the “committer” field.
    GIT_COMMITTER_NAME=${GIT_AUTHOR_NAME}
    # GIT_COMMITTER_EMAIL is the email address for the “committer” field.
    GIT_COMMITTER_EMAIL=${GIT_AUTHOR_EMAIL}
    # GIT_COMMITTER_DATE is used for the timestamp in the “committer” field.
    # EMAIL is the fallback email address in case the user.email configuration
    # value isn’t set. If this isn’t set, Git falls back to the system user and
    # host names.
    EMAIL=${GIT_AUTHOR_EMAIL}
    export GIT_AUTHOR_NAME GIT_AUTHOR_EMAIL
    export GIT_COMMITTER_NAME GIT_COMMITTER_EMAIL
    export EMAIL
fi

# export SSH_AUTH_SOCK=~/keeagent_msysGit.socket
export SSH_AUTH_SOCK=~/keeagent_msys.socket

# https://help.github.com/articles/working-with-ssh-key-passphrases/
env=~/.ssh/agent.env

agent_load_env () { test -f "$env" && . "$env" >| /dev/null ; }

agent_start () {
    (umask 077; ssh-agent >| "$env")
    . "$env" >| /dev/null ; }

agent_load_env

# agent_run_state: 0=agent running w/ key; 1=agent w/o key; 2= agent not running
agent_run_state=$(ssh-add -l >| /dev/null 2>&1; echo $?)

if [ ! "$SSH_AUTH_SOCK" ] || [ $agent_run_state = 2 ]; then
    agent_start
    ssh-add
elif [ "$SSH_AUTH_SOCK" ] && [ $agent_run_state = 1 ]; then
    ssh-add
fi

unset env

# generated by Git for Windows
test -f ~/.profile && . ~/.profile
test -f ~/.bashrc && . ~/.bashrc
