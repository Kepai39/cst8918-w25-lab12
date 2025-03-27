terraform {
  required_version = ">= 1.1.0"

  required_providers {
    # Azure Resource Manager provider and version
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.50"
    }
  }

}

# Define providers and their config params
provider "azurerm" {
  # Leave the features block empty to accept all defaults
  features {}
}

variable "collegeId" {
  type        = string
  description = "Your college username. This will form the beginning of various resource names."
}

# Define the resource group
resource "azurerm_resource_group" "rg" {
  name     = "${var.collegeId}-githubactions-rg"
  location = var.region
}

resource "azurerm_storage_account" "terraform_state" {
  name                     = "${collegeId}githubactions"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
}

resource "azurerm_storage_container" "example" {
  name                  = "tfstate"
  resource_group_name   = azurerm_resource_group.rg.name
  storage_account_name  = azurerm_storage_account.terraform_state.name
  container_access_type = "private"
}