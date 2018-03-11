<#
.Synopsis
   Retrieves the data disks associated with a Azure RM VM
.EXAMPLE
   Get-AzureRMHelperResourceInfoFromID -id /subscriptions/ecaadcb5-b445-5453-9418-b5ed9429ce98/resourceGroups/azurermvm/providers/Microsoft.Network/networkInterfaces/azurermvm123
.INPUTS
    id - The id of the resource you want to retrieve the resource information from
.OUTPUTS 
    Returns an object with the following properies
    SubscriptionID - The subscription ID that the resource belongs to
    ResourceGroupName - Name of the resource group that the resource belongs to
    Resources - An array containing the names of the resources that are present in the ID
.FUNCTIONALITY
    Returns information about a resource from the ID
#>

Function Get-AzureRMHelperResourceInfoFromID
{
    Param(
            [Parameter(Mandatory=$True,ValueFromPipeline=$True)] 
            $ID
         )

    $idSplit = $id -split "/"
    $rmResourceDetail = [ordered] @{}
    $resources=@()
    for($i = 1;$i -lt $idSplit.Count;$i+=2)
    {   # Remove plurals from item names
        $itemName = $idSplit[$i] -replace "s$"
        $itemName = $itemName -replace "sse$","ss"

        if($itemName -eq "subscription"){$itemName = "subscriptionID"}
        if($itemName -eq "resourceGroup"){$itemName = "resourceGroupName"}

        if($i -gt 6)
        {
            $itemName = "$itemName`Name"
            $resources+=$itemName
        }

        $rmResourceDetail.Add($itemName,$idSplit[$i+1])
    }

    if($resources.Length -gt 0)
    {
       $rmResourceDetail.Add("resourceItem",$resources)
    }
    Return $rmResourceDetail
}