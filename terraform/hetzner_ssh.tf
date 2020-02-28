resource "hcloud_ssh_key" "cedi_work_rsa" {
  name = "cekienzl@MININT-PIOELF4 - RSA"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDWEmQXfUcuYam3H/8FpaGghu8xRLubSfreAJHsM32+k8+2x1yogMSTRYmnFVjew8WloSxlvUKLg7eJV9pm04TrKRbzRc+NJBXluFIm/zjPFuiO5xtXIyPbERvidOJgTxHQimXMS1L5zVFMOw+qN1RV3SBES+AllH+wrdk1kWI8WahTX7BtCboTQTZgCE7+zTf9EqvX74fNgaW9seuS/C8XwVxqxWhz4uvIJRKsWYgfbB6knEvo8Pb2EIDK3OCrHGPWBhyZSyIhCWDlT1uHhkKk2mtwy8eTJWjsFTGIh8+yisiIfsfx3bqQeGPYanNwue3WJWD30m09XZHUfbNWJtIp cekienzl@MININT-PIOELF4"
}

resource "hcloud_ssh_key" "cedi_work_ed25519" {
  name = "cekienzl@MININT-PIOELF4 - ED25519"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICzT1ZI/IHEbAu25JMFKx2WKEeeEUiwfPeJ9pVnz2SXm cekienzl@MININT-PIOELF4"
}

resource "hcloud_ssh_key" "cedi_surface_rsa" {
  name = "cekienzl@surface"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDDGLQLBYglEhIFfbL5nPae4GyXmACOF1Y5m15jmFNZTZTMOLF1mUR/+TCMGsrZA0hPsmv11uBpQo2P7iFQPv93zrw8FQAlNqQmgqcdu1P7Jkav/LBVZF/7BQdQVm0vcYrm6zE13tmQtMl+wNcBfgbqwXPyZ0Lyrg0+vIqEjwXDYgeHHHPQcWEMm2ean8dyXDkObP2xhzXzMcdf+bMyVk9dJna92W7bMsgKko9YvsIHJACOb8HpHeebx6Ekpwqd6rKDhIVgvm1CEWtPt4NMGlwUJ6LTTloxlUAqFv9Ktmj46j2et70jw6H0a0jEBp65ugBQlAtzysYdGaltqtcvXa4H cekienzl@surface"
}

resource "hcloud_ssh_key" "cedi_private" {
  name = "cedi@ivy"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDKP+YPlktlZUrjO5ZGC2aeeWKmo+/ryiqWoJhGdMKSUL0+w5hLP4IUEK7NW7pIQEeYmzdxqklQfZPMQ2P+EvCyCOb1l1T1YNxISAFu+BF3SmZVIRnix/UExutcxod2GXQMie65g6An+IWxMGnu6z7UIhL6AZtDHF0RuQuT9jGMd2uR3OcEVsXxeQnmTlCKM+Q4y/ngWSd0hRxWsWUTVCFxnQLItDhQP203inIZR2JIjWuAlsF6D5/PKezdN5vvofKpPm6jCa2mnKrjveQ8eeGQu0PqHMIrSrC+zZn8k5E+SQdxqoW5kbGzadskKqVAdcRwgojkYUrKbXJcYa0pivXF cedi@ivy"
}

locals {
    ssh_defaultkeys = [
        "${hcloud_ssh_key.cedi_work_rsa.id}", 
        "${hcloud_ssh_key.cedi_work_ed25519.id}", 
        "${hcloud_ssh_key.cedi_surface_rsa.id}", 
        "${hcloud_ssh_key.cedi_private.id}"
        ]
}
