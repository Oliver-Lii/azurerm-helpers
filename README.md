# AzureRM-Helpers [![Build status](https://ci.appveyor.com/api/projects/status/9m3gk7n9ywuj3do6/branch/master?svg=true)](https://ci.appveyor.com/project/Oliver-Lii/azurerm-Helpers/branch/master) [![GitHub license](https://img.shields.io/github/license/Oliver-Lii/AzureRM-Helpers.svg)](LICENSE) [![PowerShell Gallery](https://img.shields.io/powershellgallery/v/AzureRM-Helpers.svg)]()


This module was written to assist working with Azure Resource Manager Resources. Additional functionality may be added later and I will use this as a generic module to house Powershell functions specific to working with Azure Resource Manager Resources.

**DISCLAIMER:** Neither this module, nor its creator are in any way affiliated with Microsoft.


# Usage
This module can be installed from the PowerShell Gallery using the command below.
```powershell
Install-Module AzureRM-Helpers -Repository PSGallery
```

## Example

 The following illustrates how to remove a Azure Resource Manager VM and it's associated disks, network interfaces and public IP addresses.

```powershell
# Login to the Azure RM Account
Login-AzureRmAccount

# Select the subscription
Select-AzureRmSubscription -Subscription "Azure Subscription"

# Remove a Resource Manager VM using the VM and Resource Group name
Remove-AzureRMHelperVM -Name AzureRMVM -ResourceGroupName ResourceGroup -Verbose

# Remove a Resource Manager VM by piping a PSVirtualMachine object
$azureRMVirtualMachine = Get-azureRMVM -Name AzureRMVM -ResourceGroupName ResourceGroup
$azureRMVirtualMachine | Remove-AzureRMHelperVM
```

## Functions

Below is a list of the available functions in the module

[Disks](https://github.com/Oliver-Lii/azurerm-helpers/tree/master/AzureRM-Helpers/Public/Disks "StatusCake Alerts")
*  Get-AzureRMHelperVhdInfoFromUri
*  Get-AzureRMHelperVMDataDisks
*  Get-AzureRmVMOSDiskInfo

[NetworkInterfaces](https://github.com/Oliver-Lii/azurerm-helpers/tree/master/AzureRM-Helpers/Public/NetworkInterfaces "StatusCake Contact Groups")
*  Get-AzureRMHelperVMNicInfo

[PublicIPAddresses](https://github.com/Oliver-Lii/azurerm-helpers/tree/master/AzureRM-Helpers/Public/PublicIPAddresses "StatusCake Maintenance Windows")
*  Get-AzureRMHelperVMPublicIPAddress

[VM](https://github.com/Oliver-Lii/azurerm-helpers/tree/master/AzureRM-Helpers/Public/VM "StatusCake PageSpeed Tests")
*  Remove-AzureRMHelperVM


# Authors
- Oliver Li