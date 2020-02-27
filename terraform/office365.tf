resource "azurerm_dns_cname_record" "autodiscover" {
  name                = "autodiscover"
  zone_name           = azurerm_dns_zone.cedi_dev_dns.name
  resource_group_name = azurerm_resource_group.cedi_rg.name
  ttl                 = 3600
  record              = "autodiscover.outlook.com"

  tags = {
    Environment = "Production"
  }
}

resource "azurerm_dns_cname_record" "enterpriseenrollment" {
  name                = "enterpriseenrollment"
  zone_name           = azurerm_dns_zone.cedi_dev_dns.name
  resource_group_name = azurerm_resource_group.cedi_rg.name
  ttl                 = 3600
  record              = "enterpriseenrollment.manage.microsoft.com"

  tags = {
    Environment = "Production"
  }
}

resource "azurerm_dns_cname_record" "enterpriseregistration" {
  name                = "enterpriseregistration"
  zone_name           = azurerm_dns_zone.cedi_dev_dns.name
  resource_group_name = azurerm_resource_group.cedi_rg.name
  ttl                 = 3600
  record              = "enterpriseregistration.windows.net"

  tags = {
    Environment = "Production"
  }
}

resource "azurerm_dns_mx_record" "outlook_mx" {
  name                = "@"
  zone_name           = azurerm_dns_zone.cedi_dev_dns.name
  resource_group_name = azurerm_resource_group.cedi_rg.name
  ttl                 = 3600

  record {
    preference = 0
    exchange   = "cedi-dev.mail.protection.outlook.com"
  }

  tags = {
    Environment = "Production"
  }
}

resource "azurerm_dns_cname_record" "dkim_selector1" {
  name                = "selector1._domainkey"
  zone_name           = azurerm_dns_zone.cedi_dev_dns.name
  resource_group_name = azurerm_resource_group.cedi_rg.name
  ttl                 = 3600
  record              = "selector1-cedi-dev._domainkey.cedidev.onmicrosoft.com"

  tags = {
    Environment = "Production"
  }
}

resource "azurerm_dns_cname_record" "dkim_selector2" {
  name                = "selector2._domainkey"
  zone_name           = azurerm_dns_zone.cedi_dev_dns.name
  resource_group_name = azurerm_resource_group.cedi_rg.name
  ttl                 = 3600
  record              = "selector2-cedi-dev._domainkey.cedidev.onmicrosoft.com"

  tags = {
    Environment = "Production"
  }
}

resource "azurerm_dns_txt_record" "dmarc_record" {
  name                = "_dmarc.cedi.dev"
  zone_name           = azurerm_dns_zone.cedi_dev_dns.name
  resource_group_name = azurerm_resource_group.cedi_rg.name
  ttl                 = 3600
  record {
    value = "v=DMARC1; p=quarantine"
  }
  
  tags = {
    Environment = "Production"
  }
}