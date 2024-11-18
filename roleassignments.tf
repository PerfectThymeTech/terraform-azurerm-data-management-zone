resource "azurerm_role_assignment" "purview_roleassignment_key_vault" {
  scope                = module.key_vault.key_vault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = module.purview_account.purview_account_principal_id
}
