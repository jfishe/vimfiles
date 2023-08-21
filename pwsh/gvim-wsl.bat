@echo off

REM ### Start X410 in Windowed Apps Mode. If X410 is already running in Desktop Mode,
REM ### it'll be terminated first without any warning message box.
REM https://x410.dev/cookbook/wsl/pin-linux-gui-app-to-start-or-taskbar/

:: start /B x410.exe /wm

REM ### Start WSL default distro gvim

:: ubuntu2004.exe run "bash --login -c 'nohup octave --gui >/dev/null 2>&1 & sleep 1'"
C:\Windows\System32\wsl.exe bash -l -c "setsid gvim"
