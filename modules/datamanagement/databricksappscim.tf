resource "time_rotating" "databricks_account_scim_token_regenerate" {
  rotation_months = 12
}

resource "null_resource" "databricks_account_scim_token" {
  triggers = {
    execute = time_rotating.databricks_account_scim_token_regenerate.rfc3339
  }

  provisioner "local-exec" {
    working_dir = "${path.module}/../../scripts/"
    command     = "pwsh ./Get-AccountScimToken.ps1 -DatabricksAccountId ${var.databricks_account_id} -KeyVaultName ${module.key_vault_scim.key_vault_name} -KeyVaultSecretName ${local.databricks_account_scim_secret_name}"
    environment = {}
  }

  depends_on = [
    module.key_vault_scim.key_vault_setup_completed
  ]
}
