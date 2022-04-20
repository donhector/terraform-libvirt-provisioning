resource "libvirt_network" "network" {

  name      = "${var.cluster_prefix}network"
  mode      = var.net_mode
  bridge    = var.net_bridge
  autostart = true

  domain    = var.net_dns_domain
  addresses = [var.net_ipv4_cidr]

  dns {
    enabled    = true
    local_only = true
  }

  dhcp {
    enabled = var.net_dhcp
  }
}
