resource "azurerm_resource_group" "resource_group_private_dns" {
  name     = "${local.prefix}-privatedns-rg"
  location = var.location
  tags     = var.tags
}

resource "azurerm_resource_group" "resource_group_network_databricks" {
  name     = "${local.prefix}-monitoring-rg"
  location = var.location
  tags     = var.tags
}
