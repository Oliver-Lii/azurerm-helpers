<#
.Synopsis
   Removes a AzureRM VM
.EXAMPLE
   Remove-AzureRMHelperVM -Name "AzureRMVM" -ResourceGroupName "AzureRMVMResourceGRoup"
.INPUTS
    Name - Name of the VM
    ResourceGroupName - Name of the resource group the VM belongs to
.OUTPUTS 
    Returns true or false depending on if the VM has been successfully removed
.FUNCTIONALITY
    Removes a stopped AzureRM Virtual Machine and its associated disks, network interfaces and public IP addresses
#>

Function Remove-AzureRMHelperVM
{
    [CmdletBinding(SupportsShouldProcess=$true)]
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

    $azureRMVMState = Get-azureRMVM -Name $Name -ResourceGroupName $ResourceGroupName -Status
    $azureRMVMState.Statuses | Where-object {$_.Code -match "^PowerState\/(?<Status>\w*)$"} | Out-Null
    if($Matches.Status -ne "deallocated")
    {
        Write-error "VM [$Name] needs to be in a stopped state before it can be removed"
        return
    }

    try {

        if(!$azureRMVM)
        {
            Write-Verbose "Retrieving details for VM [$Name]"
            #Retrieve the details of the VM
            $azureRMVM = Get-azureRMVM -Name $Name -ResourceGroupName $ResourceGroupName
        } 
    
        Write-Verbose "Retrieving disk information"
        #Retrieve the details of the disks the VM uses
        $vmOSDiskDetails = Get-AzureRmHelperVMOSDiskInfo $azureRMVM
        $azureRMVMDisks = Get-AzureRMHelperVMDataDisks $azureRMVM
    
        Write-Verbose "Retrieving network interface information"
        #Retrieve the details of the network interfaces the VM uses
        $vmNetworkInterfaceDetails = Get-AzureRMHelperVMNicInfo $azureRMVM
    
        Write-Verbose "Retrieving assigned public IP addresses"    
        #Retrieve the details of the public IPs the VM uses
        $nicPublicIPs = Get-AzureRMHelperVMPublicIPAddress $azureRMVM
          
    }
    catch {
        Write-Error $error[0]
        Return $false
    }

    try{
        #Remove VM
        Write-Verbose "Removing VM [$name]"
        $result = Remove-AzureRmVM -Name $Name -ResourceGroupName $ResourceGroupName -Force  

        #Remove network interfaces used by VM
        foreach($networkInterface in $vmNetworkInterfaceDetails)
        {
            Write-Verbose "Removing network interface [$($networkInterface.Name)] for VM [$name]"
            Remove-AzureRmNetworkInterface -Name $networkInterface.Name -ResourceGroupName $networkInterface.ResourceGroupName -Force
        }

        #Remove the public IPs used by the network interface
        foreach($publicIP in $nicPublicIPs)
        {
            Write-Verbose "Removing public IP [$($publicIP.Name)] for VM [$($name)]"
            Remove-AzureRmPublicIpAddress -Name $publicIP.Name -ResourceGroupName $publicIP.ResourceGroupName -Force
        }

        #Remove Disks used by VM
        If($vmOSDiskDetails.DiskType -eq "ManagedDisk")
        {
            Write-Verbose "Removing OS Managed Disk attached to VM [$($vmOSDiskDetails.Name)] in resource group [$($vmOSDiskDetails.ResourceGroupName)]"
            $Result = Remove-AzureRmDisk -DiskName $vmOSDiskDetails.Name -ResourceGroupName $vmOSDiskDetails.ResourceGroupName -Force
            foreach($managedDisk in $azureRMVMDisks)
            {
            Write-Verbose "Removing Managed Data Disks attached to VM [$($managedDisk.Name)] in resource group [$($managedDisk.ResourceGroupName)]"
                $Result = Remove-AzureRmDisk -DiskName $managedDisk.Name -ResourceGroupName $managedDisk.ResourceGroupName -Force
            } 
        }
        else
        {
            $storageAccounts = Get-AzureRmStorageAccount
            $resourceGroupName = ($storageAccounts | Where-Object {$_.StorageAccountName -eq $vmOSDiskDetails.StorageAccountName}).ResourceGroupName
            Set-AzureRmCurrentStorageAccount -Name $vmOSDiskDetails.StorageAccountName -ResourceGroupName $resourceGroupName | Out-Null
            Write-Verbose "Removing Vhd OS Disk [$($vmOSDiskDetails.Blob)] in container [$($vmOSDiskDetails.Container)] in storage account [$($vmOSDiskDetails.StorageAccountName)]"
            Remove-AzureStorageBlob -Blob $vmOSDiskDetails.Blob -Container $vmOSDiskDetails.Container

            $rmVMDisks = $azureRMVMDisks | Where-Object {$_.ICloudBlob.Properties.LeaseStatus -eq "Unlocked"}
            foreach($vhd in $rmVMDisks)
            {
                $vhdStorageAccountName = (Get-AzureVhdDetailFromUri $vhd.ICloudBlob.StorageUri.PrimaryUri).StorageAccountName
                Set-AzureRmCurrentStorageAccount -context $vhd.Context | Out-Null
                Write-Verbose "Removing Vhd Data Disk [$($vhd.Name)] in container [$($vhd.ICloudBlob.Container.Name)] in storage account [$($vhdStorageAccountName)]"
                Remove-AzureStorageBlob -CloudBlob $vhd.ICloudBlob
            }
        }
    }
    catch{
        Write-Error $error[0]
        Return $false
    }
    Return $true
}
