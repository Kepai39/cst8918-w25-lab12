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
    resource_group_name  = "daig0104-githubactions-rg"
    storage_account_name = "daig0104githubactions"
    container_name       = "tfstate"
    key                  = "prod.app.tfstate"
    use_oidc             = true
  }
}

# Define providers and their config params
provider "azurerm" {
  # Leave the features block empty to accept all default
  features {}
  use_oidc = true
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
  name     = "${var.collegeId}-a12-rg"
  location = var.region
  tags = {
    environment = "Production"
  }
}

# Define Vnet
resource "azurerm_virtual_network" "lab12" {
  name                = "lab12-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.lab12.location
  resource_group_name = azurerm_resource_group.lab12.name
}

# Define subnet
resource "azurerm_subnet" "lab12" {
  name                 = "lab12-subnet"
  resource_group_name  = azurerm_resource_group.lab12.name
  virtual_network_name = azurerm_virtual_network.lab12.name
  address_prefixes     = ["10.0.1.0/24"]
}

# outputs
output "resource_group_name" {
  description = "resource group name"
  value       = azurerm_resource_group.lab12.name
}