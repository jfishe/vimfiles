# vimfiles

Windows Vim configuration files based on the recommendations of
[Ruslan Osipov], [Keep Your vimrc file clean] and [The musings of bluz71].

`:help vimrc` recommends moving vimrc and gvimrc to vimfiles to make the setup
more portable.

## Installation

Several applications are assumed to be in the `PATH`.
[chezmoi] manages the Windows applications and configuration
needed by the Vim configuration.
[dotfiles-chezmoi] provides details.

```powershell
winget install --Id twpayne.chezmoi

chezmoi init --apply jfishe/dotfiles-chezmoi
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

# Symlink vimfiles to $HOME.
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

### Install Vim on Windows Subsystem for Linux

On Debian derivatives, like Ubuntu, the [dotfiles] repository provides an
installation script for a compatible version of Vim with GTK3.

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
  or user home directory.
- To locate the Windows Documents folder in `cmd.exe`:

```dos
set REG_PATH=HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\
set REG_PATH=%REG_PATH%User Shell Folders
reg query "%REG_PATH%" /v Personal
```

- or with PowerShell:

```powershell
powershell -NoProfile -NonInteractive -Command `
'[Environment]::GetFolderPath([Environment+SpecialFolder]::MyDocuments)'
```

## Thesaurus

[Moby Thesaurus List by Grady Ward] maintains [Project Gutenberg files.zip].
Use a browser; the site blocks scripted download.
Copy `mthesaur.txt` to `vimfiles/thesaurus/`.

## Dictionary

Refer to `:help dictionary` and download or symlink [dictionary/words]. See
below for symlink instructions.

`Install-Vimfiles.ps1 -Dictionary` assumes '/usr/share/dict/words'
points to a compatible file.

## Vim Dependencies

Vim configuration depends on [junegunn fzf.vim].

- [fzf] a general-purpose command-line fuzzy finder and an interactive terminal toolkit
- [bat] for syntax-highlighted preview
- If [delta] is available, `GF?`, `Commits` and `BCommits` will use it to
  format `git diff` output.
- `Rg` requires [ripgrep (rg)] as do `:he grepprg` and `:he grepformat`.
- `Tags` and `Helptags` require Perl
- `Tags PREFIX` requires `readtags` command from [Universal Ctags]

## Gutentags & Universal ctags

- [Gutentags]
- [Universal Ctags]

Universal Ctags reads `~/ctags.d/*.ctags` and project-root `.ctags.d`.
[chezmoi] installs `~/.ctags.d/default.ctags` from [dotfiles-chezmoi], which
provides the default global excludes.
Use a project-local `.gutctags` only for project-specific overrides.

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
installed by `pixi` or `uv pip`.

[Ruslan Osipov]: http://www.rosipov.com/blog/vim-pathogen-and-git-submodules/
[Keep Your vimrc file clean]: http://vim.wikia.com/wiki/Keep_your_vimrc_file_clean
[The musings of bluz71]: https://bluz71.github.io/2017/05/15/vim-tips-tricks.html
[chezmoi]: https://www.chezmoi.io/
[dotfiles-chezmoi]: https://github.com/jfishe/dotfiles-chezmoi
[dotfiles]: https://github.com/jfishe/dotfiles
[Moby Thesaurus List by Grady Ward]: https://www.gutenberg.org/ebooks/3202
[Project Gutenberg files.zip]: http://www.gutenberg.org/files/3202/files.zip
[dictionary/words]: dictionary/words
[junegunn fzf.vim]: https://github.com/junegunn/fzf.vim
[fzf]: https://github.com/junegunn/fzf
[bat]: https://github.com/sharkdp/bat
[delta]: https://github.com/dandavison/delta
[ripgrep (rg)]: https://github.com/BurntSushi/ripgrep
[Universal Ctags]: https://ctags.io/
[Conquer of Completion]: https://github.com/neoclide/coc.nvim
[Gutentags]: https://github.com/ludovicchabant/vim-gutentags
[ALE]: #asynchronous-lint-engine-ale
[Asynchronous Lint Engine]: https://github.com/dense-analysis/ale
[jfishe/ALE_Nodejs]: https://github.com/jfishe/ALE_Nodejs
