locals {
  # General locals
  prefix = "${lower(var.prefix)}-${var.environment}"

  # Diagnostics locals
  diagnostics_configurations = var.log_analytics_workspace_id == null ? [] : [
    {
      log_analytics_workspace_id = var.log_analytics_workspace_id
      storage_account_id         = ""
    }
  ]

  # Customer managed key locals
  customer_managed_key = null

  # Network locals
  connectivity_delay_in_seconds = 30
}
