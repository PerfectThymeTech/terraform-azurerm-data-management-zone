resource "null_resource" "databricks_account_settings" {
  triggers = {
    company_name      = var.company_name
    enable_serverless = true
  }

  provisioner "local-exec" {
    working_dir = "${path.module}/scripts/"
    command     = "pwsh ./Set-AccountSettings.ps1 -DatabricksAccountId ${var.databricks_account_id} -CompanyName ${var.company_name} -EnableServerless true"
    environment = {}
  }

  depends_on = [
    module.key_vault_scim.key_vault_setup_completed
  ]
}
