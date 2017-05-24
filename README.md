# vimfiles

Windows Vim 8 configuration files based on the recommendations of [Ruslan Osipov](http://www.rosipov.com/blog/vim-pathogen-and-git-submodules/) and [Keep Your vimrc file clean](http://vim.wikia.com/wiki/Keep_your_vimrc_file_clean).

vimsub.sh semi-automates adding bundles as git submodules because my list was getting a little long.

## Anaconda

### PYTHONPATH Considered Harmful

The following works but can have surprising side-effects per [PYTHONPATH Considered Harmful](https://soundcloud.com/talkpython/22-pythonpath-considered-harmful).

For vim-jedi to work with Anaconda, if you haven't compiled vim to know where site-package are, set PYTHONPATH. E.g., set PYTHONPATH=C:\Users\fishe\Anaconda3\Lib\site-packages. This will mess up activate/deactivate conda environments so adjust PYTHONPATH if you switch.

[Using conda-Managing environments](https://conda.io/docs/using/envs.html#saved-environment-variables) provides directions.

In order for root to work without activate root before opening Vim, set user environment variable PYTHONPATH. In order for it to work after activate root follow the instructions in the link above, but the path is Anaconda3\etc\conda.

### vim-conda

vim-conda resolves the vim-jedi issue and allows switching envs within Vim. There are several versions depending on python2, python3 or allowing both.

## [Gutentags](https://github.com/ludovicchabant/vim-gutentags)

* Gutentags handles Vim integration nicely.
* [universal-ctags](https://github.com/universal-ctags/ctags) provides
  direction for obtaining pre-built ctags binary without needing source-forge.
