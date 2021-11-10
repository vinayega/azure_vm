#D:\NHI
#D:\NHI\folder1
#D:\NHI\folder11
#D:\NHI\folder11\folder111

#$rootfolder = 'NHI'
#$subfolders = 'folder1','folder2'
#$subfolder_folder1 = 'folder11','folder12','folder13'
#$subfolder_folder2 = 'folder21','folder22'
#$subfolder_folder21 = 'folder211','folder212','folder213'


$folders = 'NHI-Ls_data_tools','NHI-lifescience','NHI-lifescience-ls_common_share','NHI-LS_data_tools-cmm','NHI-LS_data_tools-cmm-cmm_ro','NHI-lifescience-lsrd_eor','NHI-LS_data_tools-cdm','NHI-Ls_data_tools-lsdat_common_share','NHI-LS_data_tools-cmm-cmm_rw'
$wvd_admin = 'windowsvm121\azu_phx_wvd_admin'
$adGroup_ls_dev = 'windowsvm121\azu_phx_sas_ls_dev'



function foldercreation
{
    param($folders)

    foreach ($folder in $folders) { 
    $folderarray = $folder.Split('-') 
    Write-Host $folderarray.length
    $tempdtr = 'D:'
    $tempdtr2 = 'D:'
    $nhi_path = 'D:\NHI'

    if(!(Test-Path $nhi_path)){
        New-Item -Name 'NHI' -ItemType Directory -Path 'D:\'
        New-SmbShare -Name 'NHI' -Path $nhi_path
        
        $permissions01 = "ReadAndExecute"
        $permissions02 = 'FullControl'
        $accountname = "windowsvm121\azu_phx_access_ws_users_nhi_proj1_dev"

        updateAcl $nhi_path $accountname $permissions01
        updateAcl $nhi_path $wvd_admin $permissions02
        

      }
    foreach ($dtr in $folderarray[0..($folderarray.length-1)]){

        if ($dtr -eq $folderarray[$folderarray.length - 1]){
        $tempdtr2 = $tempdtr2 + '\' + $dtr
        }
        else{
         $tempdtr = $tempdtr + '\' + $dtr
         $tempdtr2 = $tempdtr2 + '\' + $dtr
         }    
    }

    Write-Host ('$tempdtr2 is: ')
    Write-Host $tempdtr2

    if (!(Test-Path $tempdtr2)) {
        New-Item -Name $folderarray[-1] -ItemType Directory -Path $tempdtr
        New-SmbShare -Name $folderarray[-1] -Path $tempdtr2
    }else{}

    if ($folderarray -contains 'lifescience'){
    
    if($folderarray[-1] -eq 'lifescience'){
        $permissions01 = "ReadAndExecute"
        $permissions02 = 'FullControl'
        updateAcl $tempdtr2 $adGroup_ls_dev $permissions01
        updateAcl $tempdtr2 $wvd_admin $permissions02

    }
    elseif($folderarray[-1] -eq 'ls_common_share'){
        $permissions01 = "ReadAndExecute"
        $permissions02 = 'FullControl'
        $permissions03 = 'ReadAndExecute','Modify'
        $ad_Group_commonShare = 'windowsvm121\azu_phx_sas_ls_common_share_data'

        updateAcl $tempdtr2 $adGroup_ls_dev $permissions01
        updateAcl $tempdtr2 $wvd_admin $permissions02
        updateAcl $tempdtr2 $ad_Group_commonShare $permissions03

    }
    else{
        $permissions02 = 'FullControl'
        $permissions01 = 'ReadAndExecute','Modify'
        $temp_split = $folderarray[-1].Split('_')
        $ad_Group_otherfolder = 'windowsvm121\azu_phx_sas_ls_' + $temp_split[-1] + '_data'
        
        updateAcl $tempdtr2 $wvd_admin $permissions02
        updateAcl $tempdtr2 $ad_Group_otherfolder $permissions01

    }

    }
    elseif ($folderarray -contains 'LS_data_tools') {
    Write-Host $folderarray
    $temp_split = $folderarray[-1].Split('_')
    if(($temp_split[-1] -eq 'ro') -or ($temp_split[-1] -eq 'rw')){

    if($temp_split[-1] -eq 'ro'){
        $permissions01 = "ReadAndExecute"
        $permissions02 = 'FullControl'
        $permissions03 = 'ReadAndExecute','Modify'
        $ad_Group = 'windowsvm121\azu_phx_sas_lsdat_' + $folderarray[-1] + '_data'
        $ad_Group_parentGroup = 'windowsvm121\azu_phx_sas_lsdat_' + $temp_split[-2] + '_data'

        Write-Host ('AD group name is:')
        Write-Host $ad_Group
        Write-Host $adGroup_parentGroup

        updateAcl $tempdtr2 $ad_Group_parentGroup $permissions01
        updateAcl $tempdtr2 $wvd_admin $permissions02
        updateAcl $tempdtr2 $ad_Group $permissions03

    }
    else{
        $permissions01 = 'ReadAndExecute','Modify'
        $permissions02 = 'FullControl'
        #$ad_Group = 'windowsvm121\azu_phx_sas_lsdat_' + $folderarray[-1] + '_data'
        $ad_Group_parentGroup = 'windowsvm121\azu_phx_sas_lsdat_' + $temp_split[-2] + '_data'
        #Write-Host $ad_Group
        Write-Host ('AD group name is:')
        Write-Host $ad_Group_parentGroup
        updateAcl $tempdtr2 $ad_Group_parentGroup $permissions01
        updateAcl $tempdtr2 $wvd_admin $permissions02
        #updateAcl $tempdtr2 $ad_Group $permissions03

    }    
    }

    else{

    if($folderarray[-1] -eq 'Ls_data_tools'){
        $permissions01 = "ReadAndExecute"
        $permissions02 = 'FullControl'
        updateAcl $tempdtr2 $adGroup_ls_dev $permissions01
        updateAcl $tempdtr2 $wvd_admin $permissions02

    }
    elseif($folderarray[-1] -eq 'lsdat_common_share'){
        $permissions01 = "ReadAndExecute"
        $permissions02 = 'FullControl'
        $permissions03 = 'ReadAndExecute','Modify'
        $ad_Group_commonShare = 'windowsvm121\azu_phx_sas_lsdat_common_share_data'

        updateAcl $tempdtr2 $adGroup_ls_dev $permissions01
        updateAcl $tempdtr2 $wvd_admin $permissions02
        updateAcl $tempdtr2 $ad_Group_commonShare $permissions03

    }
    else{
        $permissions02 = 'FullControl'
        $permissions01 = 'ReadAndExecute','Modify'
        $temp_split = $folderarray[-1]
        $ad_Group_otherfolder = 'windowsvm121\azu_phx_sas_lsdat_' + $temp_split + '_data'
        Write-Host ('AD group name is:')
        Write-Host $ad_Group_otherfolder
        updateAcl $tempdtr2 $wvd_admin $permissions02
        updateAcl $tempdtr2 $ad_Group_otherfolder $permissions01
    }

    }
    }

    else {
    Write-Host $folderarray
    }

    } 

    #New-Item -name 'folder111' -ItemType Directory -Path $path
    
}


function updateAcl {

    param($folderpath,$adGroupname,$permissions)
    Write-Host ("I'm in updateAcl function ")
    $nhiacl = Get-Acl -Path $folderpath
    $nhiace = New-Object Security.AccessControl.FileSystemAccessRule ($adGroupname,$permissions,'None','None','Allow')
    $nhiacl.AddAccessRule($nhiace)
    Set-Acl -AclObject $nhiacl -Path $folderpath

}

foldercreation $folders