# ID

The following are the functions for working with Azure IDs

### Get-AzureRMHelperResourceInfoFromID
This cmdlet returns a hashtable containing the details of the resource from the resource ID

The cmdlet accepts pipeline input of the ID.

```powershell
Get-AzureRMHelperResourceInfoFromID -id /subscriptions/ecaadcb5-b445-5453-9418-b5ed9429ce98/resourceGroups/azurermvm/providers/Microsoft.Network/networkInterfaces/azurermvm123

Name                           Value                                                                                                                                                                                                                                               
----                           -----
subscriptionID                 ecaadcb5-b445-5453-9418-b5ed9429ce98                
resourceGroupName              azurermvm                                          
provider                       Microsoft.Network                                   
networkInterfaceName           azurermvm123                                       
resourceItem                   {networkInterfaceName}
```

# Authors
- Oliver Li