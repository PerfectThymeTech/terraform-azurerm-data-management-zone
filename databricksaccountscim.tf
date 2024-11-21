resource "time_rotating" "databricks_account_scim_token_regenerate" {
  rotation_months = 1
}

resource "null_resource" "databricks_account_scim_token" {
  triggers = {
    execute = time_rotating.databricks_account_scim_token_regenerate.rfc3339
  }

  provisioner "local-exec" {
    working_dir = "${path.module}/scripts/"
    command     = "pwsh ./Get-AccountScimToken.ps1 -DatabricksAccountId ${var.databricks_account_id} -KeyVaultName ${module.key_vault_scim.key_vault_name} -KeyVaultSecretName ${local.databricks_account_scim_secret_name}"
    environment = {}
  }

  depends_on = [
    module.key_vault_scim.key_vault_setup_completed
  ]
}

resource "random_uuid" "databricks_account_scim_uuid" {}

resource "azuread_application" "databricks_account_scim_application" {
  display_name = "databricks-account-scim-provisioning"
  template_id  = data.azuread_application_template.scim.template_id
  tags = [
    "Owner: ${data.azurerm_client_config.current.client_id}",
    "Description: This SPN is used for databricks SCIM configuration for the Databricks Account",
  ]

  app_role {
    allowed_member_types = ["Application", "User"]
    description          = "Users can perform limited actions"
    display_name         = "User"
    enabled              = true
    id                   = random_uuid.databricks_account_scim_uuid.result
    value                = "User"
  }
  description                   = "Databricks account SCIM application."
  oauth2_post_response_required = false
  owners                        = [data.azuread_client_config.current.object_id]
  prevent_duplicate_names       = true

}

resource "azuread_synchronization_secret" "synchronization" {
  service_principal_id = data.azuread_service_principal.databricks_account_scim_service_principal.id

  credential {
    key   = "BaseAddress"
    value = "https://accounts.azuredatabricks.net/api/2.1/accounts/${var.databricks_account_id}/scim/v2"
  }

  credential {
    key   = "SecretToken"
    value = data.azurerm_key_vault_secret.key_vault_secret_databricks_account_scim_token.value
  }

  credential {
    key   = "SyncAll"
    value = "false"
  }

  # credential {
  #   key = "SyncNotificationSettings"
  #   value = jsonencode({
  #     "Enabled"                             = "true"
  #     "DeleteThresholdEnabled"              = false
  #     "HumanResourcesLookaheadQueryEnabled" = false
  #     "Recipients"                          = "notifyme@targetmail.com" # email to notify
  #   })
  # }
}
