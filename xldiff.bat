@ECHO OFF
:: https://www.xltrail.com/blog/git-diff-spreadsheetcompare

:: Create paths to original and current spreadsheets to store in tmp
set path2=%5
:: Change forward slash to back slash on all paths for the Excel tool
set path2=%path2:/=\%
ECHO %2 > tmp.txt

dir %path2% /B /S >> tmp.txt

start "xldiff" /WAIT /B "C:\Program Files\Microsoft Office\root\client\AppVLP.exe" "C:\Program Files (x86)\Microsoft Office\Office16\DCF\SPREADSHEETCOMPARE.EXE" tmp.txt
pause
exit 0
