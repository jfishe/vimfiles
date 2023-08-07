@echo off
REM To run ~/.init.cmd for every cmd.exe.
REM reg add "HKCU\Software\Microsoft\Command Processor" /v AutoRun ^
REM   /t REG_EXPAND_SZ /d "%"USERPROFILE"%\.init.cmd" /f
REM To remove AutoRun:
REM reg delete "HKCU\Software\Microsoft\Command Processor" /v AutoRun
:: if exist "%USERPROFILE%\Miniconda3\condabin\conda_hook.bat" call "%USERPROFILE%\Miniconda3\condabin\conda_hook.bat"

setlocal
set CONDA_BAT=Miniconda3\Scripts\activate.bat
if exist "%LOCALAPPDATA%\%CONDA_BAT%" set COND_BAT=%LOCALAPPDATA%\%CONDA_BAT%
if exist "%USERPROFILE%\%CONDA_BAT%" set COND_BAT=%USERPROFILE%\%CONDA_BAT%
if not exist "%COND_BAT%" goto :eof

call "%COND_BAT%" vim-python
