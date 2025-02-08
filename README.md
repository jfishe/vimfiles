# vimfiles

Windows Vim configuration files based on the recommendations of
[Ruslan Osipov], [Keep Your vimrc file clean] and [The musings of bluz71].

`:help vimrc` recommends moving vimrc and gvimrc to vimfiles to make the setup
more portable.

## Installation

Several applications are assumed to be in the `PATH`, install [git-scm] and
select _User Git and optional Unix tools from the Windows Command Prompt_. See
steps to add a local bin directory for the other applications referenced in the
vim configuration files.

[Chocolatey] and [winget] provide package managers.

```powershell
# winget export --output=winget.json
winget import --import-file=winget.json
```

[Manual installation steps for older versions of WSL] provides the steps
automated by `wsl install`.

```powershell
dism.exe /online /enable-feature `
  /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
# wsl --install -d Ubuntu --web-download
```

### SSL Error

- [github: server certificate verification failed]
  - `server certificate verification failed. CAfile: none CRLfile: none`
  - `SSL certificate problem: unable to get local issuer certificate`
- [How to fix ssl certificate problem unable to get local issuer certificate Git error]

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

On Debian derivatives, like Ubuntu, the [dotfiles] repository provides an
installation script for a compatible version of Vim with GTK3. It also links
`~/.vim/` to Windows `$USERPROFILE/vimfiles/` to share configuration across
environments.

### Install Vim on Windows

[Vim-win32-installer] includes `python3/dyn`. Download and install or use
[Chocolatey]: `choco install vim`.

- Download the selected zip file and adjust the paths as needed.
- Not needed for recent versions of Vim 9. If needed, update the python version
  specification in [environment.yml] to match linked version in:
  `vim --version | grep python --color`

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

If they don't already exist, create the batch files using the installer. They
are needed to activate the vim-python conda environment, prior to starting Vim.

```powershell
& $(Get-Item -Path "$DestinationPath\Vim\vim91\install.exe")
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
```

- Create/update a conda environment compatible with `python3/dyn`.
- Install [Miniconda] if needed, and create or update conda env vim-python.
- Copy Vim batch files to `$env:LOCALAPPDATA\Microsoft\WindowsApps`:
  - They are needed to activate the vim-python conda environment, prior to
    starting Vim.
  - If they don't already exist, create the batch files using the Vim
    installer, usually `*\Vim\vim*\install.exe`.
- Add Windows Registry entry to run `%USERPROFILE%\.init.cmd` when starting
  `cmd.exe`. `.init.cmd` activates `vim-python` environment for use by Vim.

```powershell
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

  If the `%USERPROFILE%\Documents` does not exit, either create it, or create a
  link to the Windows Documents folder.

  - To locate the Windows Documents folder in `cmd.exe`:

    ```dos
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

    ```dos
    cmd /c "mklink /J %USERPROFILE%\Documents <Target>"
    ```

## Anaconda and Miniconda

[Kaa Mi]. Posted on 2024-06-19. _Using Miniconda with Conda-Forge to Avoid
Anaconda Licensing Issues_.

1. Download and Install [Miniconda].
2. Initialize Conda with `conda init`.
3. Add Conda-Forge as the Default Channel.

   ```powershell
   conda config --remove channels defaults
   conda config --add channels conda-forge
   conda config --set channel_priority strict
   ```

4. Create a New Environment. [environment.yml] lists the conda and pip packages
   needed for the Vim configuration.

   ```powershell
   conda env create -f environment.yml
   conda activate vim-python
   conda config --show channels
   ```

5. Periodically update the base and vim-python environments.

   ```powershell
   conda update -n base conda
   conda update -n vim-python --all
   ```

## Thesaurus

Setup instructions are included in vimrc to install the [Moby Thesaurus List by
Grady Ward] from Project Gutenberg. Use a browser; the site blocks scripted
download.

[Moby-thesaurus.org/] maintains [words.txt][Moby-thesaurus.org/].

## Dictionary

Refer to `:help dictionary` and download or symlink [dictionary/words]. See
below for symlink instructions.

`Install-Vimfiles.ps1 -Dictionary` assumes Ubuntu is the default and copies the
dictionary since symlinks into WSL fail when the distro isn't started.

## grepprg and grepformat

[ripgrep] should be installed with [Chocolatey], `conda` or
`uv tool install ripgrep`.

## Gutentags & Universal ctags

- [Gutentags]
- [universal-ctags]

## Conquer of Completion (CoC)

[Conquer of Completion] does not depend on the python compiled with Vim. It
supports `node.js` modules that perform the linting functions of [ALE].

The script `after/plugin/coc.vim` installs extensions using
`g:coc_global_extensions`. Install CoC under `opt` instead of `start` to allow
disabling when `node.js` is unavailable.

## Asynchronous Lint Engine (ALE)

The [Asynchronous Lint Engine] supports various linting (ALELint) and
formatting (ALEFix) tools. Many of these are `node.js` packages. See
[jfishe/ALE_Nodejs] for a list and installation instructions. Others can be
installed by `conda` or `uv pip`. See [environment.yml] for a list.

## Jupyter Notebook

### git configuration

[nbdime] is configured by:

```bash
pip install nbdime
nbdime config-git --enable --global
```

## Windows Setup

### ColorTool

[ColorTool] schemes may be tested and exported to `iTerm2` format with
[terminal.sexy].

## Setup Python Project

<!-- TODO: <07-02-25, jfishe> Update for pyscaffold and uv. -->

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

<!--  TODO: \<07-02-25, jfishe\> Add git-lint.  -->

[ElateralLtd git commit template] provides a template and installation script
for standard git commit messages.

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

[The Case for Pull Rebase] recommends avoiding merge commits, except when
they're useful, such as for Pull Request merges.

```bash
git pull --rebase # Normal to avoid merge commits.

# if you're on Git 2.18 or later
git pull --rebase=merges
git config --global pull.rebase merges
```

### Git diff for Excel Files

Xltrail suggested [3 steps to make Spreadsheet Compare work with git diff]. The
proposed DOS batch script does not work with Microsoft Office 2016 because
`spreadsheetcompare` is not an installed application. Install a modified
version, which uses `AppVLP.exe`, as follows:

```powershell
cmd /c "mklink $env:USERPROFILE\bin\xldiff.bat $env:LOCALAPPDATA\vimfiles\xldiff.bat"
```

`.gitconfig` defines `[diff "excel"]` and `.gitattributes_global` sets
`diff=excel` for all Excel file extensions. The batch script pauses git so that
it does not delete any temporary files it creates. Press `<Enter>` in the shell
after exiting `spreadsheetcompare`.

## KeePass2, KeeAgent and SSH

[KeeAgent] (for KeePass) on Bash on Windows / WSL provides a howto. Git-bash
only requires `export SSH_AUTH_SOCK=~/keeagent_msys.socket` in .bash_profile,
depending on the KeeAgent settings in KeePass2.

## Map Caps Lock to Escape, or any key to any key

On Windows install PowerToys or Uncap.

### Install PowerToys

- Install with [Chocolatey] or [winget].
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

[Ruslan Osipov]: http://www.rosipov.com/blog/vim-pathogen-and-git-submodules/
[Keep Your vimrc file clean]: http://vim.wikia.com/wiki/Keep_your_vimrc_file_clean
[The musings of bluz71]: https://bluz71.github.io/2017/05/15/vim-tips-tricks.html
[git-scm]: https://git-scm.com/
[Chocolatey]: https://chocolatey.org/
[winget]: https://learn.microsoft.com/en-us/windows/package-manager/winget/
[Manual installation steps for older versions of WSL]: https://learn.microsoft.com/en-us/windows/wsl/install-manual
[github: server certificate verification failed]: https://stackoverflow.com/questions/35821245/github-server-certificate-verification-failed
[How to fix ssl certificate problem unable to get local issuer certificate Git error]: https://komodor.com/learn/how-to-fix-ssl-certificate-problem-unable-to-get-local-issuer-certificate-git-error/
[dotfiles]: https://github.com/jfishe/dotfiles
[Vim-win32-installer]: https://github.com/vim/vim-win32-installer/releases
[environment.yml]: environment.yml
[Kaa Mi]: https://dev.to/kaamisan/using-miniconda-with-conda-forge-to-avoid-anaconda-licensing-issues-5hkj
[Miniconda]: https://docs.anaconda.com/miniconda/
[Moby Thesaurus List by Grady Ward]: http://www.gutenberg.org/ebooks/3202
[Moby-thesaurus.org/]: https://raw.githubusercontent.com/zeke/moby/master/words.txt
[dictionary/words]: dictionary/words
[ripgrep]: https://github.com/BurntSushi/ripgrep
[Gutentags]: https://github.com/ludovicchabant/vim-gutentags
[universal-ctags]: https://github.com/universal-ctags/ctags
[Conquer of Completion]: https://github.com/neoclide/coc.nvim
[ALE]: #asynchronous-lint-engine-ale
[Asynchronous Lint Engine]: https://github.com/dense-analysis/ale
[jfishe/ALE_Nodejs]: https://github.com/jfishe/ALE_Nodejs
[nbdime]: http://nbdime.readthedocs.io/en/latest/
[terminal.sexy]: https://terminal.sexy/
[ColorTool]: https://github.com/microsoft/terminal/tree/main/src/tools/ColorTool
[ElateralLtd git commit template]: https://github.com/ElateralLtd/git-commit-template
[The Case for Pull Rebase]: https://megakemp.com/2019/03/20/the-case-for-pull-rebase/
[3 steps to make Spreadsheet Compare work with git diff]: https://www.xltrail.com/blog/git-diff-spreadsheetcompare
[KeeAgent]: https://gist.github.com/strarsis/e533f4bca5ae158481bbe53185848d49
