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

resource "azurerm_network_security_group" "network_security_group_databricks" {
  for_each = toset(var.locations_databricks)

  name                = "${local.prefix}-${each.value}-nsg001"
  location            = each.value
  resource_group_name = azurerm_resource_group.consumption_adb_rg[each.key].name
  tags                = var.tags

  security_rule {
    name                       = "Allow-DatabricksWorkerToEventhub"
    priority                   = 100
    access                     = "Allow"
    description                = "Allow Databricks Worker to Event Hub traffic."
    direction                  = "Outbound"
    protocol                   = "Tcp"
    destination_address_prefix = "EventHub"
    destination_port_range     = "9093"
    source_address_prefix      = "VirtualNetwork"
    source_port_range          = "*"
  }
  security_rule {
    name                       = "Allow-DatabricksWorkerToStorage"
    priority                   = 110
    access                     = "Allow"
    description                = "Allow Databricks Worker to Storage traffic."
    direction                  = "Outbound"
    protocol                   = "Tcp"
    destination_address_prefix = "Storage"
    destination_port_range     = "443"
    source_address_prefix      = "VirtualNetwork"
    source_port_range          = "*"
  }
  security_rule {
    name                       = "Allow-DatabricksWorkerToSql"
    priority                   = 120
    access                     = "Allow"
    description                = "Allow Databricks Worker to SQL traffic."
    direction                  = "Outbound"
    protocol                   = "Tcp"
    destination_address_prefix = "SQL"
    destination_port_range     = "3306"
    source_address_prefix      = "VirtualNetwork"
    source_port_range          = "*"
  }
}

resource "azurerm_route_table" "route_table_databricks" {
  for_each = toset(var.locations_databricks)

  name                = "${local.prefix}-${each.value}-rt001"
  location            = each.value
  resource_group_name = azurerm_resource_group.consumption_adb_rg[each.key].name
  tags                = var.tags

  bgp_route_propagation_enabled = false
  route                         = []
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
    name                            = local.databricks_public_subnet_name
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
}
