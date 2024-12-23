resource "time_sleep" "sleep_databricks_workspace" {
  for_each = toset(var.locations_databricks)

  triggers = {
    databricks_workspace_completed = module.databricks_workspace[each.key].databricks_workspace_completed
  }
  create_duration = "30s"
}

resource "null_resource" "system_schema" {
  for_each = toset(var.locations_databricks)

  triggers = {}
  provisioner "local-exec" {
    working_dir = "${path.module}/../../scripts/"
    command     = "pwsh ./Enable-SystemSchemas.ps1 -DatabricksWorkspaceUrl ${module.databricks_workspace[each.key].databricks_workspace_workspace_url}"
    environment = {}
  }

  depends_on = [
    time_sleep.sleep_databricks_workspace
  ]
}
