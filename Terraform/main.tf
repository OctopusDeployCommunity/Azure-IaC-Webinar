terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "#{Azure.ResourceGroup.Name}"
    storage_account_name = "#{Azure.StorageAccount.Name}"
    container_name       = "#{Azure.StorageContainer.Name}"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}
resource "random_integer" "ri" {
  min = 1
  max = 99999
}
resource "azurerm_resource_group" "rg" {
  name     = "Azure-IaC-Terraform-${random_integer.ri.result}"
  location = "eastus"
}
resource "azurerm_app_service_plan" "appserviceplan" {
  name                = "Azure-IaC-Terraform-${random_integer.ri.result}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku {
    tier = "Free"
    size = "F1"
  }
}
resource "azurerm_app_service" "webapp" {
  name                = "Azure-IaC-Terraform-webapp-${random_integer.ri.result}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.appserviceplan.id
  source_control {
    repo_url           = "https://github.com/Azure-Samples/nodejs-docs-hello-world"
    branch             = "master"
    manual_integration = true
    use_mercurial      = false
  }
}