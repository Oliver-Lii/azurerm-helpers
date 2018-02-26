<#
.Synopsis
   Retrieves the data disks associated with a Azure RM VM
.EXAMPLE
   Get-AzureRMHelperVMDataDisks -azureRMVM $azureRMVMObject
.INPUTS
    azureRMVM - Azure RM VM object
    Name - Name of the VM
    ResourceGroupName - Name of the resource group the VM belongs to
.OUTPUTS 
    For unmanaged disks
    [Microsoft.WindowsAzure.Commands.Common.Storage.ResourceModel.AzureStorageBase]
    For managed disks
    [Microsoft.Azure.Commands.Compute.Automation.Models.PSDisk]
.FUNCTIONALITY
    Retrieves the data disks for a AzureRM VM. Disk type returned is dependent on the disk type of the OS Disk.
   
#>

Function Get-AzureRMHelperVMDataDisks
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

    $rmVMDataDiskDetails = @()
    if($azureRMVM.StorageProfile.OsDisk.ManagedDisk.Id)
    {
        $allRMDataDisks = Get-AzureRmDisk
        #Find associated Managed Data Disks
        $rmVMDataDiskDetails = $allRMDataDisks | Where-object {$_.ManagedBy -match $azureRMVM.Id -and $_.Id -notmatch $azureRMVM.StorageProfile.OsDisk.ManagedDisk.Id}
    }
    else
    {   #Find associated Unmanaged Data Disks
        $storageAccounts = Get-AzureRmStorageAccount
        foreach($vhd in $azureRMVM.StorageProfile.DataDisks)
        {
            $vhdBlob = $storageAccounts | Get-AzureStorageContainer | Get-AzureStorageBlob | Where-Object {$_.Name -match "$($vhd.Name)\.vhd"}
            $rmVMDataDiskDetails += $vhdBlob
            if($vhdBlob.GetType() -eq 'Object[]')
            {
                Write-warning "Found more than one vhd for $($vhd.Name) across all storage accounts"
            }
        }
        #Check if the number of VHDs found matches the number of disks attached to the VM
        if($azureRMVM.StorageProfile.DataDisks.Count -ne $rmVMDataDiskDetails.Count)
        {
            Throw "Number of Vhds matching blob name exceeds number of disks attached to VM"
        }
    }
    Return $rmVMDataDiskDetails
}