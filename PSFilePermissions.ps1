function Set-Permission($StartingDir, $UserOrGroup = "", $InheritedFolderPermissions = "ContainerInherit, ObjectInherit", $AccessControlType = "Allow", $PropagationFlags = "None", $AclRightsToAssign) {
    ### The possible values for Rights are:
    # ListDirectory, ReadData, WriteData, CreateFiles, CreateDirectories, AppendData, Synchronize, FullControl
    # ReadExtendedAttributes, WriteExtendedAttributes, Traverse, ExecuteFile, DeleteSubdirectoriesAndFiles, ReadAttributes
    # WriteAttributes, Write, Delete, ReadPermissions, Read, ReadAndExecute, Modify, ChangePermissions, TakeOwnership

    ### Principal expected
    # domain\username

    ### Inherited folder permissions:
    # Object inherit    - This folder and files. (no inheritance to subfolders)
    # Container inherit - This folder and subfolders.
    # Inherit only      - The ACE does not apply to the current file/directory

    #define a new access rule.
    $acl = Get-Acl -Path $StartingDir
    $perm = $UserOrGroup, $AclRightsToAssign, $InheritedFolderPermissions, $PropagationFlags, $AccessControlType
    $rule = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList $perm
    $acl.SetAccessRule($rule)
    set-acl -Path $StartingDir $acl
}

function Set-Inheritance($StartingDir, $DisableInheritance = $false, $KeepInheritedAcl = $false) {
    $acl = get-acl -Path $StartingDir
    $acl.SetAccessRuleProtection($DisableInheritance, $KeepInheritedAcl)
    $acl | Set-Acl -Path $StartingDir
}

function Remove-Permission($StartingDir, $UserOrGroup = "", $All = $false) {
    $acl = get-acl -Path $StartingDir
    if ($UserOrGroup -ne "") {
        foreach ($access in $acl.Access) {
            if ($access.IdentityReference.Value -eq $UserOrGroup) {
                $acl.RemoveAccessRule($access) | Out-Null
            }
        }
    }
    if ($All -eq $true) {
        foreach ($access in $acl.Access) {
            $acl.RemoveAccessRule($access) | Out-Null
        }

    }
    Set-Acl -Path $folder.FullName -AclObject $acl
}