<#
.Synopsis
   Retrieves the Public IPs associated with a AzureRM VM
.EXAMPLE
   Get-AzureRMHelperVMPublicIP -azureRMVM $azureRMVMObject
.INPUTS
    azureRMVM - Azure RM VM object
    Name - Name of the VM
    ResourceGroupName - Name of the resource group the VM belongs to
.OUTPUTS 
    [Microsoft.Azure.Commands.Network.Models.PSTopLevelResource]
.FUNCTIONALITY
    Retrieves the public IPs for a AzureRM VM by matching the NIC ID against the available public IPs in the account
   
#>

Function Get-AzureRMHelperVMPublicIPAddress
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

    $publicIPList = Get-AzureRmPublicIpAddress

    #Find the matching Public IP for the network interface by looking for a Ip Configuration ID containing the network interface name
    $publicIPList = $publicIPList | Where-object {$_.IpConfiguration.Id -match "$($azureRMVM.networkprofile.NetworkInterfaces.Id).*"}
    Return $publicIPList
}