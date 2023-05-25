<!-- BEGIN_TF_DOCS -->
# CloudScaleAnalytics v2 - Data Management Zone

This project revisits the Cloud Scale Analytics data platform reference architecture for Microsoft Azure. While the core principles of the architecture design have not changed, the next generation of the design will and enhance and introduce many new capabilities that will simplify the overall management, onboarding and significantly reduce the time to market.

Over the last couple of years, numerous data platforms have been built on the basis of Cloud Scale Analytics which resulted in a ton of learnings and insights. In addition to that, new services and features have been introduced, reached a GA status and common requirements have drifted. All these data points have been used to build this next iteration of the reference architecture for scalable data platforms on Azure.

The Cloud Scale Analytics reference architecture consists of the following core building blocks:

1. The *Data Management Zone* is the core data governance entity of on organization. In this Azure subscription, an organization places all data management solution including their data catalog, the data lineage solution, the master data management tool and other data governance capabilities. Placing these tools inside a single subscription ensures a resusable data management framework that can be applied to all *Data Landing Zones* and other data sources across an organization.

2. The *Data Landing Zone* is used for data retention and processing. A *Data Landing Zone* maps to a single Azure Subscription, but organizations are encouraged to have multiple of these for scaling purposes. Within a *Data Landing Zone* an orgnaization may implement one or multiple data applications.

3. A *Data Application* environment is a bounded context within a *Data Landing Zone*. A *Data Application* is concerned with consuming, processing and producing data as an output. These outputs should no longer be treated as byproducts but rather be managed as a full product that has a defined service-level-agreement.

![Cloud-scale Analytics v2](https://raw.githubusercontent.com/PerfectThymeTech/terraform-azurerm-data-management-zone/main/docs/media/CloudScaleAnalyticsv2.gif)

## Architecture

The following architecture will be deployed by this module, whereby the module expects that the Vnet, Route Table and NSG already exists within the Azure Landing Zone and respective resource IDs are provided as input:

![Data Management Zone Architecture](https://raw.githubusercontent.com/PerfectThymeTech/terraform-azurerm-data-management-zone/main/docs/media/DataManagementZoneArchitecture.png)

## Prerequisites

- An Azure subscription. If you don't have an Azure subscription, [create your Azure free account today](https://azure.microsoft.com/free/).
- (1) [Contributor](https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#contributor) and [User Access Administrator](https://learn.microsoft.com/azure/role-based-access-control/built-in-roles#user-access-administrator) or (2) [Owner](https://learn.microsoft.com/azure/role-based-access-control/built-in-roles#owner) access to the subscription to be able to create resources and role assignments.
- A [GitHub self-hosted runner](https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners/about-self-hosted-runners) or an [Azure DevOps self-hosted agent](https://learn.microsoft.com/en-us/azure/devops/pipelines/agents/linux-agent?view=azure-devops) to be able to access the data-plane of services.

## Usage

We recommend starting with the following configuration in your root module to learn what resources are created by the module and how it works.

```hcl
# Configure Terraform to set the required AzureRM provider
# version and features{} block.

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.56.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azapi" {}

# Declare locals for the module
locals {
  company_name   = "<my-company-name>"
  location       = "northeurope"
  prefix         = "<my-prefix>"
  vnet_id        = "/subscriptions/<my-subscription-id>/resourceGroups/<my-rg-name>/providers/Microsoft.Network/virtualNetworks/<my-vnet-name>"
  nsg_id         = "/subscriptions/<my-subscription-id>/resourceGroups/<my-rg-name>/providers/Microsoft.Network/networkSecurityGroups/<my-nsg-name>"
  route_table_id = "/subscriptions/<my-subscription-id>/resourceGroups/<my-rg-name>/providers/Microsoft.Network/routeTables/<my-rt-name>"

  # If DNS A-records are deployed via Policy then you can also set these to an empty string (e.g. "") or remove them entirely
  private_dns_zone_id_namespace          = "/subscriptions/<my-subscription-id>/resourceGroups/<my-rg-name>/providers/Microsoft.Network/privateDnsZones/privatelink.servicebus.windows.net"
  private_dns_zone_id_purview_account    = "/subscriptions/<my-subscription-id>/resourceGroups/<my-rg-name>/providers/Microsoft.Network/privateDnsZones/privatelink.purview.azure.com"
  private_dns_zone_id_purview_portal     = "/subscriptions/<my-subscription-id>/resourceGroups/<my-rg-name>/providers/Microsoft.Network/privateDnsZones/privatelink.purviewstudio.azure.com"
  private_dns_zone_id_blob               = "/subscriptions/<my-subscription-id>/resourceGroups/<my-rg-name>/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net"
  private_dns_zone_id_dfs                = "/subscriptions/<my-subscription-id>/resourceGroups/<my-rg-name>/providers/Microsoft.Network/privateDnsZones/privatelink.dfs.core.windows.net"
  private_dns_zone_id_queue              = "/subscriptions/<my-subscription-id>/resourceGroups/<my-rg-name>/providers/Microsoft.Network/privateDnsZones/privatelink.queue.core.windows.net"
  private_dns_zone_id_container_registry = "/subscriptions/<my-subscription-id>/resourceGroups/<my-rg-name>/providers/Microsoft.Network/privateDnsZones/privatelink.azurecr.io"
  private_dns_zone_id_synapse_portal     = "/subscriptions/<my-subscription-id>/resourceGroups/<my-rg-name>/providers/Microsoft.Network/privateDnsZones/privatelink.azuresynapse.net"
  private_dns_zone_id_key_vault          = "/subscriptions/<my-subscription-id>/resourceGroups/<my-rg-name>/providers/Microsoft.Network/privateDnsZones/privatelink.vaultcore.azure.net"
  private_dns_zone_id_databricks         = "/subscriptions/<my-subscription-id>/resourceGroups/<my-rg-name>/providers/Microsoft.Network/privateDnsZones/privatelink.azuredatabricks.net"
}

# Declare the Data Management Terraform module
# and provide a base configuration.
module "data_management_zone" {
  source  = "PerfectThymeTech/data-management-zone/azurerm"
  version = "0.1.1"
  providers = {
    azurerm = azurerm
    azapi   = azapi
  }

  company_name                           = local.company_name
  location                               = local.location
  prefix                                 = local.prefix
  vnet_id                                = local.vnet_id
  nsg_id                                 = local.nsg_id
  route_table_id                         = local.route_table_id
  private_dns_zone_id_namespace          = local.private_dns_zone_id_namespace
  private_dns_zone_id_purview_account    = local.private_dns_zone_id_purview_account
  private_dns_zone_id_purview_portal     = local.private_dns_zone_id_purview_portal
  private_dns_zone_id_blob               = local.private_dns_zone_id_blob
  private_dns_zone_id_dfs                = local.private_dns_zone_id_dfs
  private_dns_zone_id_queue              = local.private_dns_zone_id_queue
  private_dns_zone_id_container_registry = local.private_dns_zone_id_container_registry
  private_dns_zone_id_synapse_portal     = local.private_dns_zone_id_synapse_portal
  private_dns_zone_id_key_vault          = local.private_dns_zone_id_key_vault
  private_dns_zone_id_databricks         = local.private_dns_zone_id_databricks
}
```

## Documentation
<!-- markdownlint-disable MD033 -->

## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>=0.13)

- <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) (>= 1.5.0)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (>= 3.56.0)

- <a name="requirement_databricks"></a> [databricks](#requirement\_databricks) (>= 1.16.0)

## Modules

No modules.

<!-- markdownlint-disable MD013 -->
<!-- markdownlint-disable MD034 -->
## Required Inputs

The following input variables are required:

### <a name="input_company_name"></a> [company\_name](#input\_company\_name)

Description: Specifies the name of the company.

Type: `string`

### <a name="input_location"></a> [location](#input\_location)

Description: Specifies the location for all Azure resources.

Type: `string`

### <a name="input_nsg_id"></a> [nsg\_id](#input\_nsg\_id)

Description: Specifies the resource ID of the default network security group for the Data Management Zone

Type: `string`

### <a name="input_prefix"></a> [prefix](#input\_prefix)

Description: Specifies the prefix for all resources created in this deployment.

Type: `string`

### <a name="input_route_table_id"></a> [route\_table\_id](#input\_route\_table\_id)

Description: Specifies the resource ID of the default route table for the Data Management Zone

Type: `string`

### <a name="input_vnet_id"></a> [vnet\_id](#input\_vnet\_id)

Description: Specifies the resource ID of the Vnet used for the Data Management Zone

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_data_platform_subscription_ids"></a> [data\_platform\_subscription\_ids](#input\_data\_platform\_subscription\_ids)

Description: Specifies the list of subscription IDs of your data platform.

Type: `list(string)`

Default: `[]`

### <a name="input_environment"></a> [environment](#input\_environment)

Description: Specifies the environment of the deployment.

Type: `string`

Default: `"dev"`

### <a name="input_private_dns_zone_id_blob"></a> [private\_dns\_zone\_id\_blob](#input\_private\_dns\_zone\_id\_blob)

Description: Specifies the resource ID of the private DNS zone for Azure Storage blob endpoints.

Type: `string`

Default: `""`

### <a name="input_private_dns_zone_id_container_registry"></a> [private\_dns\_zone\_id\_container\_registry](#input\_private\_dns\_zone\_id\_container\_registry)

Description: Specifies the resource ID of the private DNS zone for Azure Container Registry.

Type: `string`

Default: `""`

### <a name="input_private_dns_zone_id_databricks"></a> [private\_dns\_zone\_id\_databricks](#input\_private\_dns\_zone\_id\_databricks)

Description: Specifies the resource ID of the private DNS zone for Azure Databricks UI endpoints.

Type: `string`

Default: `""`

### <a name="input_private_dns_zone_id_dfs"></a> [private\_dns\_zone\_id\_dfs](#input\_private\_dns\_zone\_id\_dfs)

Description: Specifies the resource ID of the private DNS zone for Azure Storage dfs endpoints.

Type: `string`

Default: `""`

### <a name="input_private_dns_zone_id_key_vault"></a> [private\_dns\_zone\_id\_key\_vault](#input\_private\_dns\_zone\_id\_key\_vault)

Description: Specifies the resource ID of the private DNS zone for Azure Key Vault.

Type: `string`

Default: `""`

### <a name="input_private_dns_zone_id_namespace"></a> [private\_dns\_zone\_id\_namespace](#input\_private\_dns\_zone\_id\_namespace)

Description: Specifies the resource ID of the private DNS zone for the EventHub namespace.

Type: `string`

Default: `""`

### <a name="input_private_dns_zone_id_purview_account"></a> [private\_dns\_zone\_id\_purview\_account](#input\_private\_dns\_zone\_id\_purview\_account)

Description: Specifies the resource ID of the private DNS zone for the Purview account.

Type: `string`

Default: `""`

### <a name="input_private_dns_zone_id_purview_portal"></a> [private\_dns\_zone\_id\_purview\_portal](#input\_private\_dns\_zone\_id\_purview\_portal)

Description: Specifies the resource ID of the private DNS zone for the Purview portal.

Type: `string`

Default: `""`

### <a name="input_private_dns_zone_id_queue"></a> [private\_dns\_zone\_id\_queue](#input\_private\_dns\_zone\_id\_queue)

Description: Specifies the resource ID of the private DNS zone for Azure Storage queue endpoints.

Type: `string`

Default: `""`

### <a name="input_private_dns_zone_id_synapse_portal"></a> [private\_dns\_zone\_id\_synapse\_portal](#input\_private\_dns\_zone\_id\_synapse\_portal)

Description: Specifies the resource ID of the private DNS zone for Synapse PL Hub.

Type: `string`

Default: `""`

### <a name="input_purview_root_collection_admins"></a> [purview\_root\_collection\_admins](#input\_purview\_root\_collection\_admins)

Description: Specifies the list of user object IDs that are assigned as collection admin to the root collection in Purview.

Type: `list(string)`

Default: `[]`

### <a name="input_subnet_cidr_ranges"></a> [subnet\_cidr\_ranges](#input\_subnet\_cidr\_ranges)

Description: Specifies the cidr ranges of the subnets used for the Data Management Zone. If not specified, the module will automatically define the right subnet cidr ranges. For this to work, the provided vnet must have no subnets.

Type:

```hcl
object(
    {
      private_endpoint_subnet   = optional(string, "")
      databricks_private_subnet = optional(string, "")
      databricks_public_subnet  = optional(string, "")
    }
  )
```

Default: `{}`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: Specifies the tags that you want to apply to all resources.

Type: `map(string)`

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_container_registry_id"></a> [container\_registry\_id](#output\_container\_registry\_id)

Description: Specifies the id of the container registry.

### <a name="output_databricks_access_connector_id"></a> [databricks\_access\_connector\_id](#output\_databricks\_access\_connector\_id)

Description: Specifies the id of the databricks access connector.

### <a name="output_databricks_datalake_id"></a> [databricks\_datalake\_id](#output\_databricks\_datalake\_id)

Description: Specifies the id of the datalake used as a default for the databricks metastore.

### <a name="output_databricks_metastore_id"></a> [databricks\_metastore\_id](#output\_databricks\_metastore\_id)

Description: Specifies the id of the databricks metastore.

### <a name="output_databricks_workspace_id"></a> [databricks\_workspace\_id](#output\_databricks\_workspace\_id)

Description: Specifies the id of the databricks workspace.

### <a name="output_key_vault_id"></a> [key\_vault\_id](#output\_key\_vault\_id)

Description: Specifies the id of the Azure key vault provisioned for Microsoft Purview.

### <a name="output_purview_id"></a> [purview\_id](#output\_purview\_id)

Description: Specifies the id of the Microsoft Purview account.

### <a name="output_synapse_private_link_hub_id"></a> [synapse\_private\_link\_hub\_id](#output\_synapse\_private\_link\_hub\_id)

Description: Specifies the id of the Azure synapse private link hub.

<!-- markdownlint-enable -->
## License

[MIT License](/LICENSE)

## Contributing

This project accepts public contributions. Please use issues, pull requests and the discussins feature in case you have any questions or want to enhance this module.

<!-- END_TF_DOCS -->