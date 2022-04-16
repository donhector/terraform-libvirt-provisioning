# Volume that will be attached to vms as their main disk
# if no size is provided, it takes the one from the base image
# if size is provided and bigger than one from base image, then
# we have to grow it via cloud-init's growpart.
# See https://registry.terraform.io/providers/dmacvicar/libvirt/latest/docs/resources/volume#size
# 
# We rely on using an existing volume in the default pool as the base for our disk image
# The null_resource in pool.tf ensures that the appropriate "gold" images will be present in the default pool.
# The idea is to keep gold images in the default pool, and cluster's disk / cloudinit iso images
# in the purposely created cluster pool. This also helps during the cleanup, so we can safely wipe
# the cluster's pool while retaining the golden images for future deployments. This helps in 
# avoiding unnecessary re-downloads of gold images.

# NOTE: Since we want to be able to execute terraform against a remote libvirt server,
# we need to use "base_volume_name" instead of first creating a base 'libvirt_volume' and then 
# referencing that base 'libvirt_volume' with 'base_volume_id'. The problem is that the 'source'
# field in the base volume would look for a file on the host running terraform and then transfer
# the image to the remote server. It's a much better approach to do everything directly on the remote,
# hence the use of 'base_volume_name' vs 'base_volume_id'

resource "libvirt_volume" "disk" {

  count = var.cluster_node_count

  base_volume_pool = "default"
  base_volume_name = var.cluster_node_base_image

  name   = "node${count.index}.qcow2"
  size   = 1024 * 1024 * 1024 * var.vm_disk_size
  format = "qcow2"
  pool   = libvirt_pool.cluster.name

}
