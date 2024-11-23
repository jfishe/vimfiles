# vimfiles

Windows Vim configuration files based on the recommendations of
[Ruslan Osipov](http://www.rosipov.com/blog/vim-pathogen-and-git-submodules/),
[Keep Your vimrc file clean](http://vim.wikia.com/wiki/Keep_your_vimrc_file_clean)
and
[The musings of bluz71](https://bluz71.github.io/2017/05/15/vim-tips-tricks.html).

`:help vimrc` recommends moving vimrc and gvimrc to vimfiles to make the setup
more portable.

## Installation

Several applications are assumed to be in the `PATH`, install
[git-scm](https://git-scm.com/) and select
_User Git and optional Unix tools from the Windows Command Prompt_.
See steps to add a local bin directory for
the other applications referenced in the vim configuration files.

[Manual installation steps for older versions of WSL](https://learn.microsoft.com/en-us/windows/wsl/install-manual)
provides the steps automated by `wsl install`.

```powershell
$Software = @(
  'Git.Git --interactive',
  'Microsoft.PowerToys',
  'Microsoft.WindowsTerminal',
  'UniversalCtags.Ctags',
  'astral-sh.uv'
)
$Software |  ForEach-Object -Process {
  winget install $_
}

dism.exe /online /enable-feature `
  /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
# wsl --install -d Ubuntu --web-download
```

### SSL Error

- [github: server certificate verification failed](https://stackoverflow.com/questions/35821245/github-server-certificate-verification-failed)
  - `server certificate verification failed. CAfile: none CRLfile: none`
  - `SSL certificate problem: unable to get local issuer certificate`
- [How to fix ssl certificate problem unable to get local issuer certificate Git error](https://komodor.com/learn/how-to-fix-ssl-certificate-problem-unable-to-get-local-issuer-certificate-git-error/)

```bash
openssl s_client -showcerts -servername github.com -connect github.com:443 \
  </dev/null 2>/dev/null |
  sed -n -e '/BEGIN\ CERTIFICATE/,/END\ CERTIFICATE/ p'  > github-com.pem
# On Linux
cat github-com.pem | sudo tee -a /etc/ssl/certs/ca-certificates.crt
# On windows C:\Program Files\Git\mingw64\ssl\certs\ or some variant.
cat github-com.pem | tee -a /mingw64/etc/ssl/certs/ca-bundle.crt
```

### Install Vim on Windows Subsystem for Linux

On Debian derivatives, like Ubuntu, the
[dotfiles](https://github.com/jfishe/dotfiles)
repository provides an installation script for a compatible version of Vim with
GTK3. It also links `~/.vim/` to Windows `$USERPROFILE/vimfiles/` to share
configuration across environments.

### Install Vim on Windows

[Vim-win32-installer](https://github.com/vim/vim-win32-installer/releases)
includes `python3/dyn`. Download and install
or use `chocolatey`: `choco install vim`.

- Download the selected zip file and adjust the paths as needed.
- Update python version specification in [environment.yml](environment.yml) to match
  linked version in vim: `vim --version | grep python --color`
- See `Get-Help .\Install-Vimfiles.ps1` for additional information.

```powershell
$DestinationPath = Get-Item -Path "$env:LOCALAPPDATA\Programs"
$Path = Get-ChildItem -Path ~\Downloads\gvim_9.*_x64_signed.zip

Move-Item -Path "$DestinationPath\Vim\vim91" `
  -Destination "$DestinationPath\Vim\vim91.old" `
  -ErrorAction SilentlyContinue
```

```powershell
Expand-Archive -Path $Path -DestinationPath $DestinationPath
```

```powershell
# Check vim works and remove old version.
vim --version | grep python --color
```

```powershell
Remove-Item -Path "$DestinationPath\Vim\vim91.old" -Recurse -Force
```

```powershell
# If needed, create the batch files using the installer.
& $(Get-Item -Path "$DestinationPath\Vim\vim91\install.exe")

# If python/dyn version changes, update the YAML file, remove and re-create
# the conda environment.
conda update conda -n base
conda activate base

conda env remove -n vim-python
.\Install-Vimfiles.ps1 -Conda

# Add/update Start Menu shortcuts.
$IconLocation = Get-Item "$DestinationPath\Vim\vim91\gvim.exe"
.\Install-Vimfiles.ps1 -Shortcut -IconLocation "$IconLocation"
```

### `vimfiles` installation

To install in Windows under `$env:LOCALAPPDATA\vimfiles` and symbolic link to
`$HOME`.

```powershell
cd $env:TMP
curl  --output Install-Vimfiles.ps1 `
  https://raw.githubusercontent.com/jfishe/vimfiles/master/Install-Vimfiles.ps1

# To change defaults:
Get-Help .\Install-Vimfiles.ps1 -Full
```

```powershell
# Clone and install submodules.
.\Install-Vimfiles.ps1 -Clone

# Symlink vimfiles and dotfiles to $HOME.
.\Install-Vimfiles.ps1 -Link

# Create Start-Menu shortcuts.
.\Install-Vimfiles.ps1 -Shortcut

# Copy wsl -d Ubuntu /usr/share/dict/words to vimfiles/dictionary/words.
# Install dictionary if needed.
.\Install-Vimfiles.ps1 -Dictionary

# Download Moby Thesaurus from
# https://raw.githubusercontent.com/zeke/moby/master/words.txt
.\Install-Vimfiles.ps1 -Thesaurus

# Create/update conda environment compatible with `python3/dyn`.
# Create/update Vim batch files to activate vim-python prior to starting Vim.
.\Install-Vimfiles.ps1 -Conda
```

If you plan to share vimfiles with Windows Subsystem for Linux (WSL), ensure
git uses line feed for EOL. `Install-Vimfiles.ps1` automates this by setting
the global .gitconfig to override the system defaults.

## Vimwiki

### New Vimwiki Diary

When creating a new diary (Journal) file, `VimwikiTitleJournal` creates the
title heading and copies the previous diary entry from `Todo` second-level
heading through the end of file.

### VimwikiLinkHandler

`VimwikiLinkHandler` opens `local:` and `file:` URLs with `wslview` or, on
Windows, with `start!`.

### Registered Wikis

- Assume registered wikis, `g:vimwiki_list` are in the Windows Documents folder
  or user home directory. You may need to link `%USERPROFILE%\Documents` to the
  actual location, e.g., OneDrive.

  If the `%USERPROFILE%\Documents` does not exit, either create it, or create a link to the Windows Documents folder.
  - To locate the Windows Documents folder in `cmd.exe`:

    ```DOS
    set REG_PATH=HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\
    set REG_PATH=%REG_PATH%User Shell Folders
    reg query "%REG_PATH%" /v Personal
    ```

  - If you have administrator rights or PowerShell 7, create a symbolic link:

    ```powershell
    $Parameters = @{
      Path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\" +
        "User Shell Folders"
      Name = "Personal"
    }
    $Target = Get-ItemPropertyValue @Parameters
    New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\Documents" `
      -Target "$Target"
    ```

  - Otherwise create a Directory Junction by replacing `<Target>` with the path
    reported by `reg query` above:

    ```DOS
    cmd /c "mklink /J %USERPROFILE%\Documents <Target>"
    ```

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

Rebuild the vim-python whenever the python minor version changes, e.g., from
Python 3.9 to 3.10. Edit `environment.yml` to update the python version and
move other packages to `requirements.txt`. Conda packages typically
lag python versions; the pip versions tend to update first.

### Anaconda and Miniconda

Install Miniconda or Anaconda per the directions in the
[Anaconda Documentation](https://docs.anaconda.com/anaconda/install/).

[environment.yml](environment.yml) lists the conda and pip packages
needed for the Vim configuration.

To add packages to the conda environment for use by Vim:

```powershell
# Periodically update the base and vim-python environments.
conda update -n base conda
conda update -n vim-python --all
```

## Thesaurus

Setup instructions are included in vimrc to install the
[Moby Thesaurus List by Grady Ward](http://www.gutenberg.org/ebooks/3202) from
Project Gutenberg. Use a browser; the site blocks scripted download.

[Moby-thesaurus.org/](https://raw.githubusercontent.com/zeke/moby/master/words.txt)
maintains [words.txt](https://raw.githubusercontent.com/zeke/moby/master/words.txt).

## Dictionary

Refer to `:help dictionary` and download or symlink
[dictionary/words](dictionary/words). See below for symlink instructions.

`Install-Vimfiles.ps1 -Dictionary` assumes Ubuntu is the default and copies the
dictionary since symlinks into WSL fail when the distro isn't started.

## grepprg and grepformat

[`ripgrep`](https://github.com/BurntSushi/ripgrep) should be installed with
`chocolatey`, `conda` or `uv tool install ripgrep`.

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

## Asynchronous Lint Engine (ALE)

The [Asynchronous Lint Engine](https://github.com/dense-analysis/ale) supports
various linting (ALELint) and formatting (ALEFix) tools. Many of these are
Node.js packages. See [jfishe/ALE_Nodejs](https://github.com/jfishe/ALE_Nodejs)
for a list and installation instructions. Others can be installed by `conda` or
`uv pip`. See `environment.yml` for a list.

## Jupyter Notebook

### git configuration

[nbdime](http://nbdime.readthedocs.io/en/latest/) is configured by:

```bash
pip install nbdime
nbdime config-git --enable --global
```

## Windows Setup

### ColorTool

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
cmd /c "mklink $env:USERPROFILE\bin\xldiff.bat $env:LOCALAPPDATA\vimfiles\xldiff.bat"
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

## `vimfiles` Update

Install the plugins in the Git repository.

```powershell
git pull
git submodule update --init --recursive
vim -c 'packloadall | helptags ALL | qa'
```

Update to the latest versions and commit the changes, if any.

```powershell
git submodule update --init --recursive --remote
vim -c 'packloadall | helptags ALL | qa'
git commit -am "chore: update submodules"
git push
```
