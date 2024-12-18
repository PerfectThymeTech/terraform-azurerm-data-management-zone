resource "azapi_update_resource" "virtual_network" {
  type        = "Microsoft.Network/virtualNetworks@2024-03-01"
  resource_id = data.azurerm_virtual_network.virtual_network.id

  body = {
    properties = {
      subnets = flatten([
        [
          local.subnet_private_endpoints,
        ],
      ])
    }
  }

  response_export_values  = ["properties.subnets"]
  locks                   = []
  ignore_casing           = true
  ignore_missing_property = true
}

resource "azurerm_network_security_group" "network_security_group_databricks" {
  for_each = toset(var.locations_databricks)

  name                = "${local.prefix}-${each.value}-nsg001"
  location            = each.value
  resource_group_name = azurerm_resource_group.resource_group_network_databricks.name
  tags                = var.tags

  lifecycle {
    ignore_changes = [
      security_rule,
    ]
  }
}

resource "azurerm_route_table" "route_table_databricks" {
  for_each = toset(var.locations_databricks)

  name                = "${local.prefix}-${each.value}-rt001"
  location            = each.value
  resource_group_name = azurerm_resource_group.resource_group_network_databricks.name
  tags                = var.tags

  bgp_route_propagation_enabled = false
  route                         = []
}

resource "azurerm_virtual_network" "virtual_network_databricks" {
  for_each = toset(var.locations_databricks)

  name                = "${local.prefix}-${each.value}-vnet001"
  location            = each.value
  resource_group_name = azurerm_resource_group.resource_group_network_databricks.name
  tags                = var.tags

  address_space = ["10.0.0.0/20"]
  dns_servers   = []
  subnet {
    name                            = local.subnet_databricks_private_name
    address_prefixes                = ["10.0.0.0/26"]
    default_outbound_access_enabled = true
    delegation {
      name = "DatabricksDelegation"
      service_delegation {
        actions = [
          "Microsoft.Network/virtualNetworks/subnets/join/action",
          "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
          "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action",
        ]
        name = "Microsoft.Databricks/workspaces"
      }
    }
    private_endpoint_network_policies             = "Enabled"
    private_link_service_network_policies_enabled = true
    route_table_id                                = azurerm_route_table.route_table_databricks[each.key].id
    security_group                                = azurerm_network_security_group.network_security_group_databricks[each.key].id
    service_endpoint_policy_ids                   = []
    service_endpoints                             = []
  }
  subnet {
    name                            = local.subnet_databricks_public_name
    address_prefixes                = ["10.0.0.64/26"]
    default_outbound_access_enabled = true
    delegation {
      name = "DatabricksDelegation"
      service_delegation {
        actions = [
          "Microsoft.Network/virtualNetworks/subnets/join/action",
          "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
          "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action",
        ]
        name = "Microsoft.Databricks/workspaces"
      }
    }
    private_endpoint_network_policies             = "Enabled"
    private_link_service_network_policies_enabled = true
    route_table_id                                = azurerm_route_table.route_table_databricks[each.key].id
    security_group                                = azurerm_network_security_group.network_security_group_databricks[each.key].id
    service_endpoint_policy_ids                   = []
    service_endpoints                             = []
  }
  subnet {
    name                                          = local.subnet_databricks_private_endpoint_name
    address_prefixes                              = ["10.0.0.128/26"]
    default_outbound_access_enabled               = true
    private_endpoint_network_policies             = "Enabled"
    private_link_service_network_policies_enabled = true
    route_table_id                                = azurerm_route_table.route_table_databricks[each.key].id
    security_group                                = azurerm_network_security_group.network_security_group_databricks[each.key].id
    service_endpoint_policy_ids                   = []
    service_endpoints                             = []
  }
}
