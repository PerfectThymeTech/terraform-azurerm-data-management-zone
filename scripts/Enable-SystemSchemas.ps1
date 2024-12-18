# Define script arguments
[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [String]
    $DatabricksWorkspaceUrl
)

# Configuration
$ErrorActionPreference = "Stop"

# Get access token
$accessToken = $(az account get-access-token --resource "2ff814a6-3304-4ab8-85cb-cd0e6f879c1d" --query "accessToken" --output tsv)

# Get metastore for current workspace
$url = "https://${DatabricksWorkspaceUrl}/api/2.1/unity-catalog/current-metastore-assignment"
$headers = @{
    'Content-Type'  = 'application/json'
    'Authorization' = "Bearer ${accessToken}"
}
$parameters = @{
    'Uri'         = $url
    'Method'      = 'Get'
    'Headers'     = $headers
    'ContentType' = 'application/json'
}
try {
    $responseGetMetastoreAssignment = Invoke-RestMethod @parameters
    $currentMetastoreId = $responseGetMetastoreAssignment.metastore_id
}
catch {
    $message = "REST API call to get metastore assignment failed"
    Write-Error $message
    throw $message
    exit 1
}


# Get system schemas
$url = "https://${DatabricksWorkspaceUrl}/api/2.1/unity-catalog/metastores/${currentMetastoreId}/systemschemas"
$headers = @{
    'Content-Type'  = 'application/json'
    'Authorization' = "Bearer ${accessToken}"
}
$parameters = @{
    'Uri'         = $url
    'Method'      = 'Get'
    'Headers'     = $headers
    'ContentType' = 'application/json'
}
try {
    $responseGetSystemSchemas = Invoke-RestMethod @parameters
    $schemas = $responseGetSystemSchemas.schemas | ConvertTo-Json
    Write-Host $schemas
}
catch {
    $message = "REST API call to get system schemas failed"
    Write-Error $message
    throw $message
    exit 1
}

# Enable system schemas
foreach ($systemSchema in $responseGetSystemSchemas.schemas) {
    if ($systemSchema.state -eq "AVAILABLE") {
        # Enable system schema
        $url = "https://${DatabricksWorkspaceUrl}/api/2.1/unity-catalog/metastores/${currentMetastoreId}/systemschemas/${systemSchema.schema}"
        $headers = @{
            'Content-Type'  = 'application/json'
            'Authorization' = "Bearer ${accessToken}"
        }
        $body = @{} | ConvertTo-Json
        $parameters = @{
            'Uri'         = $url
            'Method'      = 'PUT'
            'Headers'     = $headers
            'Body'        = $body
            'ContentType' = 'application/json'
        }
        try {
            _ = Invoke-RestMethod @parameters
            Write-Host "Successfully enabled system schema '${systemSchema.schema}' in metastore ${currentMetastoreId}"
        }
        catch {
            $message = "REST API call to enable system schema failed"
            Write-Error $message
            throw $message
            exit 1
        }
    }
    elseif ($systemSchema.state -eq "ENABLE_COMPLETED") {
        Write-Host "System schema '${systemSchema.schema}' is already enabled in metastore '${currentMetastoreId}'"
    }
    else {
        Write-Host "System schema '${systemSchema.schema}' cannot be enabled in metastore '${currentMetastoreId}' as it is in state '${systemSchema.state}'"
    }
}
