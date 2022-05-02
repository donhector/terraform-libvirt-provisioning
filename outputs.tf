# To get a specific output var, run `terraform output <varname>`
# In case not all data got populated, try with `terraform refresh`

output "pool_name" {
  value       = libvirt_pool.storage.name
  description = "Name of the libvirt pool that was created"
}

output "pool_path" {
  value       = libvirt_pool.storage.path
  description = "Name of the libvirt pool that was created"
}

output "networks" {
  value       = [for n in libvirt_network.networking : n.name]
  description = "Name of the libvirt networks that were created"
}

output "instances" {
  value       = [for d in libvirt_domain.domains : d.name]
  description = "Names of the instances that were created"
}
