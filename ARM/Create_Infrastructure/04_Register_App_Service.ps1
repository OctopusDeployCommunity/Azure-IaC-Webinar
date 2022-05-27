# Force use of TLS 1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Define parameters
$baseUrl = $OctopusParameters['Global.Base.Url']
$apiKey = $OctopusParameters['Global.Api.Key']
$spaceId = $OctopusParameters['Octopus.Space.Id']
$spaceName = $OctopusParameters['Octopus.Space.Name']
$environmentName = $OctopusParameters['Octopus.Environment.Name']
$environmentId = $OctopusParameters['Octopus.Environment.Id']
$azureAccount = $OctopusParameters['Azure.Account.Name']
$name = $OctopusParameters['Azure.AppService.Name']
$resourceGroupName = $OctopusParameters['Azure.ResourceGroup.Name']

# Get default machine policy
$machinePolicy = (Invoke-RestMethod -Method Get -Uri "$baseUrl/api/$spaceId/machinepolicies/all" -Headers @{"X-Octopus-ApiKey"="$apiKey"}) | Where-Object {$_.Name -eq "Default Machine Policy"}

# Build JSON payload
$jsonPayload = @{
	Id = $null
    MachinePolicyId = $machinePolicy.Id
    Name = $name
    IsDisabled = $false
    HealthStatus = "Unknown"
    HasLatestCalamari = $true
    StatusSummary = $null
    IsInProcess = $true
    EndPoint = @{
    	Id = $null
        CommunicationStyle = "AzureWebApp"
        Links = $null
        AccountId = $azureAccount
        ResourceGroupName = $resourceGroupName
        WebAppName = $name
    }
    Links = $null
    TenantedDeploymentParticipation = "Untenanted"
    Roles = @(
    	"Azure-App-Service"
    )
    EnvironmentIds = @(
    	$environmentId
    )
    TenantIds = @()
    TenantTags = @()
}

# Register the target to Octopus Deploy
Invoke-RestMethod -Method Post -Uri "$baseUrl/api/$spaceId/machines" -Headers @{"X-Octopus-ApiKey"="$apiKey"} -Body ($jsonPayload | ConvertTo-Json -Depth 10)

