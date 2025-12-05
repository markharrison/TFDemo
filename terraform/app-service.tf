# App Service Plan - S1 Linux
resource "azurerm_service_plan" "main" {
  name                = "plan-${local.resource_prefix}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  os_type             = "Linux"
  sku_name            = var.app_service_sku
  tags                = var.tags
}

# App Service - .NET 8
resource "azurerm_linux_web_app" "main" {
  name                = "app-${local.resource_prefix}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  service_plan_id     = azurerm_service_plan.main.id
  tags                = var.tags

  https_only = true

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.app.id]
  }

  site_config {
    application_stack {
      dotnet_version = "8.0"
    }

    always_on           = true
    ftps_state          = "Disabled"
    http2_enabled       = true
    minimum_tls_version = "1.2"
  }

  app_settings = {
    "APPLICATIONINSIGHTS_CONNECTION_STRING" = azurerm_application_insights.main.connection_string
    "AZURE_CLIENT_ID"                       = azurerm_user_assigned_identity.app.client_id
  }
}
