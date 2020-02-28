resource "hcloud_server" "www" {
  name = "www"
  image = "debian-10"
  server_type = "cx11"
  datacenter = "fsn1-dc14"
  ssh_keys = local.ssh_defaultkeys
}

resource "hcloud_rdns" "www_v4" {
  server_id = hcloud_server.www.id
  ip_address = "${hcloud_server.www.ipv6_address}1"
  dns_ptr = "${hcloud_server.www.name}.${azurerm_dns_zone.cedi_dev_dns.name}"
}

resource "hcloud_rdns" "www_v6" {
  server_id = hcloud_server.www.id
  ip_address = hcloud_server.www.ipv4_address
  dns_ptr = "${hcloud_server.www.name}.${azurerm_dns_zone.cedi_dev_dns.name}"
}

resource "azurerm_dns_a_record" "www" {
  name                = hcloud_server.www.name
  zone_name           = azurerm_dns_zone.cedi_dev_dns.name
  resource_group_name = azurerm_resource_group.cedi_rg.name
  ttl                 = 300
  records             = [hcloud_server.www.ipv4_address]
}

resource "azurerm_dns_aaaa_record" "www" {
  name                = hcloud_server.www.name
  zone_name           = azurerm_dns_zone.cedi_dev_dns.name
  resource_group_name = azurerm_resource_group.cedi_rg.name
  ttl                 = 300
  records             = ["${hcloud_server.www.ipv6_address}1"]
}

resource "azurerm_dns_a_record" "www_default" {
  name                = "@"
  zone_name           = azurerm_dns_zone.cedi_dev_dns.name
  resource_group_name = azurerm_resource_group.cedi_rg.name
  ttl                 = 300
  records             = [hcloud_server.www.ipv4_address]
}

resource "azurerm_dns_aaaa_record" "www_default" {
  name                = "@"
  zone_name           = azurerm_dns_zone.cedi_dev_dns.name
  resource_group_name = azurerm_resource_group.cedi_rg.name
  ttl                 = 300
  records             = ["${hcloud_server.www.ipv6_address}1"]
}

resource "azurerm_dns_a_record" "www_default2" {
  name                = "*"
  zone_name           = azurerm_dns_zone.cedi_dev_dns.name
  resource_group_name = azurerm_resource_group.cedi_rg.name
  ttl                 = 300
  records             = [hcloud_server.www.ipv4_address]
}

resource "azurerm_dns_aaaa_record" "www_default2" {
  name                = "*"
  zone_name           = azurerm_dns_zone.cedi_dev_dns.name
  resource_group_name = azurerm_resource_group.cedi_rg.name
  ttl                 = 300
  records             = ["${hcloud_server.www.ipv6_address}1"]
}