locals {
  resource_prefix = "${var.project_name}-${var.environment}"
}

resource "azurerm_resource_group" "main" {
  name     = "rg-${local.resource_prefix}"
  location = var.location
  tags     = var.tags
}

data "azurerm_client_config" "current" {}
