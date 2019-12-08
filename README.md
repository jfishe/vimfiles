# vimfiles

Windows Vim 8 configuration files based on the recommendations of
[Ruslan Osipov](http://www.rosipov.com/blog/vim-pathogen-and-git-submodules/),
[Keep Your vimrc file clean](http://vim.wikia.com/wiki/Keep_your_vimrc_file_clean)
and
[The musings of bluz71](https://bluz71.github.io/2017/05/15/vim-tips-tricks.html).

:help vimrc recommends moving vimrc and gvimrc to vimfiles to make the setup
more portable.

## Installation

Several applications are assumed to be in the `PATH`, install
[git-scm](https://git-scm.com/) and select
`User Git and optional Unix tools from the Windows Command Prompt`.
See steps to add a local bin directory for
the other applications referenced in the vim configuration files.

On Windows systems `%HOMEDRIVE%%HOMEPATH%`, e.g., `U:\.` may point to a
different path than `%USERPROFILE%`, e.g., `C:\Users\<user name>`.
`git-scm` defaults to `%HOMEDRIVE%%HOMEPATH%`. Defining `%HOME%`, overrides
this behavior.

- Open `Control Panel`.
- Search for `environment`.
- Select `Edit environment variables for your account`
- Select New.
- Variable name: `HOME`
- Variable value: `%USERPROFILE%`
- Select OK.
- Select `Path` and `Edit`.
- Select `New` and enter `%USERPROFILE%\bin`.
- Select OK, twice.
- Open git-bash or git-cmd and confirm directory is `C:\Users\<user name>`.

## vimfiles installation

To install in Unix based systems:

```bash
cd $TMP
git clone https://github.com/jfishe/vimfiles.git
mv vimfiles/vimfiles vimfiles/.vim
cp -r vimfiles/. ~
cd ~
git submodule update --init --recursive --remote
```

To install in Windows (git-cmd version--otherwise use `cd ~`):

```DOS
cd %TMP%
git clone https://github.com/jfishe/vimfiles.git vimfiles
xcopy vimfiles %USERPROFILE% /s/h/k
cd %USERPROFILE%
git submodule update --init --recursive --remote
```

```{contenteditable="true" spellcheck="false" caption="powershell" .powershell}
# Clone vimfiles into LOCALAPPDATA
Set-Location -Path "$env:LOCALAPPDATA"
git clone https://github.com/jfishe/vimfiles.git vimfiles
Set-Location -Path .\vimfiles
git submodule update --init --recursive

$vimfiles = "$env:LOCALAPPDATA\vimfiles"
$dotfiles = Get-ChildItem -Path "$vimfiles\.*"


# Backup old configuration, if needed. Mklink will fail if Target exists.
Set-Location -Path "~"
mkdir .\old
Move-Item -Path .\vimfiles -Destination .\old
$dotfiles | ForEach-Object {
    $item = $_.name
    Move-Item -Path .\$($item) -Destination .\old -ErrorAction SilentlyContinue
}

# Link vimfiles and dotfiles to USERPROFILE
Set-Location -Path "~"
cmd /c "mklink /J .\vimfiles $vimfiles\vimfiles"
$dotfiles | ForEach-Object {
    $item = $_.name
    if ($_.PSIsContainer) {
      cmd /c "mklink /J .\$item $_"
    } else {
      cmd /c "mklink .\$item $_"
    }
}
```

## vimfiles Update

```{contenteditable="true" spellcheck="false" caption="powershell" .powershell}
git fetch
git rebase --interactive --autostash --rebase-merges origin/master
git submodule update --init --recursive
```

## Thesaurus

Setup instructions are included in vimrc to install the
[Moby Thesaurus List by Grady Ward](http://www.gutenberg.org/ebooks/3202) from
Project Gutenberg. Use a browser; the site blocks scripted download.

## grepprg and grepformat

[Faster Grepping in Vim](https://robots.thoughtbot.com/faster-grepping-in-vim)
recommends `ag`.
[The silver searcher](https://github.com/ggreer/the_silver_searcher) needs
to be installed or default grep will be used. VWS speed is greatly improved by
re-defining the command. Grepprg and grepformat need to be set per
[ag.1.md](https://github.com/ggreer/the_silver_searcher/blob/master/doc/ag.1.md).

## Anaconda

### conda update

The corporate firewall occasionally interferes with the certificate chain.
Opening the URL for the failing website, in a browser--e.g.,
[conda-forge](https://anaconda.org/conda-forge/repo?type=conda&label=main)--resolves
the issue for the current session. The work around is only a temporary
fix. An example error message from `conda update conda`:

``` powershell

    CondaHTTPError: HTTP None None for url <https://conda.anaconda.org/conda-forge/win-64/repodata.json>
    Elapsed: None

    An HTTP error occurred when trying to retrieve this URL.
    HTTP errors are often intermittent, and a simple retry will get you on your way.

    SSLError(SSLError(SSLError("bad handshake: Error([('SSL routines',
    'ssl3_get_ser ver_certificate', 'certificate verify failed')],)",),),)

```

### conda env

[environment.yml](file://./environment.yml) lists the conda and pip packages I use.

Replace the `name:` and `prefix:` with the Anaconda3 installation path. `name:`
could also be an env.

To add packages to the default conda environment:

```DOS
conda update conda
conda env update --file environment.yml
```

To create an environment:

```DOS
conda update conda
conda env create --name <env> --file environment.yml
```

The default environment can be specified by replacing `<env>` with the path to
the Anaconda3 installation directory or replacing the `name:` field in the YAML
file.

### PYTHONPATH Considered Harmful

The following works but can have surprising side-effects per
[PYTHONPATH Considered Harmful](https://soundcloud.com/talkpython/22-pythonpath-considered-harmful).

For vim-jedi to work with Anaconda, if you haven't compiled vim to know where
site-package are, set PYTHONPATH. E.g., set
PYTHONPATH=C:\Users\fishe\Anaconda3\Lib\site-packages. This will mess up
activate/deactivate conda environments so adjust PYTHONPATH if you switch.

[Using conda-Managing environments](https://conda.io/docs/using/envs.html#saved-environment-variables)
provides directions.

In order for root to work without activate root before opening Vim, set user
environment variable PYTHONPATH. In order for it to work after activate root
follow the instructions in the link above, but the path is Anaconda3\etc\conda.

### Conda Support in PowerShell

`environment.yml` includes `pscondaenvs`. To use, create a shortcut, similar to following:

```{contenteditable="true" spellcheck="false" caption="powershell" .powershell}
Install-Module -Name PSShortcut -Scope CurrentUser
$obj = New-Object -ComObject WScript.Shell
[string]$from = "Anaconda Prompt.lnk"
[string]$to = "Anaconda Powershell.lnk"

$AnacondaPrompt = Get-Shortcut -Name "$from" `
    -FolderPath "$env:APPDATA\Microsoft\Windows\Start Menu\Programs" |
    Where-Object {$_.Name -eq "$from"}

$lnk = $obj.CreateShortcut($AnacondaPrompt)

[string]$PSAnacondaPrompt = [string]$AnacondaPrompt.FullName.Replace($from.tostring(),$to.ToString())
$link = $obj.CreateShortcut($PSAnacondaPrompt)
$link.TargetPath = "$PSHOME\powershell.exe"
$link.WorkingDirectory = $lnk.WorkingDirectory
$link.Arguments = '-ExecutionPolicy Bypass -Noexit ' + `
    """$env:CONDA_PREFIX\Scripts\activate.ps1""" + " $env:CONDA_DEFAULT_ENV"
$link.Description = $to.Split(".")[0]
$link.Save()
```

### Windows Vim-Tux

Recent versions of [vim-tux](https://tuxproject.de/projects/vim/ "Vim-Builds")
compiled with `+python3/dyn` need the `PYTHONHOME` environment variable set.
Otherwise vim will crash in Anaconda environments:

``` powershell
    C:\>vim
    Fatal Python error: initfsencoding: unable to load the file system codec
    ModuleNotFoundError: No module named 'encodings'

    Current thread 0x00003a54 (most recent call first):
```

Environment variables can be set when an Anaconda environment is activated.
Instructions are provided in the
[Conda User Guide](https://conda.io/docs/user-guide/tasks/manage-environments.html#windows)
for creating `env_vars.bat` files.

In each of the `conda` environments, do the following:

- Add `set PYTHONHOME=%CONDA_PREFIX%` to `activate.d\env_vars.bat`.
- Add `set PYTHONHOME=` to `deactivate.d\env_vars.bat`.

## vim-conda

vim-conda resolves the vim-jedi issue and allows switching envs within Vim.
There are several versions depending on python2, python3 or allowing both.

## Gutentags & Universal ctags

- [Gutentags](https://github.com/ludovicchabant/vim-gutentags)
- Gutentags handles Vim integration nicely.
- [universal-ctags](https://github.com/universal-ctags/ctags) provides
  direction for obtaining pre-built ctags binary without needing
  source-forge.

## Asynchronous Lint Engine (ALE)

The [Asynchronous Lint Engine](https://github.com/w0rp/ale) supports various
linting (ALELint) and formatting (ALEFix) tools. Many of these are Node.js
packages. See [jfishe/ALE_Nodejs](https://github.com/jfishe/ALE_Nodejs) for
a list and installation instructions. Others, such as `black` can be installed
by `conda` or `pip`. See `environment.yml` for a list.

### MarkdownLint Command Line Interface

[MarkdownLint](https://github.com/igorshubovych/markdownlint-cli.git) can
be used with ALE.

`ALE` detects `markdownlint` if `filetype=pandoc.markdown`.
`vimfiles/after/plugin/pandoc.vim` contains an `augroup` that sets `filetype`
based on `*.md`, overriding the vim-pandoc-syntax default `filetype=pandoc`.

The parent project lists the rules under [`docs/Rules.md`](https://github.com/markdownlint/markdownlint/blob/master/docs/RULES.md).

## Jupyter Notebook

### git configuration

[nbdime](http://nbdime.readthedocs.io/en/latest/) is configured by:

```bash
pip install nbdime
nbdime config-git --enable --global
```

### Default Browser

The default browser on Windows 7 and 10 needs to remain IE/Edge to avoid
conflicts with various applications. ~/.jupyter/jupyter_notebook_config.py is
modified to specify Chrome as the notebook and lab browser since IE is not
compatible with notebook v. 5.

## Windows Setup

### Console

Download the latest release of ColorTool and extract into the PATH, e.g.,
`~/bin`. Include the schemes directory and add any additional schemes, as
desired. Create a hard-link `mklink /h` from `~/bin/schemes` to each of the
`.itermcolors` files in `$env:PROFILE` directory.

New schemes may be tested and exported to `iTerm2` format with
[terminal.sexy](https://terminal.sexy/).

- [Introducing the Windows Console Colortool](https://blogs.msdn.microsoft.com/commandline/2017/08/11/introducing-the-windows-console-colortool/)
- [ColorTool](https://github.com/Microsoft/Console/tree/master/tools/ColorTool).

## Setup Python Project

```bash
cookiecutter cookiecutter-pypackage
```

Change to the pypackage directory you created and make initial commit to source
control.

```bash
git init
git add .
git commit -m "Initial project scaffold"
git status
```

```bash
virtualenv env
# Use env/bin/activate on Linux
env\Scripts\activate
pip install -e .
```

## Git

[ElateralLtd git commit template](https://github.com/ElateralLtd/git-commit-template)
provides a template and installation script for standard git commit messages.

The Vim that ships with Git-bash can use the same profile as Gvim. Using WSL
bash is the easiest method to create soft-links. Git-bash won't and recommends
using mklink, but mklink usually has complex ACL issues, especially in
a corporate environment. PowerShell and CMD do not recognize soft-linked
directories so use `mklink /J LINK TARGET`.

The following assumes that git-bash has been configured to use `%USERPROFILE%`
as home, which may be different than the default `%HOMEDRIVE%%HOMEPATH%`. Also,
_Documents_ could be _My Documents_. Adjust the path for actual location of
`vimfiles` and `vimwiki`. The vim startup script assumes that for anything,
except Windows `cmd.exe`, that these files are located in `$HOME`. Soft-links
allow pointing to the actual location.

``` {contenteditable="true" spellcheck="false" caption="powershell" .powershell}
New-Item -ItemType Directory -Path $env:USERPROFILE\.config
cmd /c "mklink /J %USERPROFILE%\.vim %LOCALAPPDATA%\vimfiles\vimfiles"
cmd /c "mklink /J %USERPROFILE%\.config\mintty %LOCALAPPDATA%\vimfiles\mintty"
cmd /c "mklink /J %USERPROFILE%\vimwiki %USERPROFILE%\Documents\vimwiki"
```

### Git Hooks

Tim Pope's [Effortless Ctags with Git](https://tbaggery.com/2011/08/08/effortless-ctags-with-git.html)
shows how to rebuild Ctags with git hooks. Note they do not work under
PowerShell or CMD but do not seem to cause problems either. To work under WSL:

``` {contenteditable="true" spellcheck="false" caption="bash" .bash}
ln -s /mnt/c/Users/fishe/AppData/Local/vimfiles/.git_template ~/.git_template
```

To make hooks available from Windows, if you have any .bat or .ps1 hooks:

``` {contenteditable="true" spellcheck="false" caption="DOS" .dos}
mklink /J %USERPROFILE%\.git_template %LOCALAPPDATA%\vimfiles\.git_template
```

### The Case for Pull Rebase

[The Case for Pull Rebase](https://megakemp.com/2019/03/20/the-case-for-pull-rebase/)
recommends avoiding merge commits, except when they're useful, such as for Pull
Request merges.

``` bash
git pull --rebase|-r # Normal to avoid merge commits.
git pull --rebase=preserve # When local merge commit preserved, like Pull Request.
git config --global pull.rebase preserve

# if you're on Git 2.18 or later
git pull --rebase=merges
git config --global pull.rebase merges
```

## KeePass2, KeeAgent and SSH

[KeeAgent](https://gist.github.com/strarsis/e533f4bca5ae158481bbe53185848d49)
(for KeePass) on Bash on Windows / WSL provides a howto. Git-bash only requires
`export SSH_AUTH_SOCK=~/keeagent_msys.socket` in .bash_profile, depending on
the KeeAgent settings in KeePass2.

## Map Caps Lock to Escape, or any key to any key

- Download `uncap.exe` from a release of
  [susam uncap](https://github.com/susam/uncap). The repository contains
  additional instructions.
- Place in `%USERPROFILE%\bin`.
- Create a Shortcut.
- Move the Shortcut to `Win-R shell:startup` (Win == Start Menu key).
- See
  [Change which apps run automatically at startup in Windows 10](https://support.microsoft.com/en-us/help/4026268/windows-10-change-startup-apps)
  for more details.
