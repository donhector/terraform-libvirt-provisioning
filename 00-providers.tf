terraform {
  required_version = ">= 1.0.1"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt",
      version = ">= 0.6.14"
    }
  }

  # Enable declaring optional attributes. Very helpful for complex objects.
  # See https://www.terraform.io/language/expressions/type-constraints#experimental-optional-object-type-attributes
  # See https://github.com/hashicorp/terraform/issues/19898
  # Keep in mind this might break in the future
  experiments = [module_variable_optional_attrs]
}

provider "libvirt" {
  uri = "qemu+ssh://${var.libvirt_connection.user}@${var.libvirt_connection.host}/system"
}
