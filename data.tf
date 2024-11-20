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

data "azurerm_key_vault_secret" "key_vault_secret_databricks_account_scim_token" {
  key_vault_id = module.key_vault_scim.key_vault_id
  name         = local.databricks_account_scim_secret_name

  depends_on = [
    null_resource.databricks_account_scim_token,
  ]
}
