# vimfiles

Windows Vim 8 configuration files based on the recommendations of
[Ruslan Osipov](http://www.rosipov.com/blog/vim-pathogen-and-git-submodules/),
[Keep Your vimrc file clean](http://vim.wikia.com/wiki/Keep_your_vimrc_file_clean)
and
[The musings of bluz71](https://bluz71.github.io/2017/05/15/vim-tips-tricks.html).

`:help vimrc` recommends moving vimrc and gvimrc to vimfiles to make the setup
more portable.

## Installation

Several applications are assumed to be in the `PATH`, install
[git-scm](https://git-scm.com/) and select
*User Git and optional Unix tools from the Windows Command Prompt*.
See steps to add a local bin directory for
the other applications referenced in the vim configuration files.

### Install Vim on Linux

On Debian derivatives, like Ubuntu, the
[dotfiles](https://github.com/jfishe/dotfiles)
repository provides an installation script for a compatible version of Vim with
GTK3.

### Install Vim on Windows

[Vim-win32-installer](https://github.com/vim/vim-win32-installer/releases)
includes `python3/dyn` currently linked to `Python 3.8`. Download and install
or use `chocolatey`: `choco install vim`.

### `vimfiles` installation

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

```powershell
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

## Windows Environment

On Windows systems `%HOMEDRIVE%%HOMEPATH%`, e.g., `U:\.` may point to a
different path than `%USERPROFILE%`—i.e., `C:\Users\<user name>`.
`git-scm` defaults to `%HOMEDRIVE%%HOMEPATH%`. Defining `%HOME%`, overrides
this behavior.

1. Open `Control Panel`.
2. Search for `environment`.
3. Select `Edit environment variables for your account`
4. Select New.
5. Variable name: `HOME`
6. Variable value: `%USERPROFILE%`
7. Select OK.
8. Select `Path` and `Edit`.
9. Select `New` and enter `%USERPROFILE%\bin`.
10. Select OK, twice.
11. Open git-bash or git-cmd and confirm directory is `C:\Users\<user name>`.

## Windows Python Version

On Windows `python3/dyn` may point to a later version of python than `conda`
supports in the base environment. Copy or update `gvim.bat`. The usual
locations are:

- `%LOCALAPPDATA%\Microsoft\WindowsApps\gvim.bat`
- `%WINDIR%\gvim.bat`

Adding a call to `conda` and creating a Start-Menu shortcut can resolve the
issue, e.g:

Installing with `chocolatey` will clobber the Vim batch files because it
replaces any it finds in `$env:WINDIR` and
`$env:LOCALAPPDATA\Microsoft\WindowsApps`. The following snippet ensures the
batch files are in `$env:LOCALAPPDATA\Microsoft\WindowsApps` and calls a Vim
function to activate a compatible conda envirionment.
See [Anaconda and Miniconda](#anaconda-and-miniconda) for installation
instructions.

```powershell
# Create python38 environment if it does not exist.
Set-Location "$env:LOCALAPPDATA\vimfiles"
Get-Item .\environment.yml -ErrorAction Stop

if (-not (conda env list | Select-String -Pattern 'python38' -CaseSensitive)) {
  conda env create --file environment.yml
}
```

```powershell
$userappdir = Get-Item $env:LOCALAPPDATA\Microsoft\WindowsApps
$globalappdir = Get-Item $env:WINDIR


$uservimcmd = Join-Path $userappdir '*vim*' | Get-ChildItem
$globalvimcmd = Join-Path $globalappdir '*vim*' | Get-ChildItem

if (-not $uservimcmd -and $globalvimcmd) {
  foreach ($item in $globalvimcmd) {
    Copy-Item $_ $userappdir
  }

& vim -c 'call condaactivate#AddConda2Vim() | :qa'
```

### Anaconda and Miniconda

Install Miniconda or Anaconda per the directions in the
[Anaconda Documentation](https://docs.anaconda.com/anaconda/install/).

[environment.yml](file://./environment.yml) lists the conda and pip packages
needed for the Vim configuration.

To add packages to the conda environment for use by Vim:

```powershell
conda update conda
conda env update --file environment.yml
```

`--name <env>` is not needed and defaults to the current version of python required by Windows Vim. To create an environment:

```powershell
conda update conda
conda env create --name <env> --file environment.yml
```

### Windows Registry

Vim's `install.exe` tries to add right-click menus to `explorer`, but usually
fails, even when installing with administrator rights.
`~\vim\vim82\GvimExt64\GvimExt.reg` provides an example but assumes the `dll`
and executable are in the `PATH`. `GvimExt.reg` provides a working version,
assuming vim is installed in `%USERPROFILE%`.

The following will request administrator permission and add the contents of
`GvimExt.reg` to the Window Registry. Validate the file against the version
included with Vim.

```DOS
regedit /S GvimExt.reg
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

## Gutentags & Universal ctags

- [Gutentags](https://github.com/ludovicchabant/vim-gutentags)
- [universal-ctags](https://github.com/universal-ctags/ctags) provides
  direction for obtaining pre-built ctags binary without needing
  source-forge.

## Conquer of Completion (CoC)

[Conquer of Completion](https://github.com/neoclide/coc.nvim) does not depend
on the python compiled with Vim. It supports Node.js modules that perform the
linting functions of [ALE](#asynchronous-lint-engine-ale).

The script `after/plugin/coc.vim` installs extensions using
`g:coc_global_extensions`. Install CoC under `opt` instead of `start` to allow
disabling when `node.js` is unavailable.

```bash
# for vim8
mkdir -p ~/.vim/pack/coc/opt
cd ~/.vim/pack/coc/opt
curl --fail -L \
  https://github.com/neoclide/coc.nvim/archive/release.tar.gz | tar xzfv -
```

## Asynchronous Lint Engine (ALE)

The [Asynchronous Lint Engine](https://github.com/dense-analysis/ale) supports
various linting (ALELint) and formatting (ALEFix) tools. Many of these are
Node.js packages. See [jfishe/ALE_Nodejs](https://github.com/jfishe/ALE_Nodejs)
for a list and installation instructions. Others, such as `black` can be
installed by `conda` or `pip`. See `environment.yml` for a list.

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

```powershell
New-Item -ItemType Directory -Path $env:USERPROFILE\.config
cmd /c "mklink /J %USERPROFILE%\.vim %LOCALAPPDATA%\vimfiles\vimfiles"
cmd /c "mklink /J %USERPROFILE%\.config\mintty %LOCALAPPDATA%\vimfiles\mintty"
cmd /c "mklink /J %USERPROFILE%\vimwiki %USERPROFILE%\Documents\vimwiki"
```

### Git Hooks

Tim Pope's [Effortless Ctags with Git](https://tbaggery.com/2011/08/08/effortless-ctags-with-git.html)
shows how to rebuild Ctags with git hooks. Note they do not work under
PowerShell or CMD but do not seem to cause problems either. To work under WSL:

```{contenteditable="true" spellcheck="false" caption="bash" .bash}
ln -s /mnt/c/Users/fishe/AppData/Local/vimfiles/.git_template ~/.git_template
```

To make hooks available from Windows, if you have any .bat or .ps1 hooks:

```{contenteditable="true" spellcheck="false" caption="DOS" .dos}
mklink /J %USERPROFILE%\.git_template %LOCALAPPDATA%\vimfiles\.git_template
```

### The Case for Pull Rebase

[The Case for Pull Rebase](https://megakemp.com/2019/03/20/the-case-for-pull-rebase/)
recommends avoiding merge commits, except when they're useful, such as for Pull
Request merges.

```bash
git pull --rebase|-r # Normal to avoid merge commits.
git pull --rebase=preserve # When local merge commit preserved, like Pull Request.
git config --global pull.rebase preserve

# if you're on Git 2.18 or later
git pull --rebase=merges
git config --global pull.rebase merges
```

### Git diff for Excel Files

Xltrail suggested
[3 steps to make Spreadsheet Compare work with git diff](https://www.xltrail.com/blog/git-diff-spreadsheetcompare).
The proposed DOS batch script does not work with Microsoft Office 2016 because
`spreadsheetcompare` is not an installed application. Install a modified version,
which uses `AppVLP.exe`, as follows:

```powershell
cmd /c "mklink %USERPROFILE%\bin\xldiff.bat %LOCALAPPDATA%\vimfiles\vimfiles\xldiff.bat"
```

`.gitconfig` defines `[diff "excel"]` and `.gitattributes_global` sets
`diff=excel` for all Excel file extensions. The batch script pauses git so that
it does not delete any temporary files it creates. Press `<Enter>` in the shell
after exiting `spreadsheetcompare`.

## KeePass2, KeeAgent and SSH

[KeeAgent](https://gist.github.com/strarsis/e533f4bca5ae158481bbe53185848d49)
(for KeePass) on Bash on Windows / WSL provides a howto. Git-bash only requires
`export SSH_AUTH_SOCK=~/keeagent_msys.socket` in .bash_profile, depending on
the KeeAgent settings in KeePass2.

## Map Caps Lock to Escape, or any key to any key

On Windows install PowerToys or Uncap.

### Install PowerToys

- `choco install powertoys`
- Open PowerToys Settings application.
- In Keyboard Manager, map `Caps Lock` to `Esc`.

### Install Uncap

  [susam uncap](https://github.com/susam/uncap). The repository contains
  additional instructions.

- Place in `%USERPROFILE%\bin`.
- Create a Shortcut.
- Move the Shortcut to `Win-R shell:startup` (Win == Start Menu key).
- See
  [Change which apps run automatically at startup in Windows 10](https://support.microsoft.com/en-us/help/4026268/windows-10-change-startup-apps)
  for more details.

## `vimfiles` Update

```powershell
git fetch
git rebase --interactive --autostash --rebase-merges origin/master
git submodule update --init --recursive
```

