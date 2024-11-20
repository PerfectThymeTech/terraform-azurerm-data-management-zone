# Define script arguments
[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [String]
    $Resource
)

$ErrorActionPreference = "Stop"

# Get access token
$accessToken = $(az account get-access-token --resource $Resource --query "accessToken" --output tsv)

# Create result
$res = @{
    'access_token' = $accessToken
    'authorization_header' = "Bearer $accessToken"
} | ConvertTo-Json

# Write $res output.
Write-Output $res
