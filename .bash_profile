if [ $HOSTNAME == '***REMOVED***' ]
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

if [ -f ~/.bashrc ]; then . ~/.bashrc; fi
