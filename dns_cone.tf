resource "azurerm_dns_zone" "cedi_dev_dns" {
  name                  = "cedi.dev"
  resource_group_name   = "${azurerm_resource_group.cedidev_rg.name}"
}

resource "azurerm_dns_txt_record" "example" {
  name      = "example"
  zone_name = "${azurerm_dns_zone.cedi_dev_dns.name}"
  resource_group_name   = "${azurerm_resource_group.cedidev_rg.name}"
  ttl = 300
  record {
      value = "test"
  }
  record {
      value = "test2"
  }
}