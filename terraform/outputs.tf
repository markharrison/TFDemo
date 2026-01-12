# Resource Group
output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "resource_group_id" {
  description = "ID of the resource group"
  value       = azurerm_resource_group.main.id
}

# Managed Identity
output "managed_identity_id" {
  description = "ID of the User-Assigned Managed Identity"
  value       = azurerm_user_assigned_identity.app.id
}

output "managed_identity_client_id" {
  description = "Client ID of the User-Assigned Managed Identity"
  value       = azurerm_user_assigned_identity.app.client_id
}

output "managed_identity_principal_id" {
  description = "Principal ID of the User-Assigned Managed Identity"
  value       = azurerm_user_assigned_identity.app.principal_id
}

# App Service
output "app_service_name" {
  description = "Name of the App Service"
  value       = azurerm_linux_web_app.main.name
}

output "app_service_url" {
  description = "URL of the App Service"
  value       = "https://${azurerm_linux_web_app.main.default_hostname}"
}

# Azure SQL
output "sql_server_name" {
  description = "Name of the SQL Server"
  value       = azurerm_mssql_server.main.name
}

output "sql_server_fqdn" {
  description = "Fully Qualified Domain Name of the SQL Server"
  value       = azurerm_mssql_server.main.fully_qualified_domain_name
}

output "sql_database_name" {
  description = "Name of the SQL Database"
  value       = azurerm_mssql_database.main.name
}

# Monitoring
output "log_analytics_workspace_id" {
  description = "ID of the Log Analytics Workspace"
  value       = azurerm_log_analytics_workspace.main.id
}

output "application_insights_connection_string" {
  description = "Connection string for Application Insights"
  value       = azurerm_application_insights.main.connection_string
  sensitive   = true
}

output "application_insights_instrumentation_key" {
  description = "Instrumentation key for Application Insights"
  value       = azurerm_application_insights.main.instrumentation_key
  sensitive   = true
}

# Azure OpenAI
output "openai_endpoint" {
  description = "Endpoint for Azure OpenAI"
  value       = azurerm_cognitive_account.openai.endpoint
}

output "openai_deployment_name" {
  description = "Name of the GPT-4o deployment"
  value       = azurerm_cognitive_deployment.gpt4o.name
}

# AI Search
output "ai_search_name" {
  description = "Name of the AI Search service"
  value       = azurerm_search_service.main.name
}

output "ai_search_endpoint" {
  description = "Endpoint for AI Search"
  value       = "https://${azurerm_search_service.main.name}.search.windows.net"
}
