
resource "libvirt_domain" "node" {

  count = var.cluster_node_count

  name       = "${var.cluster_prefix}node${count.index}"
  vcpu       = var.vm_vcpu
  memory     = var.vm_memory
  running    = true
  autostart  = false
  qemu_agent = true
  cloudinit  = libvirt_cloudinit_disk.cloudinit_iso[count.index].id

  # NOTE: If q35 chipset is required for your experiments (ie: UEFI secure boot)
  # see https://github.com/dmacvicar/terraform-provider-libvirt/issues/667 to
  # workaround cloudinit ISO mounting IDE not supported issue

  disk {
    volume_id = libvirt_volume.disk[count.index].id
  }

  network_interface {
    network_id     = libvirt_network.network.id
    wait_for_lease = true
  }

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  console {
    type        = "pty"
    target_port = "1"
    target_type = "virtio"
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }

  timeouts {
    create = "3m"
  }

}
