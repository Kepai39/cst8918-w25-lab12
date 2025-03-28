terraform {
  required_version = ">= 1.1.0"

  required_providers {
    # Azure Resource Manager provider and version
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.50"
    }
  }

  backend "azurerm" {
    resource_group_name  = "ehre0004-githubactions-rg"
    storage_account_name = "ehre0004githubactions1"
    container_name       = "tfstate"
    key                  = "prod.app.tfstate"
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
variable "region" {
  type        = string
  description = "Region to deploy azure resources to."
  default     = "canadacentral"
}

# Define the resource group
resource "azurerm_resource_group" "lab12" {
  name     = "${var.collegeId}-a12-rg"
  location = var.region
}

output "resource_group_name" {
  description = "resource group name"
  value       = azurerm_resource_group.lab12.name
}