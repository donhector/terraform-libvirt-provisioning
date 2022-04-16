# output "metadata" {
#   # run 'terraform refresh' if not populated
#   value       = libvirt_domain.node.*
#   description = "Info about the nodes that were created"
# }

output "nodes" {
  value       = libvirt_domain.node.*.name
  description = "Names of the nodes that were created"
}

output "ips" {
  value       = libvirt_domain.node.*.network_interface.0.addresses
  description = "IP addresses that were allocated"
}

output "nodes_ips" {
  value       = zipmap(libvirt_domain.node.*.name, libvirt_domain.node[*].network_interface.0.addresses.*)
  description = "Nodes with their IPs"
}
