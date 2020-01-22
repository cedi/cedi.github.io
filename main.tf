provider "azurerm" {
}

resource "azurerm_resource_group" "cedidev_rg" {
  name = "cedi_dev"
  location = "northeurope"
}
