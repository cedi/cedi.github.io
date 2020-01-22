provider "azurerm" {
}

terraform {
    backend "azurerm" {}
}

resource "azurerm_resource_group" "cedidev_rg" {
  name = "${var.resource_group_name}"
  location = "${var.location}"
}
