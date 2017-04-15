# vimfiles

Windows Vim 8 configuration files based on the recommendations of [Ruslan Osipov](http://www.rosipov.com/blog/vim-pathogen-and-git-submodules/) and [Keep Your vimrc file clean](http://vim.wikia.com/wiki/Keep_your_vimrc_file_clean).

vimsub.sh semi-automates adding bundles as git submodules because my list was getting a little long.

## Anaconda

For vim-jedi to work with Anaconda, if you haven't compiled vim to know where site-package are, set PYTHONPATH. E.g., set PYTHONPATH=C:\Users\fishe\Anaconda3\Lib\site-packages. This will mess up activate/deactivate conda environments so adjust PYTHONPATH if you switch.

https://conda.io/docs/using/envs.html#saved-environment-variables provides directions.
