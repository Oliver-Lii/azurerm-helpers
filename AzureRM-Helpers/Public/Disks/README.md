# Disks

The following are the functions for working with Azure Disk resources

### Get-AzureRMHelperVhdInfoFromUri
This cmdlet returns the Blob, Container and Storage account name from a vhd URI.

```powershell
Get-AzureRMHelperVhdInfoFromUri "https://azurermvmdisks.blob.core.windows.net/vhd/azurermvm-20180225-250218.vhd"

Name                           Value                                                                                                                                                                                                                                               
----                           -----                                                                                                                                                            
Blob                           azurermvm-20180225-250218.vhd                     
Container                      vhd   
StorageAccountName             azurermvmdisks
```

### Get-AzureRMHelperVMDataDisks
This cmdlet returns the data disks for a ARM VM. The disk type is determined by type of disk attached as the OS disk. For managed disks a [Microsoft.Azure.Commands.Compute.Automation.Models.PSDisk] object is returned. The data disks are retrieved by finding disks which are managed by the VM's ID and excluding the OS disk. 

For unmanaged disks a [Microsoft.WindowsAzure.Commands.Common.Storage.ResourceModel.AzureStorageBase] object is returned. A search is done across all storage accounts for VHD files which match the ones attached to the VM.

The cmdlet accepts pipeline input of a PSVirtualMachine object.

```powershell
Get-AzureRMHelperVMDataDisks -Name AzureRMVM -ResourceGroupName ResourceGroup
```

### Get-AzureRmVMOSDiskInfo
This cmdlet returns information about the OS Disk for a ARM VM. The information is gathered using a regex of the OS disk ID. 

The cmdlet accepts pipeline input of a PSVirtualMachine object.

```powershell
Get-AzureRmVMOSDiskInfo -Name AzureRMVM -ResourceGroupName ResourceGroup

#For managed OS disks, the following is returned
Name                           Value                                                                                                                                                            ----                           -----                                                                                                                                                            Name                           azurermvm_OsDisk_1_713bf13751a95946bb44c1bc2e86496b                                                                                                             ResourceGroupName              resourcegroup                                                                                                                                                    SubscriptionID                 ecaadcb5-b445-5453-9418-b5ed9429ce98                                                                                                                            DiskType                       ManagedDisk

#For unmanaged OS disks the following is returned
Name                           Value                                                                                                                                                                                                                                               
----                           -----                                                                                                                                                            Blob                           azurermvm-20180225-250218.vhd                                                                                                                                  Container                      vhd                                                                                                                                                             StorageAccountName             azurermvmdisks                                                                                                                                                DiskType                       Vhd
```


# Authors
- Oliver Li