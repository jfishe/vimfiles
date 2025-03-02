@echo off
REM To run ~/.init.cmd for every cmd.exe.
REM reg add "HKCU\Software\Microsoft\Command Processor" /v AutoRun ^
REM   /t REG_EXPAND_SZ /d "%"USERPROFILE"%\.init.cmd" /f
REM To remove AutoRun:
REM reg delete "HKCU\Software\Microsoft\Command Processor" /v AutoRun

@IF DEFINED CONDA_SHLVL GOTO :EOF

@if exist "%USERPROFILE%\Miniforge3\condabin\conda_hook.bat" call "%USERPROFILE%\Miniforge3\condabin\conda_hook.bat"
@if exist "%LOCALAPPDATA%\Miniforge3\condabin\conda_hook.bat" call "%LOCALAPPDATA%\Miniforge3\condabin\conda_hook.bat"
@if exist "%CONDA_BAT%" call "%CONDA_BAT%" activate vim-python
