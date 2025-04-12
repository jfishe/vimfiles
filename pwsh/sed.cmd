@echo off
rem -- Run Git for Windows Sed --
rem # uninstall key: Git #
rem https://github.com/junegunn/fzf.vim requires sed for fzf#vim#complete#path()
rem Copy to %LOCALAPPDATA%\Microsoft\WindowsApps\sed.cmd if sed.exe is not in PATH.

setlocal
set GIT=%ProgramFiles%\Git
set PATH=%GIT%\cmd;%GIT%\mingw64\bin;%GIT%\usr\bin;%PATH%
sed.exe %*
