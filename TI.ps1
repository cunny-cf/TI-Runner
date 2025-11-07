if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
    Write-Host "Requesting administrative privileges..."
    Start-Process -FilePath "powershell.exe" -Verb RunAs -ArgumentList ('-ExecutionPolicy Bypass -File "{0}"' -f $MyInvocation.MyCommand.Path) -WindowStyle Minimized
    Write-Host "Trying to run as TrustedInstaller"
    exit
}
Install-Module "NtObjectManager" -Scope CurrentUser -Force
Import-Module NtObjectManager
Start-Service -Name TrustedInstaller
$parent = Get-NtProcess -ServiceName TrustedInstaller
New-Win32Process -CommandLine 'cmd.exe /k "prompt TrustedInstaller$G & cls & whoami"' -CreationFlags NewConsole -ParentProcess $parent
exit
