# Azure SQL Server with Entra ID-only authentication (no SQL passwords)
resource "azurerm_mssql_server" "main" {
  name                = "sql-${local.resource_prefix}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  version             = "12.0"
  tags                = var.tags

  # Disable SQL authentication - Entra ID only
  azuread_administrator {
    login_username              = var.sql_admin_login
    object_id                   = var.sql_admin_object_id
    azuread_authentication_only = true
  }

  minimum_tls_version = "1.2"

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.app.id]
  }

  primary_user_assigned_identity_id = azurerm_user_assigned_identity.app.id
}

# Azure SQL Database - Basic tier
resource "azurerm_mssql_database" "main" {
  name           = "sqldb-${local.resource_prefix}"
  server_id      = azurerm_mssql_server.main.id
  sku_name       = var.sql_sku
  max_size_gb    = 2
  zone_redundant = false
  tags           = var.tags
}

# Allow Azure services to access SQL Server
resource "azurerm_mssql_firewall_rule" "azure_services" {
  name             = "AllowAzureServices"
  server_id        = azurerm_mssql_server.main.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}
