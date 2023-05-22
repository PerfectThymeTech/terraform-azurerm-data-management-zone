module "data_management_zone" {
  source = "../"
  providers = {
    azurerm = azurerm
    azapi   = azapi
  }
}
