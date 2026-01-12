# TFDemo

Terraform Infrastructure as Code (IaC) for Azure resources with GitHub Actions CI/CD.

## Overview

This repository contains Terraform configurations to deploy the following Azure infrastructure:

- **Managed Identity**: User-assigned identity for password-less service-to-service authentication
- **App Service**: S1 Linux plan with .NET 8 runtime (UK South)
- **Azure SQL**: Entra ID-only authentication (no SQL passwords), Basic tier
- **Monitoring**: Log Analytics + Application Insights with diagnostic settings for App Service and SQL
- **GenAI Services**:
  - Azure OpenAI with GPT-4o deployment (Sweden Central)
  - Azure AI Search (Basic tier)

## Prerequisites

- Azure subscription
- GitHub repository
- Azure CLI installed (for OIDC setup)
- Terraform >= 1.0

## Repository Structure

```
├── .github/
│   └── workflows/
│       ├── deploy-infrastructure.yml    # Deploy infrastructure workflow
│       └── delete-infrastructure.yml    # Delete infrastructure workflow
├── terraform/
│   ├── providers.tf                     # Provider configuration
│   ├── main.tf                          # Main configuration and resource group
│   ├── variables.tf                     # Input variables
│   ├── outputs.tf                       # Output values
│   ├── managed-identity.tf              # User-assigned managed identity
│   ├── app-service.tf                   # App Service Plan and Web App
│   ├── sql.tf                           # Azure SQL Server and Database
│   ├── monitoring.tf                    # Log Analytics, App Insights, diagnostics
│   ├── openai.tf                        # Azure OpenAI and GPT-4o deployment
│   ├── ai-search.tf                     # Azure AI Search service
│   └── terraform.tfvars.example         # Example variable values
└── README.md
```

## Setting Up OIDC Trust Between GitHub and Azure

GitHub Actions can authenticate to Azure using OpenID Connect (OIDC), which eliminates the need to store long-lived credentials as secrets.

### Step 1: Create an Azure AD Application and Service Principal

```bash
# Login to Azure
az login

# Set your subscription
az account set --subscription "<your-subscription-id>"

# Create an Azure AD application
az ad app create --display-name "GitHub-TFDemo-OIDC"

# Note the appId from the output, then create a service principal
az ad sp create --id <app-id>
```

### Step 2: Configure Federated Credentials

```bash
# Get the application object ID
APP_OBJECT_ID=$(az ad app show --id <app-id> --query id -o tsv)

# Create federated credential for the main branch
az ad app federated-credential create \
  --id $APP_OBJECT_ID \
  --parameters '{
    "name": "github-main-branch",
    "issuer": "https://token.actions.githubusercontent.com",
    "subject": "repo:<owner>/<repo>:ref:refs/heads/main",
    "audiences": ["api://AzureADTokenExchange"]
  }'

# Create federated credential for environment (e.g., dev)
az ad app federated-credential create \
  --id $APP_OBJECT_ID \
  --parameters '{
    "name": "github-dev-environment",
    "issuer": "https://token.actions.githubusercontent.com",
    "subject": "repo:<owner>/<repo>:environment:dev",
    "audiences": ["api://AzureADTokenExchange"]
  }'

# Repeat for other environments (staging, prod) as needed
```

### Step 3: Grant Azure Permissions

```bash
# Get the service principal object ID
SP_OBJECT_ID=$(az ad sp show --id <app-id> --query id -o tsv)

# Assign Contributor role to the subscription (or specific resource group)
az role assignment create \
  --assignee-object-id $SP_OBJECT_ID \
  --assignee-principal-type ServicePrincipal \
  --role "Contributor" \
  --scope "/subscriptions/<subscription-id>"

# For OpenAI resources, you may also need:
az role assignment create \
  --assignee-object-id $SP_OBJECT_ID \
  --assignee-principal-type ServicePrincipal \
  --role "Cognitive Services Contributor" \
  --scope "/subscriptions/<subscription-id>"
```

### Step 4: Configure GitHub Secrets

In your GitHub repository, go to **Settings > Secrets and variables > Actions** and add:

| Secret Name | Description |
|-------------|-------------|
| `AZURE_CLIENT_ID` | Application (client) ID of the Azure AD app |
| `AZURE_SUBSCRIPTION_ID` | Your Azure subscription ID |
| `AZURE_TENANT_ID` | Your Azure AD tenant ID |
| `SQL_ADMIN_OBJECT_ID` | Object ID of the Entra ID user/group to be SQL admin |

### Step 5: Create GitHub Environments

1. Go to **Settings > Environments**
2. Create environments: `dev`, `staging`, `prod`
3. (Optional) Configure protection rules for production environment

## Usage

### Deploying Infrastructure

1. Go to **Actions** tab in GitHub
2. Select **Deploy Infrastructure** workflow
3. Click **Run workflow**
4. Select the environment and optionally override locations
5. Click **Run workflow** to start deployment

### Deleting Infrastructure

1. Go to **Actions** tab in GitHub
2. Select **Delete Infrastructure** workflow
3. Click **Run workflow**
4. Select the environment to delete
5. Type `DELETE` in the confirmation field
6. Click **Run workflow** to destroy resources

### Local Development

```bash
# Navigate to terraform directory
cd terraform

# Copy example variables
cp terraform.tfvars.example terraform.tfvars

# Edit terraform.tfvars with your values
# Make sure to set sql_admin_object_id

# Login to Azure
az login

# Initialize Terraform
terraform init

# Plan changes
terraform plan

# Apply changes
terraform apply
```

## Configuration Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `project_name` | Base name for resources | `tfdemo` |
| `environment` | Environment name | `dev` |
| `location` | Primary Azure region | `UK South` |
| `openai_location` | Region for OpenAI (must support GPT-4o) | `Sweden Central` |
| `sql_admin_login` | SQL admin login name | `sqladmin` |
| `sql_admin_object_id` | Object ID of Entra ID admin | *Required* |
| `app_service_sku` | App Service Plan SKU | `S1` |
| `sql_sku` | SQL Database SKU | `Basic` |
| `ai_search_sku` | AI Search SKU | `basic` |
| `log_retention_days` | Log retention period | `30` |

## Security Notes

- All authentication uses Entra ID (Azure AD) - no SQL passwords are stored
- The managed identity enables password-less service-to-service communication
- OIDC federation eliminates the need for stored Azure credentials in GitHub
- TLS 1.2 minimum is enforced on all services
- FTPS is disabled on App Service (use Azure deployment mechanisms)

## License

See [LICENSE](LICENSE) for details.