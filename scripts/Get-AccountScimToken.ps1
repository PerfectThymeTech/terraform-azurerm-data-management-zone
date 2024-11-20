# Define script arguments
[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [String]
    $DatabricksAccountId,
    
    [Parameter(Mandatory = $true)]
    [String]
    $KeyVaultName,
    
    [Parameter(Mandatory = $false)]
    [String]
    $KeyVaultSecretName = "scim-token"
)

# Configuration
$ErrorActionPreference = "Stop"

# Get access token
$accessToken = $(az account get-access-token --resource $Resource --query "accessToken" --output tsv)

# Regenerate SCIM token
$url = "https://accounts.azuredatabricks.net/api/2.0/accounts/${DatabricksAccountId}/tokens/scim"
$headers = @{
    'Content-Type'  = 'application/json'
    'Authorization' = "Bearer ${accessToken}"
}
$body = @{} | ConvertTo-Json
$parameters = @{
    'Uri'         = $url
    'Method'      = 'Post'
    'Headers'     = $headers
    'Body'        = $body
    'ContentType' = 'application/json'
}
try {
    $response = Invoke-RestMethod @parameters
    $scimToken = $response.token_value
}
catch {
    Write-Error "REST API to get synchronisation template failed"
    throw "REST API call failed"
    exit 1
}

# Store SCIM token
$storeSecret = $(az keyvault secret set --name $KeyVaultSecretName --vault-name $KeyVaultName --value $scimToken --content-type "token" --output json)

# Create result
$res = @{
    'secret_name' = $secretName
    'success'     = $true
} | ConvertTo-Json

# Write $res output.
Write-Output $res
exit 0
