' https://x410.dev/cookbook/wsl/pin-linux-gui-app-to-start-or-taskbar/
If WScript.Arguments.Count <= 0 Then
    WScript.Quit
End If

cmd = Left(WScript.ScriptFullName, InStrRev(WScript.ScriptFullName, "\")) & WScript.Arguments(0) & ".cmd"
arg = ""

If WScript.Arguments.Count > 1 Then
    arg = WScript.Arguments(1)
End If

CreateObject("WScript.Shell").Run """" & cmd & """ """ & arg & """", 0, False

