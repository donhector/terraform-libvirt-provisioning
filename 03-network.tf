### Create Libvirt networks
resource "libvirt_network" "networking" {

  for_each = var.networks

  name      = "${var.cluster_prefix}${each.key}"
  mode      = each.value.mode
  bridge    = each.value.bridge
  addresses = each.value.addresses
  domain    = each.value.mode == "bridge" ? null : each.value.domain
  autostart = true

  dynamic "dns" {

    for_each = each.value.dns == null ? [] : [each.value.dns]

    content {
      enabled    = dns.value.enabled
      local_only = dns.value.local_only

      dynamic "hosts" {

        # Only create host entries for those nodes with dhcp disabled in their nic (ie static IPs)
        # if dhcp is disabled, but no ip was explicitly provided, then we assign an autocalculated ip based on network address range, network offset and node number

        for_each = flatten([
          for node_key, node_value in var.nodes : [
            for nic_key, nic_value in node_value.nics : {
              ip       = try(nic_value.ips[0], cidrhost(each.value.addresses[0], each.value.offset + index(keys(var.nodes), node_key) + 1))
              hostname = "${var.cluster_prefix}${node_key}"
          } if nic_value.libvirt_network == each.key && nic_value.dhcp == false]
        ])

        content {
          ip       = hosts.value.ip
          hostname = hosts.value.hostname
        }


      }
    }
  }

  dynamic "dhcp" {

    for_each = each.value.dhcp == null ? [] : [each.value.dhcp]

    content {
      enabled = each.value.dhcp.enabled
    }
  }
}

locals {
  test = flatten([
    for node_key, node_value in var.nodes : [
      for nic_key, nic_value in node_value.nics : {
        ip       = nic_value.ips[0]
        hostname = node_key
    } if nic_value.libvirt_network == "cluster" && nic_value.ips != null]
  ])
}
