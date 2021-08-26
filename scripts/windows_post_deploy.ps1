$disks = Get-Disk | Where partitionstyle -eq 'raw' | sort number
$projectshares = "SES_UMM_PROJECT1", "DOD_MAYO_PROJECT2"
$commonshares = "UMM", "MAYO"


$letters = 70..89 | ForEach-Object { [char]$_ }
$count = 0
$labels = "data1","data2"

foreach ($disk in $disks) {
        $driveLetter = $letters[$count].ToString()
        $disk |
        Initialize-Disk -PartitionStyle MBR -PassThru |
        New-Partition -UseMaximumSize -DriveLetter $driveLetter |
        Format-Volume -FileSystem NTFS -NewFileSystemLabel $labels[$count] -Confirm:$false -Force
	$count++
}



foreach ($projectshare in $projectshares) {
       
       $folderPath = "F:\" + "$projectshare";
   
       if (!(Test-Path $folderPath)) {
        $identity1 = "$env:COMPUTERNAME" + "\AD_PHX_" + "$projectshare" + "_OWNER"
        $identity2 = "$env:COMPUTERNAME" + "\AD_PHX_" + "$projectshare" + "_USERS"
        
        New-Item -Name $projectshare -ItemType directory -Path F:\
        New-SmbShare -Name $projectshare -Path $folderPath
        Grant-SmbShareAccess -Name $projectshare -AccountName $identity1 -AccessRight Change -Force
        Grant-SmbShareAccess -Name $projectshare -AccountName $identity2 -AccessRight Read -Force

        $rights1 = 'Read, Write'
        $rights2 = 'Read'
        $inheritance = 'ContainerInherit, ObjectInherit'
        $propagation = 'None'
        $type = 'Allow'
        $ACE1 = New-Object System.Security.AccessControl.FileSystemAccessRule($identity1,$rights1,$inheritance,$propagation,$type)
        
        $ACE2 = New-Object System.Security.AccessControl.FileSystemAccessRule($identity2,$rights2,$inheritance,$propagation,$type)
        
        $Acl = Get-Acl -Path $folderPath
    
        $Acl.AddAccessRule($ACE1)
        $Acl.AddAccessRule($ACE2)
    
        Set-Acl -Path $folderPath -AclObject $Acl
    }    
        
} 

foreach ($commonshare in $commonshares) {
       
    $folderPath = "F:\" + "$commonshare";

    if (!(Test-Path $folderPath)) {
     $identity1 = "windowsvm121\AD_PHX_" + "$commonshare" + "_OWNER"
     $identity2 = "windowsvm121\AD_PHX_" + "$commonshare" + "_USERS"
     
     New-Item -Name $commonshare -ItemType directory -Path F:\
     New-SmbShare -Name $commonshare -Path $folderPath
     Grant-SmbShareAccess -Name $commonshare -AccountName $identity1 -AccessRight Change -Force
     Grant-SmbShareAccess -Name $commonshare -AccountName $identity2 -AccessRight Read -Force

     $rights1 = 'Read, Write'
     $rights2 = 'Read'
     $inheritance = 'ContainerInherit, ObjectInherit'
     $propagation = 'None'
     $type = 'Allow'
     $ACE1 = New-Object System.Security.AccessControl.FileSystemAccessRule($identity1,$rights1,$inheritance,$propagation,$type)
     
     $ACE2 = New-Object System.Security.AccessControl.FileSystemAccessRule($identity2,$rights2,$inheritance,$propagation,$type)
     
     $Acl = Get-Acl -Path $folderPath
 
     $Acl.AddAccessRule($ACE1)
     $Acl.AddAccessRule($ACE2)
 
     Set-Acl -Path $folderPath -AclObject $Acl
 }    
     
} 
    




<# function Install-sharing(){
    $folderPath = 'F:\\ProjectShare';
    if (!(Test-Path $folderPath)) {
        New-Item -Path 'F:\\' -Name 'ProjectShare' -ItemType 'directory';
        New-SmbShare -Name 'ProjectShare' -Path 'F:\ProjectShare';
        Grant-SmbShareAccess -Name 'ProjectShare' -AccountName 'BUILTIN\Users' -AccessRight Change -Force;
        $permission1 = 'BUILTIN\Users', 'Read, Write', 'ContainerInherit, ObjectInherit', 'None', 'Allow';
        $acl = Get-Acl $folderPath;
        $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule -ArgumentList $permission1;
        $acl.SetAccessRule($AccessRule);
        $acl | Set-Acl $folderPath;
    }
}

Install-sharing; #>

<# New-Item -Path "c:\" -Name "test_logfiles" -ItemType "directory" #>


<# $projectshares = "ses_umm_project1", "dod_mayo_project2"

foreach ($projectshare in $projectshares) {
   $folderPath = "F:\" + "$projectshare";

    Write-Output ($folderPath)
    
    New-Item -Name $projectshare -ItemType directory -Path F:\
    New-SmbShare -Name $projectshare -Path $folderPath     
    
     
    }  #>
