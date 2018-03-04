<#
.Synopsis
   Retrieves the data disks associated with a Azure RM VM
.EXAMPLE
   Get-AzureRMHelperVMOSDiskInfo-azureRMVM $azureRMVMObject
.INPUTS
    azureRMVM - Azure RM VM object
    Name - Name of the VM
    ResourceGroupName - Name of the resource group the VM belongs to
.OUTPUTS 
    For managed disks an object with the following properties
    Name - Name of the disk
    ResourceGroupName - Name of the Resource Group the resource belongs to
    DiskType - The type of disk this is. "ManagedDisk" or "Vhd"

    For unmanaged disks an object with the following properties
    Blob - Name of the vhd Blob
    Container - Container that the Blob resides in
    StorageAccountName - Storage Account that the Blob resides in
    DiskType - The type of disk this is. "Vhd"
.FUNCTIONALITY
    Returns information about the OS disks for a AzureRM VM. Disk information returned is dependent on the disk type of the OS Disk.
   
#>
Function Get-AzureRmHelperVMOSDiskInfo
{
    [CmdletBinding()]
    Param(
        [Parameter(ParameterSetName='VMObject',ValueFromPipeline=$True,Position=0)] 
        [Microsoft.Azure.Commands.Compute.Models.PSVirtualMachine]$azureRMVM,
        [Parameter(ParameterSetName='RMVMName',Mandatory=$true,Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,
        [Parameter(ParameterSetName='RMVMName',Mandatory=$true,Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceGroupName
    )

    if(!$azureRMVM)
    {
        $azureRMVM = Get-azureRMVM -Name $Name -ResourceGroupName $ResourceGroupName
    }

    if($azureRMVM.StorageProfile.OsDisk.ManagedDisk.Id)
    {   #Get the name of the disk and resource group the disk belongs to from the ID
        $correctFormat = $azureRMVM.StorageProfile.OsDisk.ManagedDisk.Id -match "^\/subscriptions\/(?<SubID>[\w\-]*)\/resourceGroups/(?<rgName>[\w]*)/providers/Microsoft.Compute/disks\/(?<name>[\w]*)$"
        if(!$correctFormat)
        {
            throw "Invalid OS Disk ID Structure [$($azureRMVM.StorageProfile.OsDisk.ManagedDisk.Id)]"
        }
        $osDiskInfo = [ordered]@{
            Name = $Matches.Name
            ResourceGroupName = $Matches.rgname
            SubscriptionID = $Matches.SubID
            DiskType = "ManagedDisk"
        }
    }
    else
    {   #Get the vhd blob, container and storage account name from the URI
        $osDiskInfo = Get-AzureRMHelperVhdInfoFromUri $azureRMVM.StorageProfile.OsDisk.Vhd.Uri
        $osDiskInfo.Add("DiskType","Vhd")
    }

    Return $osDiskInfo
}