locals {
  prefix = "${lower(var.prefix)}-${var.environment}"

  # Databricks locals
  databricks_account_scim_secret_name = "scim-token"
  system_schema_names = [
    "access",
    "billing",
    "compute",
    "lakeflow",
    "marketplace",
    "query",
    "serving",
    "storage",
  ]
}
