provider "azurerm" {
  version = "=2.0.0"
  subscription_id = var.az_subscription_id
  client_id = var.az_client_id
  client_secret = var.az_client_secret
  tenant_id = var.az_tenant_id
  features {}
}

provider "hcloud" {
  token = var.hcloud_token
}

terraform {
  backend "azurerm" { }
}

resource "azurerm_resource_group" "cedi_rg" {
  name     = "cedi_rg"
  location = "northeurope"
}
