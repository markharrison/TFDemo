variable "project_name" {
  type        = string
  description = "Base name for resources"
  default     = "tfdemo"
}

variable "environment" {
  type        = string
  description = "Environment name (e.g., dev, staging, prod)"
  default     = "dev"
}

variable "location" {
  type        = string
  description = "Primary Azure region for resources"
  default     = "UK South"
}

variable "openai_location" {
  type        = string
  description = "Azure region for OpenAI resources (must support GPT-4o)"
  default     = "Sweden Central"
}

variable "sql_admin_login" {
  type        = string
  description = "SQL Server administrator login name for Entra ID admin"
  default     = "sqladmin"
}

variable "sql_admin_object_id" {
  type        = string
  description = "Object ID of the Entra ID user/group to be SQL admin"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all resources"
  default = {
    Environment = "Development"
    ManagedBy   = "Terraform"
  }
}

variable "app_service_sku" {
  type        = string
  description = "App Service Plan SKU"
  default     = "S1"
}

variable "sql_sku" {
  type        = string
  description = "Azure SQL Database SKU name"
  default     = "Basic"
}

variable "ai_search_sku" {
  type        = string
  description = "Azure AI Search SKU"
  default     = "basic"
}

variable "log_retention_days" {
  type        = number
  description = "Number of days to retain logs in Log Analytics"
  default     = 30
}
