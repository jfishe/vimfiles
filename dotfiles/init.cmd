@echo off
REM To run ~/.init.cmd for every cmd.exe.
REM reg add "HKCU\Software\Microsoft\Command Processor" /v AutoRun ^
REM   /t REG_EXPAND_SZ /d "%"USERPROFILE"%\.init.cmd" /f
REM To remove AutoRun:
REM reg delete "HKCU\Software\Microsoft\Command Processor" /v AutoRun
:: if exist "%USERPROFILE%\Miniconda3\condabin\conda_hook.bat" call "%USERPROFILE%\Miniconda3\condabin\conda_hook.bat"
call "%USERPROFILE%\Miniconda3\Scripts\activate.bat" vim-python
