resource "azurerm_dns_zone" "cedi_dev_dns" {
  name                = "cedi.dev"
  resource_group_name = azurerm_resource_group.cedi_rg.name
}

# Verification that my Domain really belongs to me
resource "azurerm_dns_txt_record" "spf_and_ms_verification" {
  name                = "@"
  zone_name           = azurerm_dns_zone.cedi_dev_dns.name
  resource_group_name = azurerm_resource_group.cedi_rg.name
  ttl                 = 3600
  record {
    value = "v=spf1 include:spf.protection.outlook.com -all"
  }
  record {
    value = "MS=ms38038929"
  }
  tags = {
    Environment = "Production"
  }
}
