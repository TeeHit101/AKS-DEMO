variable "location" {
  description = "The Azure region where resources will be deployed."
  type        = string
  default     = "swedencentral"
}

variable "github_user" {
  description = "The GitHub username for the repository."
  type        = string
  default     = "Teehit101"
}

variable "github_name" {
  description = "The name of the GitHub repository."
  type        = string
  default     = "AKS-DEMO"
}

variable "resource_group_name" {
  description = "The name of the Azure resource group."
  type        = string
  default     = "rg-terraform-bootstrap"
}