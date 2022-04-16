# Terraform + Libvirt

Terraform code to bring up VM's on a Libvirt host.

The Libvirt host can be either running locally or remotely.

Code uses [dmacvicar](https://registry.terraform.io/providers/dmacvicar/libvirt/latest/docs) libvirt Terraform provider.

Code automatically downloads the images specified in `pool_images_to_download`, onto the Libvirt host.

The selected cloud image in `cluster_node_base_image` will then be used as the base disk for guest VM(s).

Initial customizations on the guest VM(s) is done with cloudinit. See `terraform/templates/` folder.

Tested with the following guest OS:

- Debian 11
- Ubuntu 20.04
- Ubuntu 22.04

Guests can be configured with dhcp (`net_dhcp = true`) or static IP addresses (`net_dhcp = false`)

IPv6 support is out of scope for now.

See `config.auto.tfvars.example` file for simple example.

Once the VM's are up, you can further configure them using a tool such Ansible and its libvirt inventory plugin.

## TODO

- Configure DNS resolution on Libvirt host to resolve guest names
- Test using bridged libvirt network
- Extract components into terraform modules, so one can create disparate clusters for other projects.
- Provision VMs into something useful like K8s cluster
- Add small makefile for running things (ie. file ansible-playbook )
