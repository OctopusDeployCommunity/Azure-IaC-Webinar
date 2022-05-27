# Set secure protocols
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls11 -bor [System.Net.SecurityProtocolType]::Tls12

$spaceId = $OctopusParameters['Octopus.Space.Id']

# Get machine name
$targetName = $OctopusParameters["Azure.AppService.Name"]

# Get all machines
$deploymentTargets = (Invoke-RestMethod -Method Get -Uri "$($OctopusParameters['Global.Base.Url'])api/$spaceId/machines/all" -Headers @{"X-Octopus-ApiKey"="$($OctopusParameters['Global.Api.Key'])"}) | Where-Object {$_.Name -like "$targetName*"} 

# Loop through returned machines
foreach($deploymentTarget in $deploymentTargets)
{
    # Display what's being removed
    Write-Output "Removing $($deploymentTarget.Name)"
    
    # Remove the machine
    Invoke-RestMethod -Method Delete -Uri "$($OctopusParameters['Global.Base.Url'])api/$spaceId/machines/$($deploymentTarget.Id)" -Headers @{"X-Octopus-ApiKey"="$($OctopusParameters['Global.Api.Key'])"}
}
