
# Null resource for scripting the download of cloud images on the kvm host
# By using a trigger it should only the image list is modified
resource "null_resource" "get_images" {

  triggers = {
    cloud_images = join(" ", var.pool_images_to_download)
  }

  connection {
    type        = "ssh"
    host        = var.libvirt_host
    user        = var.libvirt_user
    private_key = file(pathexpand("~/.ssh/id_ed25519"))
  }

  # Start image downloading on the kvm host
  provisioner "remote-exec" {
    inline = [
      "echo ${join(" ", var.pool_images_to_download)} | xargs -n 1 -P 8 wget --continue -N --directory-prefix ${local.pool_images_folder}"
    ]
  }
}

# Libvirt storage pool for storing our cluster volumes (ie: OS disks, cloudinit ISOs)
resource "libvirt_pool" "cluster" {
  name = local.pool_name
  type = "dir"
  path = local.pool_path

  depends_on = [
    null_resource.get_images
  ]
}
