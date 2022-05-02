### Libvirt host connection details
variable "libvirt_connection" {
  description = "Libvirt host connection details"
  type = object({
    user            = string
    host            = string
    ssh_private_key = string
  })
}

### Cluster variables
variable "cluster_prefix" {
  description = "Prefix that will be used to name resources"
  type        = string
  default     = "dev-"
}

### OS image downloading variables
variable "download_os_images" {
  description = "Map of OS images that will be downloaded and their aliases"
  type        = map(string)
  default = {
    "ubuntu2004" = "https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img"
    "ubuntu2204" = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
    "debian11"   = "https://cloud.debian.org/images/cloud/bullseye/latest/debian-11-genericcloud-amd64.qcow2"
  }
}

# The idea is to download "gold" images into a common location (ie: default pool)
# and not into the pool that we will be creating. This allows destroying the created pool
# without destroying the downloaded images, so they could be used for other projects.
variable "download_destination" {
  description = "Folder where OS images files will be downloaded"
  type        = string
  default     = "/var/lib/libvirt/images/default"
}

### Storage pool variables
variable "pool_name" {
  description = "Libvirt storage pool name. This will be used to store the node disk(s) including cloudinit ISOs"
  type        = string
  default     = "storage"
}

variable "pool_location" {
  description = "Location where the new storage pool will be created"
  type        = string
  default     = "~/libvirt/pools"
}

### Libvirt networks 
variable "networks" {
  description = "Libvirt network(s) that will be created"
  type = map(object({
    mode      = string
    bridge    = optional(string)
    domain    = optional(string)
    addresses = optional(list(string))
    offset    = optional(number)
    dhcp = optional(object({
      enabled = optional(bool)
    }))
    dns = optional(object({
      enabled    = optional(bool)
      local_only = optional(bool)
    }))
  }))

  default = {
    "cluster" = {
      mode      = "nat"
      domain    = "home.lab"
      addresses = ["10.10.0.0/24"]
      offset    = 100
      dhcp = {
        enabled = true
      }
      dns = {
        enabled    = true
        local_only = true
      }
    }
  }
}

### Libvirt domains
variable "nodes" {
  description = "Domains to create and their characteristics"
  type = map(object({
    cpu    = number
    memory = number
    disk   = number
    extra_disks = optional(list(object({
      size  = number
      mount = optional(string) # If no mount is provided, disk will not be formatted
    })))
    os = string
    nics = optional(map(object({
      dhcp            = bool
      mac             = optional(string)
      ips             = optional(list(string))
      libvirt_network = string
    })))
    user_data = optional(object({
      username            = optional(string)
      password            = optional(string)
      groups              = optional(string)
      ssh_authorized_keys = optional(list(string))
    }))
    ansible_playbook = optional(string)
  }))
}


variable "default_user_data" {
  description = "Defaults for user-data variables"
  type = object({
    username            = string
    password            = string
    groups              = string
    ssh_authorized_keys = list(string)
  })
  default = {
    username            = "hector"
    password            = "$6$AX466qXBLm7JnBkn$JjRgUde0hbGh93.YfqZel5zv.fiVS5t2SJstgagB9hl/0V3mKv36XpN0Md03z.iri7XaqNYS3xJPOc5HoAlIS/"
    groups              = "users,sudo"
    ssh_authorized_keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBYOzTJoN5TImhjMTw9gYzYJiDIK5NHMAbJ8OXxvDX2W donhector"]
  }
}
