data "external" "databricks_access_token" {
  program = [
    "pwsh", "${path.module}/scripts/Get-Token.ps1", "-Resource", "2ff814a6-3304-4ab8-85cb-cd0e6f879c1d"
  ]
  query = {}
}
