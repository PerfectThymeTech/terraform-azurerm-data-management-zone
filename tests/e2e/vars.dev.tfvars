# General variables
company_name = "PerfectThymeTech"
location     = "northeurope"
environment  = "dev"
prefix       = "mydmgmt"
tags         = {}

# Service variables
databricks_locations = []

# HA/DR variables
zone_redundancy_enabled = false

# Logging and monitoring variables
log_analytics_workspace_id = "/subscriptions/e82c5267-9dc4-4f45-ac13-abdd5e130d27/resourceGroups/ptt-dev-logging-rg/providers/Microsoft.OperationalInsights/workspaces/ptt-dev-log001"

# Network variables
vnet_id            = "/subscriptions/8f171ff9-2b5b-4f0f-aed5-7fa360a1d094/resourceGroups/mycrp-prd-dmgmt-network-rg/providers/Microsoft.Network/virtualNetworks/mycrp-prd-dmgmt-vnet001"
nsg_id             = "/subscriptions/8f171ff9-2b5b-4f0f-aed5-7fa360a1d094/resourceGroups/mycrp-prd-dmgmt-network-rg/providers/Microsoft.Network/networkSecurityGroups/mycrp-prd-dmgmt-nsg001"
route_table_id     = "/subscriptions/8f171ff9-2b5b-4f0f-aed5-7fa360a1d094/resourceGroups/mycrp-prd-dmgmt-network-rg/providers/Microsoft.Network/routeTables/mycrp-prd-dmgmt-rt001"
subnet_cidr_ranges = {}

# DNS variables
private_dns_zone_id_namespace          = "/subscriptions/8f171ff9-2b5b-4f0f-aed5-7fa360a1d094/resourceGroups/mycrp-prd-global-dns/providers/Microsoft.Network/privateDnsZones/privatelink.servicebus.windows.net"
private_dns_zone_id_purview_account    = "/subscriptions/8f171ff9-2b5b-4f0f-aed5-7fa360a1d094/resourceGroups/mycrp-prd-global-dns/providers/Microsoft.Network/privateDnsZones/privatelink.purview.azure.com"
private_dns_zone_id_purview_portal     = "/subscriptions/8f171ff9-2b5b-4f0f-aed5-7fa360a1d094/resourceGroups/mycrp-prd-global-dns/providers/Microsoft.Network/privateDnsZones/privatelink.purviewstudio.azure.com"
private_dns_zone_id_blob               = "/subscriptions/8f171ff9-2b5b-4f0f-aed5-7fa360a1d094/resourceGroups/mycrp-prd-global-dns/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net"
private_dns_zone_id_dfs                = "/subscriptions/8f171ff9-2b5b-4f0f-aed5-7fa360a1d094/resourceGroups/mycrp-prd-global-dns/providers/Microsoft.Network/privateDnsZones/privatelink.dfs.core.windows.net"
private_dns_zone_id_queue              = "/subscriptions/8f171ff9-2b5b-4f0f-aed5-7fa360a1d094/resourceGroups/mycrp-prd-global-dns/providers/Microsoft.Network/privateDnsZones/privatelink.queue.core.windows.net"
private_dns_zone_id_container_registry = "/subscriptions/8f171ff9-2b5b-4f0f-aed5-7fa360a1d094/resourceGroups/mycrp-prd-global-dns/providers/Microsoft.Network/privateDnsZones/privatelink.azurecr.io"
private_dns_zone_id_synapse_portal     = "/subscriptions/8f171ff9-2b5b-4f0f-aed5-7fa360a1d094/resourceGroups/mycrp-prd-global-dns/providers/Microsoft.Network/privateDnsZones/privatelink.azuresynapse.net"
private_dns_zone_id_key_vault          = "/subscriptions/8f171ff9-2b5b-4f0f-aed5-7fa360a1d094/resourceGroups/mycrp-prd-global-dns/providers/Microsoft.Network/privateDnsZones/privatelink.vaultcore.azure.net"
private_dns_zone_id_databricks         = "/subscriptions/8f171ff9-2b5b-4f0f-aed5-7fa360a1d094/resourceGroups/mycrp-prd-global-dns/providers/Microsoft.Network/privateDnsZones/privatelink.azuredatabricks.net"

# Customer-managed key variables
customer_managed_key = null
