provider "azurerm" {
}

terraform {
  backend "azurerm" {}
}

resource "azurerm_resource_group" "cedi_rg" {
  name     = "cedi_rg"
  location = "northeurope"
}
