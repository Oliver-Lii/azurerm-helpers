# Public IP Addresses

The following are the functions for working with Azure Public IP Addresses resources

### Get-AzureRMHelperVMPublicIPAddress
This cmdlet returns a [Microsoft.Azure.Commands.Network.Models.PSTopLevelResource] object associated with the VM.

The cmdlet accepts pipeline input of a PSVirtualMachine object.

```powershell
Get-AzureRMHelperVMPublicIPAddress -Name AzureRMVM -ResourceGroupName ResourceGroup

```

# Authors
- Oliver Li