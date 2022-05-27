## This step creates the Resource Group for Azure PaaS using Azure PowerShell. We use Azure PowerShell as we need to run this from a Resource Group

$resourceGroupName = $OctopusParameters["Azure.ResourceGroup.Name"]
$resourceGroupLocation = $OctopusParameters["Azure.Location.Abbr"]

Try {
	Get-AzureRmResourceGroup -Name $resourceGroupName
    $createResourceGroup = $false
} Catch {
	$createResourceGroup = $true
}

if ($createResourceGroup -eq $true){
	New-AzureRmResourceGroup -Name $resourceGroupName -Location $resourceGroupLocation
}