terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstate"
    storage_account_name = "stlauratfstate"
    container_name       = "tfstate"
    key                  = "integrator.terraform.tfstate"
  }
}