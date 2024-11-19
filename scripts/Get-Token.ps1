# Define script arguments
[CmdletBinding()]
param ()

$ErrorActionPreference = "Stop"

# Get access token
$accessToken = $(az account get-access-token --resource 2ff814a6-3304-4ab8-85cb-cd0e6f879c1d --query "accessToken" --output tsv)

# Create result
$res = @{
    'access_token' = $accessToken
    'authorization_header' = "Bearer $accessToken"
} | ConvertTo-Json

# Write $res output.
Write-Output $res
