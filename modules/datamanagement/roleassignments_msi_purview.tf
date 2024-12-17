resource "azurerm_role_assignment" "purview_roleassignment_key_vault" {
  count = var.purview_enabled ? 1 : 0

  scope                = module.key_vault_purview.key_vault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = one(module.purview_account["*"].purview_account_principal_id)
}
