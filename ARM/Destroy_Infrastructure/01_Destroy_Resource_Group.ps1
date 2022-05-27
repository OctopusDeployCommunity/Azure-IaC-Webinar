$resourceGroup = $OctopusParameters["Azure.ResourceGroup.Name"]

$groupExists = az group exists --name $resourceGroup
if($groupExists -eq $true) {
	Write-Host "Deleting Resource Group: $resourceGroup"
    az group delete --name $resourceGroup --yes 
	Write-Highlight "Deleted Resource Group: $resourceGroup"
}
else {
	Write-Highlight "Resource Group: $resourceGroup doesnt exist."
}