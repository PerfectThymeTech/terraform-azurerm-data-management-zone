resource "azurerm_resource_group" "governance_rg" {
  name     = "${local.prefix}-governance-rg"
  location = var.location
  tags     = var.tags
}

resource "azurerm_resource_group" "connectivity_adb_rg" {
  for_each = toset(var.locations_databricks)

  name     = "${local.prefix}-connectivity-adb-${each.value}-rg"
  location = var.location
  tags     = var.tags
}

resource "azurerm_resource_group" "container_rg" {
  name     = "${local.prefix}-container-rg"
  location = var.location
  tags     = var.tags
}

resource "azurerm_resource_group" "connectivity_synapse_rg" {
  name     = "${local.prefix}-connectivity-syn-rg"
  location = var.location
  tags     = var.tags
}

resource "azurerm_resource_group" "automation_rg" {
  name     = "${local.prefix}-automation-rg"
  location = var.location
  tags     = var.tags
}

resource "azurerm_resource_group" "scim_rg" {
  name     = "${local.prefix}-scim-rg"
  location = var.location
  tags     = var.tags
}
