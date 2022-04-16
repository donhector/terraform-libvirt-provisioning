# Template for the meta-data configuration that will be passed to cloudinit
data "template_file" "cloudinit_meta_data" {
  count = var.cluster_node_count

  template = file("${path.module}/templates/cloud-init/meta-data.tftpl")
}

# Template for the user-data configuration that will be passed to cloudinit
data "template_file" "cloudinit_user_data" {
  count = var.cluster_node_count

  template = file("${path.module}/templates/cloud-init/user-data.tftpl")
  vars = {
    hostname            = "${var.cluster_prefix}${var.hostname}${count.index}"
    fqdn                = "${var.cluster_prefix}${var.hostname}${count.index}.${var.net_dns_domain}"
    username            = var.username
    password            = var.password
    groups              = var.groups
    package_upgrade     = var.package_upgrade
    ssh_authorized_keys = join(", ", var.ssh_authorized_keys)
    dhcp                = var.net_dhcp
  }
}

# Template for the network-config that will be passed to cloudinit
data "template_file" "cloudinit_network_config" {

  count = var.cluster_node_count

  template = file("${path.module}/templates/cloud-init/network-config.tftpl")
  vars = {
    dhcp = var.net_dhcp
    addresses = join(", ", [
      "${cidrhost(var.net_ipv4_cidr, 100 + count.index)}/${split("/", var.net_ipv4_cidr)[1]}"
    ])
    gateway4 = cidrhost(var.net_ipv4_cidr, 1)
    nameservers = join(", ", [
      cidrhost(var.net_ipv4_cidr, 1),
      "1.1.1.1"
    ])
    search = var.net_dns_domain
  }
}

# Create N number of ISOs with our rendered cloudinit configs baked in
# We will attach an iso to a VM during its creation
resource "libvirt_cloudinit_disk" "cloudinit_iso" {

  count = var.cluster_node_count

  name = "cloudinit-${count.index}.iso"
  pool = libvirt_pool.cluster.name

  meta_data      = data.template_file.cloudinit_meta_data[count.index].rendered
  user_data      = data.template_file.cloudinit_user_data[count.index].rendered
  network_config = data.template_file.cloudinit_network_config[count.index].rendered

}
