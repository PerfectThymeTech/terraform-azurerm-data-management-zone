data "azurerm_virtual_network" "virtual_network" {
  name                = local.virtual_network.name
  resource_group_name = local.virtual_network.resource_group_name
}

data "azurerm_network_security_group" "network_security_group" {
  name                = local.network_security_group.name
  resource_group_name = local.network_security_group.resource_group_name
}

data "azurerm_route_table" "route_table" {
  name                = local.route_table.name
  resource_group_name = local.route_table.resource_group_name
}

resource "azapi_resource" "private_endpoint_subnet" {
  type      = "Microsoft.Network/virtualNetworks/subnets@2022-07-01"
  name      = "ServicesSubnet"
  parent_id = data.azurerm_virtual_network.virtual_network.id

  body = jsonencode({
    properties = {
      addressPrefix = local.subnet_cidr_ranges.private_endpoint_subnet
      delegations   = []
      ipAllocations = []
      networkSecurityGroup = {
        id = data.azurerm_network_security_group.network_security_group.id
      }
      privateEndpointNetworkPolicies    = "Enabled"
      privateLinkServiceNetworkPolicies = "Enabled"
      routeTable = {
        id = data.azurerm_route_table.route_table.id
      }
      serviceEndpointPolicies = []
      serviceEndpoints        = []
    }
  })
}

resource "azapi_resource" "databricks_private_subnet" {
  type      = "Microsoft.Network/virtualNetworks/subnets@2022-07-01"
  name      = "DatabricksPrivateSubnet"
  parent_id = data.azurerm_virtual_network.virtual_network.id

  body = jsonencode({
    properties = {
      addressPrefix = local.subnet_cidr_ranges.databricks_private_subnet
      delegations = [
        {
          name = "DatabricksSubnetDelegation"
          properties = {
            serviceName = "Microsoft.Databricks/workspaces"
          }
        }
      ]
      ipAllocations = []
      networkSecurityGroup = {
        id = data.azurerm_network_security_group.network_security_group.id
      }
      privateEndpointNetworkPolicies    = "Enabled"
      privateLinkServiceNetworkPolicies = "Enabled"
      routeTable = {
        id = data.azurerm_route_table.route_table.id
      }
      serviceEndpointPolicies = []
      serviceEndpoints        = []
    }
  })

  depends_on = [
    azapi_resource.private_endpoint_subnet
  ]
}

resource "azapi_resource" "databricks_public_subnet" {
  type      = "Microsoft.Network/virtualNetworks/subnets@2022-07-01"
  name      = "DatabricksPublicSubnet"
  parent_id = data.azurerm_virtual_network.virtual_network.id

  body = jsonencode({
    properties = {
      addressPrefix = local.subnet_cidr_ranges.databricks_public_subnet
      delegations = [
        {
          name = "DatabricksSubnetDelegation"
          properties = {
            serviceName = "Microsoft.Databricks/workspaces"
          }
        }
      ]
      ipAllocations = []
      networkSecurityGroup = {
        id = data.azurerm_network_security_group.network_security_group.id
      }
      privateEndpointNetworkPolicies    = "Enabled"
      privateLinkServiceNetworkPolicies = "Enabled"
      routeTable = {
        id = data.azurerm_route_table.route_table.id
      }
      serviceEndpointPolicies = []
      serviceEndpoints        = []
    }
  })

  depends_on = [
    azapi_resource.databricks_private_subnet
  ]
}
