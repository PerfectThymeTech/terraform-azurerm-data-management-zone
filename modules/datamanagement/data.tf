data "azurerm_client_config" "current" {}

data "azurerm_key_vault_secret" "key_vault_secret_databricks_account_scim_token" {
  key_vault_id = module.key_vault_scim.key_vault_id
  name         = local.databricks_account_scim_secret_name

  depends_on = [
    null_resource.databricks_account_scim_token,
  ]
}
