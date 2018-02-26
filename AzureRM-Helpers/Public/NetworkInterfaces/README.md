# Network Interfaces

The following are the functions for working with Azure Network Interface resources

### Get-AzureRMHelperVMNicInfo
This cmdlet returns the Network Interface name, resource group and subscription ID from the network interface ID of the VM.

The cmdlet accepts pipeline input of a PSVirtualMachine object.

```powershell
Get-AzureRMHelperVMNicInfo -Name AzureRMVM -ResourceGroupName ResourceGroup

Name                           Value                                                                                                                                                                                                                                               
----                           -----                                                                                                                                                            Name                           azurermvm841                                                                                                                                                 ResourceGroupName              resourcegroup                                                                                                                                                    SubscriptionID                 ecaadcb5-b445-5453-9418-b5ed9429ce98
```

# Authors
- Oliver Li