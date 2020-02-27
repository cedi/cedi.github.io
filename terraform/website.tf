resource "hcloud_server" "web" {
  name = "cedi.dev"
  image = "debian-10"
  server_type = "cx11"
  datacenter = "fsn1-dc14"
}