# vimfiles

Windows Vim 8 configuration files based on the recommendations of [Ruslan Osipov](http://www.rosipov.com/blog/vim-pathogen-and-git-submodules/), [Keep Your vimrc file clean](http://vim.wikia.com/wiki/Keep_your_vimrc_file_clean) and [The musings of bluz71](https://bluz71.github.io/2017/05/15/vim-tips-tricks.html).

:help vimrc recommends moving vimrc and gvimrc to vimfiles to make the setup more portable.

To install in Unix based systems:

```
cd ~
git clone https://github.com/jfishe/vimfiles.git .vim
git submodule update --init
```

To install in Windows (git-cmd version--otherwise use `cd ~`):

```
cd %USERPROFILE%
git clone https://github.com/jfishe/vimfiles.git vimfiles
git submodule update --init
```

## Anaconda

### conda update

If conda update fails due to ssl: certificate_verify_failed:

```DOS
SET CONDA_SSL_VERIFY=false
conda update conda requests pyopenssl cryptography
SET CONDA_SSL_VERIFY=
```

The problem seems resolved in Anaconda3 v4.4, which may be due to pyopenssl
v17.0, so caution may be in order for `conda update --all` because conda-forge
is a higher-priority channel.

The corporate firewall occasionally interferes with the certificate chain.
Opening the URL for the failing website, in a browser--e.g.,
[conda-forge](https://anaconda.org/conda-forge/repo?type=conda&label=main)--resolves
the issue for the current session. The work around is only a temporary
fix. An example error message from `conda update conda`:

```
CondaHTTPError: HTTP None None for url <https://conda.anaconda.org/conda-forge/win-64/repodata.json>
Elapsed: None

An HTTP error occurred when trying to retrieve this URL.
HTTP errors are often intermittent, and a simple retry will get you on your way.

SSLError(SSLError(SSLError("bad handshake: Error([('SSL routines', 'ssl3_get_ser ver_certificate', 'certificate verify failed')],)",),),)
```


### conda-forge

.condarc includes conda-forge to support [Pyne](http://pyne.io)

### conda env

[environment.yml](./environment.yml) lists the conda and pip packages I use.

```
conda env create --name <env> --file environment.yml
```

The default environment can be specified by replacing `<env>` with the path to
the Anaconda3 installation directory or replacing the `name:` field in the YAML
file.

### PYTHONPATH Considered Harmful

The following works but can have surprising side-effects per [PYTHONPATH Considered Harmful](https://soundcloud.com/talkpython/22-pythonpath-considered-harmful).

For vim-jedi to work with Anaconda, if you haven't compiled vim to know where
site-package are, set PYTHONPATH. E.g., set
PYTHONPATH=C:\Users\fishe\Anaconda3\Lib\site-packages. This will mess up
activate/deactivate conda environments so adjust PYTHONPATH if you switch.

[Using conda-Managing environments](https://conda.io/docs/using/envs.html#saved-environment-variables) provides directions.

In order for root to work without activate root before opening Vim, set user
environment variable PYTHONPATH. In order for it to work after activate root
follow the instructions in the link above, but the path is Anaconda3\etc\conda.

### vim-conda

vim-conda resolves the vim-jedi issue and allows switching envs within Vim.
There are several versions depending on python2, python3 or allowing both.

## [Gutentags](https://github.com/ludovicchabant/vim-gutentags)

* Gutentags handles Vim integration nicely.
* [universal-ctags](https://github.com/universal-ctags/ctags) provides
  direction for obtaining pre-built ctags binary without needing
  source-forge.

## Jupyter Notebook

### git configuration

[nbdime]( http://nbdime.readthedocs.io/en/latest/ ) is configured by:

```
pip install nbdime
nbdime config-git --enable --global
```
