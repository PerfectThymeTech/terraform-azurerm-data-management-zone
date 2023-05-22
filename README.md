<!-- BEGIN_TF_DOCS -->
# CloudScaleAnalytics v2 Terraform

This project revisits the Cloud Scale Analytics data platform reference architecture for Microsoft Azure. While the core principles of the architecture design have not changed, the next generation of the design will and enhance and introduce many new capabilities that will simplify the overall management, onboarding and significantly reduce the time to market.

Over the last couple of years, numerous data platforms have been built on the basis of Cloud Scale Analytics which resulted in a ton of learnings and insights. In addition to that, new services and features have been introduced, reached a GA status and common requirements have drifted. All these data points have been used to build this next iteration of the reference architecture for scalable data platforms on Azure.

The Cloud Scale Analytics reference architecture consists of the following core building blocks:

1. The *Data Management Zone* is the core data governance entity of on organization. In this Azure subscription, an organization places all data management solution including their data catalog, the data lineage solution, the master data management tool and other data governance capabilities. Placing these tools inside a single subscription ensures a resusable data management framework that can be applied to all *Data Landing Zones* and other data sources across an organization.

2. The *Data Landing Zone* is used for data retention and processing. A *Data Landing Zone* maps to a single Azure Subscription, but organizations are encouraged to have multiple of these for scaling purposes. Within a *Data Landing Zone* an orgnaization may implement one or multiple data applications.

3. A *Data Application* environment is a bounded context within a *Data Landing Zone*. A *Data Application* is concerned with consuming, processing and producing data as an output. These outputs should no longer be treated as byproducts but rather be managed as a full product that has a defined service-level-agreement.

![Cloud-scale Analytics v2](/docs/media/CloudScaleAnalyticsv2.gif)

## Documentation
<!-- markdownlint-disable MD033 -->

## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>=0.13)

- <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) (~> 1.6.0)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 3.56.0)

- <a name="requirement_databricks"></a> [databricks](#requirement\_databricks) (~> 1.16.0)

## Modules

No modules.

<!-- markdownlint-disable MD013 -->
<!-- markdownlint-disable MD034 -->
## Required Inputs

The following input variables are required:

### <a name="input_company_name"></a> [company\_name](#input\_company\_name)

Description: Specifies the name of the company.

Type: `string`

### <a name="input_data_platform_subscription_ids"></a> [data\_platform\_subscription\_ids](#input\_data\_platform\_subscription\_ids)

Description: Specifies the list of subscription IDs of your data platform.

Type: `list(string)`

### <a name="input_location"></a> [location](#input\_location)

Description: Specifies the location for all Azure resources.

Type: `string`

### <a name="input_nsg_id"></a> [nsg\_id](#input\_nsg\_id)

Description: Specifies the resource ID of the default network security group for the Data Management Zone

Type: `string`

### <a name="input_prefix"></a> [prefix](#input\_prefix)

Description: Specifies the prefix for all resources created in this deployment.

Type: `string`

### <a name="input_private_dns_zone_id_blob"></a> [private\_dns\_zone\_id\_blob](#input\_private\_dns\_zone\_id\_blob)

Description: Specifies the resource ID of the private DNS zone for Azure Storage blob endpoints.

Type: `string`

### <a name="input_private_dns_zone_id_container_registry"></a> [private\_dns\_zone\_id\_container\_registry](#input\_private\_dns\_zone\_id\_container\_registry)

Description: Specifies the resource ID of the private DNS zone for Azure Container Registry.

Type: `string`

### <a name="input_private_dns_zone_id_databricks"></a> [private\_dns\_zone\_id\_databricks](#input\_private\_dns\_zone\_id\_databricks)

Description: Specifies the resource ID of the private DNS zone for Azure Databricks UI endpoints.

Type: `string`

### <a name="input_private_dns_zone_id_dfs"></a> [private\_dns\_zone\_id\_dfs](#input\_private\_dns\_zone\_id\_dfs)

Description: Specifies the resource ID of the private DNS zone for Azure Storage dfs endpoints.

Type: `string`

### <a name="input_private_dns_zone_id_key_vault"></a> [private\_dns\_zone\_id\_key\_vault](#input\_private\_dns\_zone\_id\_key\_vault)

Description: Specifies the resource ID of the private DNS zone for Azure Key Vault.

Type: `string`

### <a name="input_private_dns_zone_id_namespace"></a> [private\_dns\_zone\_id\_namespace](#input\_private\_dns\_zone\_id\_namespace)

Description: Specifies the resource ID of the private DNS zone for the EventHub namespace.

Type: `string`

### <a name="input_private_dns_zone_id_purview_account"></a> [private\_dns\_zone\_id\_purview\_account](#input\_private\_dns\_zone\_id\_purview\_account)

Description: Specifies the resource ID of the private DNS zone for the Purview account.

Type: `string`

### <a name="input_private_dns_zone_id_purview_portal"></a> [private\_dns\_zone\_id\_purview\_portal](#input\_private\_dns\_zone\_id\_purview\_portal)

Description: Specifies the resource ID of the private DNS zone for the Purview portal.

Type: `string`

### <a name="input_private_dns_zone_id_queue"></a> [private\_dns\_zone\_id\_queue](#input\_private\_dns\_zone\_id\_queue)

Description: Specifies the resource ID of the private DNS zone for Azure Storage queue endpoints.

Type: `string`

### <a name="input_private_dns_zone_id_synapse_portal"></a> [private\_dns\_zone\_id\_synapse\_portal](#input\_private\_dns\_zone\_id\_synapse\_portal)

Description: Specifies the resource ID of the private DNS zone for Synapse PL Hub.

Type: `string`

### <a name="input_purview_root_collection_admins"></a> [purview\_root\_collection\_admins](#input\_purview\_root\_collection\_admins)

Description: Specifies the list of user object IDs that are assigned as collection admin to the root collection in Purview.

Type: `list(string)`

### <a name="input_route_table_id"></a> [route\_table\_id](#input\_route\_table\_id)

Description: Specifies the resource ID of the default route table for the Data Management Zone

Type: `string`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: Specifies the tags that you want to apply to all resources.

Type: `map(string)`

### <a name="input_vnet_id"></a> [vnet\_id](#input\_vnet\_id)

Description: Specifies the resource ID of the Vnet used for the Data Management Zone

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_environment"></a> [environment](#input\_environment)

Description: Specifies the environment of the deployment.

Type: `string`

Default: `"dev"`

## Outputs

No outputs.

<!-- markdownlint-enable -->
## License

[MIT License](/LICENSE)

## Contributing

This project accepts public contributions. Please use issues, pull requests and the discussins feature in case you have any questions or concerns.

<!-- END_TF_DOCS -->