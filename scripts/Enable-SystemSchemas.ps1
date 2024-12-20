# Define script arguments
[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [String]
    $DatabricksWorkspaceUrl
)

# Configuration
$ErrorActionPreference = "Stop"
$ignoreListSystemSchemas = @(
    "__internal_logging"
)

# Get access token
$accessToken = $(az account get-access-token --resource "2ff814a6-3304-4ab8-85cb-cd0e6f879c1d" --query "accessToken" --output tsv)
Write-Host $accessToken

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
    $systemSchemaState = $systemSchema.state
    $systemSchemaName = $systemSchema.schema

    Write-Host "Starting to enable system schema '${systemSchemaName}' with state '${systemSchemaState}' in metastore ${currentMetastoreId}"

    # Check whether schema is in ignore list
    if ($systemSchemaName -in $ignoreListSystemSchemas) {
        continue
    }

    if ($systemSchemaState -eq "AVAILABLE") {
        # Enable system schema
        $url = "https://${DatabricksWorkspaceUrl}/api/2.0/unity-catalog/metastores/${currentMetastoreId}/systemschemas/${systemSchemaName}"
        $headers = @{
            'Content-Type'  = 'application/json'
            'Authorization' = "Bearer ${accessToken}"
        }
        $parameters = @{
            'Uri'         = $url
            'Method'      = 'PUT'
            'Headers'     = $headers
            'ContentType' = 'application/json'
        }
        try {
            Invoke-RestMethod @parameters
            Write-Host "Successfully enabled system schema '${systemSchemaName}' in metastore ${currentMetastoreId}"
        }
        catch {
            $message = "REST API call to enable system schema failed"
            Write-Error $message
            throw $message
            exit 1
        }
    }
    elseif ($systemSchemaState -eq "ENABLE_COMPLETED") {
        Write-Host "System schema '${systemSchemaName}' is already enabled in metastore '${currentMetastoreId}'"
    }
    else {
        Write-Host "System schema '${systemSchemaName}' cannot be enabled in metastore '${currentMetastoreId}' as it is in state '${systemSchemaState}'"
    }
}
