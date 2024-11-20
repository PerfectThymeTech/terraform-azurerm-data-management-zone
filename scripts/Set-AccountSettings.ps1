# Define script arguments
[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [String]
    $DatabricksAccountId,

    [Parameter(Mandatory = $false)]
    [String]
    $CompanyName,

    [Parameter(Mandatory = $false)]
    [bool]
    $EnableServerless = $true
)

# Configuration
$ErrorActionPreference = "Stop"

# Variables
$baseUrl = "https://accounts.azuredatabricks.net/api/2.0"

function Get-AccessToken {
    <#
    .SYNOPSIS
        Creates an Entra ID access token for Azure Databricks.

    .DESCRIPTION
        The function generates a new Entra ID access token to interact with the Databricks API.

    .EXAMPLE
        Get-AccessToken

    .NOTES
        Author:  Marvin Buss
        GitHub:  @marvinbuss
    #>
    [CmdletBinding()]
    param ()
    # Get access token
    Write-Verbose "Getting access token"
    $accessToken = $(az account get-access-token --resource "2ff814a6-3304-4ab8-85cb-cd0e6f879c1d" --query "accessToken" --output tsv)

    return $accessToken
}


##########################
# Configure account name #
##########################
if ($CompanyName) {
    # Get access token
    $accessToken = Get-AccessToken

    # Set account name
    $url = "${baseUrl}/accounts/${DatabricksAccountId}/name"
    $headers = @{
        'Content-Type'  = 'application/json'
        'Authorization' = "Bearer ${accessToken}"
    }
    $body = @{
        'name' = "${CompanyName}"
    } | ConvertTo-Json
    $parameters = @{
        'Uri'         = $url
        'Method'      = 'Post'
        'Headers'     = $headers
        'Body'        = $body
        'ContentType' = 'application/json'
    }
    try {
        $response = Invoke-RestMethod @parameters
    }
    catch {
        $message = "REST API call to set account name failed"
        Write-Error $message
        throw $message
        exit 1
    }
}

########################
# Configure serverless #
########################

# Get access token
$accessToken = Get-AccessToken

# Set account name
$url = "${baseUrl}/settings-api/accounts/${DatabricksAccountId}/serverless_jobs_nb_enable"
$headers = @{
    'Content-Type'  = 'application/json'
    'Authorization' = "Bearer ${accessToken}"
}
$body = @{
    'setting_payload' = @{
        'stored_value' = @{
            'bool_val' = @{
                'value' = $EnableServerless
            }
        }
    }
} | ConvertTo-Json
$parameters = @{
    'Uri'         = $url
    'Method'      = 'Post'
    'Headers'     = $headers
    'Body'        = $body
    'ContentType' = 'application/json'
}
try {
    $response = Invoke-RestMethod @parameters
}
catch {
    $message = "REST API call to set account name failed"
    Write-Error $message
    throw $message
    exit 1
}
