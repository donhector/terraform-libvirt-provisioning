### Libvirt host variables
variable "libvirt_user" {
  type        = string
  description = "Libvirt server username"
  default     = "hector"
}

variable "libvirt_host" {
  type        = string
  description = "Libvirt server fqdn"
  default     = "xeon.lan"
}

locals {
  libvirt_provider_uri = "qemu+ssh://${var.libvirt_user}@${var.libvirt_host}/system"
}

### Cluster variables
variable "cluster_prefix" {
  type        = string
  description = "Prefix that will be used to identify resources"
  default     = "dev-"
}

variable "cluster_node_count" {
  type        = number
  description = "Number of nodes (vm) in the cluster"
  default     = 2
}

variable "cluster_node_base_image" {
  type        = string
  description = "OS disk image to use"
  default     = "debian-11-genericcloud-amd64.qcow2"
}

### Libvirt resource pool variables
variable "pool_location" {
  type        = string
  description = "Location where a new resource pool will be created"
  default     = "~/libvirt/pools"
}

variable "pool_images_folder" {
  type        = string
  description = "Default pool directory where original cloud images will be downloaded to."
  default     = "/var/lib/libvirt/images/default"
}

variable "pool_images_to_download" {
  type        = list(string)
  description = "List of cloud-image URLs"
  default = [
    "https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img",
    "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img",
    "https://cloud.debian.org/images/cloud/bullseye/latest/debian-11-genericcloud-amd64.qcow2"
  ]
}

# Local pool variables
locals {
  pool_name          = "${var.cluster_prefix}pool"
  pool_path          = "${pathexpand("${trimsuffix(var.pool_location, "/")}")}/${local.pool_name}"
  pool_images_folder = pathexpand("${trimsuffix(var.pool_images_folder, "/")}")
}

### Libvirt network variables
variable "net_mode" {
  type        = string
  description = "libvirt network mode"
  default     = "nat"

  validation {
    condition     = contains(["nat", "bridge", "route"], var.net_mode)
    error_message = "Invalid libvirt network mode."
  }
}

variable "net_bridge" {
  type        = string
  description = "Name of the bridge that will be used by the libvirt network"
  default     = null
}


variable "net_ipv4_cidr" {
  type        = string
  description = "IPv4 CIDR range to use for the VM cluster network"
  default     = "10.10.0.0/24"
}

variable "net_dns_domain" {
  type        = string
  description = "Local DNS domain to use for the VM cluster"
  default     = "home.lab"

  validation {
    condition     = length(var.net_dns_domain) != 0
    error_message = "Libvirt network DNS domain cannot be empty."
  }
}

variable "net_dhcp" {
  type        = bool
  description = "Whether to enable dhcp in the libvirt network"
  default     = true
}

### VM (aka 'domains' in libvirt) specs variables
variable "vm_vcpu" {
  type        = number
  description = "CPU quantity as integer number to allocate to the VM"
  default     = 1
}

variable "vm_memory" {
  type        = number
  description = "Memory quantity in MB to allocate to the VM"
  default     = 1024
}

variable "vm_disk_size" {
  type        = number
  description = "Disk size in GB to allocate to the VM"
  default     = 8
}

### Cloud Init vars
variable "hostname" {
  type        = string
  description = "Hostname to set on the node"
  default     = "node"
}

variable "username" {
  type        = string
  description = "Username to create in the nodes"
  default     = "tux"
}

variable "password" {
  type        = string
  description = "User password to use on the node"
  # Generated via: 'openssl passwd -6' Default is 'password'
  default = "$6$0MD.UgfenyrfSW0T$S4Rsg2sCBP8bIYofWQ6QYng95xOnDwpPpUWviV2rnl7QreIHs.5wF.GW6K.T1JtfdFYrPvupKwFYK0UXRLqft."
}

variable "groups" {
  type        = string
  description = "Groups the user belongs to in the node"
  default     = "users,adm,cdrom,sudo,dip,plugdev,lxd"
}

variable "ssh_authorized_keys" {
  type        = list(string)
  description = "SSH authorized keys"
  default = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBYOzTJoN5TImhjMTw9gYzYJiDIK5NHMAbJ8OXxvDX2W donhector@gmail.com"
  ]
}

variable "package_upgrade" {
  type        = bool
  description = "Whether to upgrade all packages on the node"
  default     = true
}

