output "resource_group_name" {
  value       = azurerm_resource_group.rg_bootstrap.name
  description = "Resursgruppen for din Terraform backend."
}

output "storage_account_name" {
  value       = azurerm_storage_account.tfstate_sa.name
  description = "Storage account-namnet for din Terraform backend."
}

output "storage_container_name" {
  value       = azurerm_storage_container.tfstate_container.name
  description = "Containernamnet for din Terraform state."
}

output "client_id" {
  value       = azuread_application.github_actions.application_id
  description = "Detta ar CLIENT_ID for GitHub Actions inloggning."
}

output "tenant_id" {
  value       = data.azurerm_subscription.current.tenant_id
  description = "Tenant ID for din Azure AD katalog."
}

output "subscription_id" {
  value       = data.azurerm_subscription.current.subscription_id
  description = "Detta ar SUBSCRIPTION_ID for din Azure-prenumeration."
}
