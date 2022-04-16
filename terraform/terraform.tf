
terraform {
  required_version = ">= 1.0.1"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt",
      version = "0.6.14"
    }
  }
}

provider "libvirt" {
  uri = local.libvirt_provider_uri
}
