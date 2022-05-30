# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  required_version = "= 1.2.1"
}

  backend "azurerm" {
    resource_group_name  = "#{Azure.ResourceGroup.Name}"
    storage_account_name = "#{Azure.StorageAccount.Name}"
    container_name       = "#{Azure.StorageContainer.Name}"
    key                  = "terraform.tfstate"
  }

provider "azurerm" {
  features {}
}
# Generate a random integer to create a globally unique name
resource "random_integer" "ri" {
  min = 1
  max = 99999
}
# Create the resource group
resource "azurerm_resource_group" "rg" {
  name     = "Azure-IaC-Terraform-${random_integer.ri.result}"
  location = "eastus"
}
# Create the Linux App Service Plan
resource "azurerm_app_service_plan" "appserviceplan" {
  name                = "Azure-IaC-Terraform-${random_integer.ri.result}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku {
    tier = "Free"
    size = "F1"
  }
}
# Create the web app, pass in the App Service Plan ID, and deploy code from a public GitHub repo
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