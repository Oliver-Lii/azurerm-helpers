<#
.Synopsis
   Retrieves information about a VHD from its URI
.EXAMPLE
   Get-AzureVhdInfoFromUri "https://azurermvmdisks.blob.core.windows.net/vhd/azurermvm-20180225-250218.vhd"
.INPUTS
    vhdURI - The URI for the VHD
.OUTPUTS 
    Object with the following properties
    Blob - Name of the vhd Blob
    Container - Container that the Blob resides in
    StorageAccountName - Storage Account that the Blob resides in
.FUNCTIONALITY
    Returns from a URI the name of the blob, container and storage account
   
#>

Function Get-AzureRMHelperVhdInfoFromUri
{
    Param(
        $vhdURI
    )
    $correctFormat = $vhdURI -match "(?<StorageAccountName>[0-9a-z]{3,24})\.blob\.core\.windows\.net\/(?<Container>[\w\-\/]{3,63})\/(?<Blob>[\w\-]{1,1024}.vhd)"

    if(!$correctFormat)
    {
        Return
    }

    $vhdDiskInfo = [ordered]@{
        Blob = $Matches.Blob
        Container = $Matches.Container
        StorageAccountName = $Matches.StorageAccountName
    }

    Return $vhdDiskInfo
}