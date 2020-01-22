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

On Windows `python3/dyn` may point to a later version of python than `conda`
supports in the base environment. Copy or update `gvim.bat`. The usual
locations are:

- `%LOCALAPPDATA%\Microsoft\WindowsApps\gvim.bat`
- `%WINDIR%\gvim.bat`

Adding a call to `conda` and creating a Start-Menu shortcut can resolve the
issue, e.g:

```DOS
:ntaction
rem Activate conda env compatible with +python3/dyn
call conda activate python38
rem for WinNT we can use %*
if .%VIMNOFORK%==.1 goto noforknt
start "dummy" /b "%VIM_EXE_DIR%\gvim.exe"  %*
```

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

## Gutentags & Universal ctags

- [Gutentags](https://github.com/ludovicchabant/vim-gutentags)
- Gutentags handles Vim integration nicely.
- [universal-ctags](https://github.com/universal-ctags/ctags) provides
  direction for obtaining pre-built ctags binary without needing
  source-forge.

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

```{contenteditable="true" spellcheck="false" caption="powershell" .powershell}
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
