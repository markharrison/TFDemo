# User-assigned Managed Identity for password-less service-to-service authentication
resource "azurerm_user_assigned_identity" "app" {
  name                = "id-${local.resource_prefix}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tags                = var.tags
}
