module "user_assigned_identity" {
  source = "github.com/PerfectThymeTech/terraform-azurerm-modules//modules/userassignedidentity?ref=main"
  providers = {
    azurerm = azurerm
  }

  location                                              = var.location
  resource_group_name                                   = azurerm_resource_group.automation_rg.name
  tags                                                  = var.tags
  user_assigned_identity_name                           = "${local.prefix}-uai001"
  user_assigned_identity_federated_identity_credentials = {}
}
