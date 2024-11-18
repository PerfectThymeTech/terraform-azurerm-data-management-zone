data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "governance_rg" {
  name     = "${local.prefix}-governance-rg"
  location = var.location
  tags     = var.tags
}

resource "azurerm_resource_group" "unity_rg" {
  name     = "${local.prefix}-consumption-adb-rg"
  location = var.location
  tags     = var.tags
}

resource "azurerm_resource_group" "container_rg" {
  name     = "${local.prefix}-container-rg"
  location = var.location
  tags     = var.tags
}

resource "azurerm_resource_group" "consumption_rg" {
  name     = "${local.prefix}-consumption-syn-rg"
  location = var.location
  tags     = var.tags
}

resource "azurerm_resource_group" "automation_rg" {
  name     = "${local.prefix}-automation-rg"
  location = var.location
  tags     = var.tags
}
