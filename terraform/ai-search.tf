# Azure AI Search (formerly Azure Cognitive Search)
resource "azurerm_search_service" "main" {
  name                = "srch-${local.resource_prefix}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = var.ai_search_sku
  tags                = var.tags

  identity {
    type = "SystemAssigned"
  }

  # Allow all networks for simplicity; restrict in production
  public_network_access_enabled = true
}
