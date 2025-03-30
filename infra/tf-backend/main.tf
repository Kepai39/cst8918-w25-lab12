terraform {
  # adding comment to test
  required_version = ">= 1.1.0"

  required_providers {
    # Azure Resource Manager provider and version
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.50"
    }
  }

}

# Define providers and their config params  sadasdasd
provider "azurerm" {
  # Leave the features block empty to accept all defaults
  features {}
}

variable "collegeId" {
  type        = string
  description = "Your college username. This will form the beginning of various resource names."
  default     = "daig0104"
}
variable "region" {
  type        = string
  description = "Region to deploy azure resources to."
  default     = "canadacentral"
}

# Define the resource group
resource "azurerm_resource_group" "lab12" {
  name     = "${var.collegeId}-githubactions-rg"
  location = var.region
}

resource "azurerm_storage_account" "lab12" {
  name                     = "${var.collegeId}githubactions"
  resource_group_name      = azurerm_resource_group.lab12.name
  location                 = azurerm_resource_group.lab12.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
}

resource "azurerm_storage_container" "lab12" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.lab12.name
  container_access_type = "private"
}

output "resource_group_name" {
  description = "resource group name"
  value       = azurerm_resource_group.lab12.name
}
output "storage_account_name" {
  description = "storage account name"
  value       = azurerm_storage_account.lab12.name
}
output "storage_container_name" {
  description = "storage container name"
  value       = azurerm_storage_container.lab12.name
}
output "primary_access_key" {
  description = "storage primary access key"
  value       = azurerm_storage_account.lab12.primary_access_key
  sensitive   = true
}
