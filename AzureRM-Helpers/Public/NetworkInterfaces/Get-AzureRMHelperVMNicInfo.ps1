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
    Returns an object with the following properies
    Name - Name of the network interface
    ResourceGroupName - Name of the resource group that the resource belongs to
    SubscriptionID - The subscription ID that the resources belongs to
.FUNCTIONALITY
    Returns information about the network interfaces that are part of the AzureRM VM
   
#>

Function Get-AzureRMHelperVMNicInfo
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

    $nicCollection = @()
    foreach($nic in $azureRMVM.NetworkProfile.NetworkInterfaces.id)
    {
        $correctFormat = $nic -match "^\/subscriptions\/(?<SubID>[\w\-]*)\/resourceGroups\/(?<rgName>[\w-\.\(\)]*)\/providers\/Microsoft.Network\/networkInterfaces\/(?<name>[\w-\.]*)"

        if(!$correctFormat)
        {
            throw "Invalid NIC ID Format [$nic]"
        }
        $networkInterfaceDetail = [ordered]@{
            Name = $matches.name
            ResourceGroupName = $matches.rgname
            SubscriptionID = $matches.subID
        }

        $nicCollection += $networkInterfaceDetail
    }
    Return $nicCollection
}