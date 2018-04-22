Set-StrictMode -Version Latest
Clear-Host
$path = "F:\Shares\PersonalTesting"

$IncludeLibrary = "$PSScriptRoot\PSFilePermissions.ps1" # where is the file
.$IncludeLibrary # dot source library


function FindAndFixFolders() {
    $folders = Get-ChildItem -Path $path -Directory | Select-Object Name, FullName
    foreach ($folder in $folders) {
        Set-Inheritance $folder.FullName -DisableInheritance $true -KeepInheritedAcl $false
        #Remove-Permission $folder.FullName -UserOrGroup "Domain\srv.pklys"
        #Remove-Permission $folder.FullName -All $true
        Set-Permission $folder.FullName -UserOrGroup "Domain\$($folder.Name)" -AclRightsToAssign "ReadAndExecute"
        Set-Permission $folder.FullName -UserOrGroup "Domain\Domain Admins" -AclRightsToAssign "FullControl"
        Set-Permission $folder.FullName -UserOrGroup "BUILTIN\Administrators" -AclRightsToAssign "FullControl"
        Set-Permission $folder.FullName -UserOrGroup "BUILTIN\Administrators" -AclRightsToAssign "FullControl"
        Set-Permission $folder.FullName -UserOrGroup "SYSTEM" -AclRightsToAssign "FullControl"
        Set-Permission $folder.FullName -UserOrGroup "Domain\domain.pklys" -AclRightsToAssign "FullControl"
        Remove-Permission $folder.FullName -UserOrGroup "BUILTIN\Users"
    }
}
