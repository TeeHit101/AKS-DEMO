terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azuread" {}

# Datakällor för att hämta prenumeration och klient-id
data "azurerm_subscription" "current" {}
data "azurerm_client_config" "current" {}

# 1. Resursgrupp
resource "azurerm_resource_group" "rg_bootstrap" {
  name     = var.resource_group_name
  location = var.location
}

# 2. Slumpmässig sträng för Storage Account (måste vara globalt unikt)
resource "random_string" "storage_suffix" {
  length  = 6
  special = false
  upper   = false
}

# 3. Storage Account
resource "azurerm_storage_account" "tfstate_sa" {
  name                     = "sttfstate${random_string.storage_suffix.result}"
  resource_group_name      = azurerm_resource_group.rg_bootstrap.name
  location                 = azurerm_resource_group.rg_bootstrap.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  blob_properties {
    versioning_enabled = true
  }
}

# 4. Storage Container
resource "azurerm_storage_container" "tfstate_container" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.tfstate_sa.name
  container_access_type = "private"
}

# 5. Entra ID App Registrering för GitHub Actions
resource "azuread_application" "github_actions" {
  display_name = "app-github-actions-cicd"
}

# 6. Service Principal
resource "azuread_service_principal" "github_actions_sp" {
  application_id = azuread_application.github_actions.application_id
}

# 7. Federated Identity Credential (OIDC)
resource "azuread_application_federated_identity_credential" "github_actions_fed" {
  application_object_id = azuread_application.github_actions.object_id
  display_name          = "github-actions-oidc"
  description           = "Federated credential for GitHub Actions"
  audiences             = ["api://AzureADTokenExchange"]
  issuer                = "https://token.actions.githubusercontent.com"
  subject               = "repo:${var.github_user}/${var.github_name}:*"
}

# 8. Roll tilldelning (Contributor)
resource "azurerm_role_assignment" "github_actions_contributor" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.github_actions_sp.object_id
}