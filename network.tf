resource "azapi_resource" "private_endpoint_subnet" {
  type      = "Microsoft.Network/virtualNetworks/subnets@2022-07-01"
  name      = "ServicesSubnet"
  parent_id = data.azurerm_virtual_network.virtual_network.id

  body = {
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
  }
}

resource "azurerm_virtual_network" "virtual_network_databricks" {
  for_each = toset(var.locations_databricks)

  name                = "${local.prefix}-${each.value}-vnet001"
  location            = each.value
  resource_group_name = azurerm_resource_group.consumption_adb_rg[each.key].name
  tags                = var.tags

  address_space = ["10.0.0.0/20"]
  dns_servers   = []
  subnet {
    name                            = local.databricks_private_subnet_name
    address_prefixes                = ["10.0.0.0/26"]
    default_outbound_access_enabled = false
    delegation = [
      {
        name = "Microsoft.Databricks/workspaces"
        actions = [
          "Microsoft.Network/virtualNetworks/subnets/join/action",
          "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
          "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"
        ]
      }
    ]
    private_endpoint_network_policies             = "Enabled"
    private_link_service_network_policies_enabled = "Enabled"
    route_table_id                                = data.azurerm_route_table.route_table.id
    security_group                                = data.azurerm_network_security_group.network_security_group.id
    service_endpoint_policy_ids                   = []
    service_endpoints                             = []
  }
  subnet {
    name                            = local.databricks_public_subnet_name
    address_prefixes                = ["10.0.0.64/26"]
    default_outbound_access_enabled = false
    delegation = [
      {
        name = "Microsoft.Databricks/workspaces"
        actions = [
          "Microsoft.Network/virtualNetworks/subnets/join/action",
          "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
          "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"
        ]
      }
    ]
    private_endpoint_network_policies             = "Enabled"
    private_link_service_network_policies_enabled = "Enabled"
    route_table_id                                = data.azurerm_route_table.route_table.id
    security_group                                = data.azurerm_network_security_group.network_security_group.id
    service_endpoint_policy_ids                   = []
    service_endpoints                             = []
  }
}
