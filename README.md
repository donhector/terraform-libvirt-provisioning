# Terraform + Libvirt

Terraform code to bring up VM's on a Libvirt host, which can be either running locally or remotely.

Code uses [dmacvicar](https://registry.terraform.io/providers/dmacvicar/libvirt/latest/docs) libvirt Terraform provider.

Code automatically downloads the images specified in `pool_images_to_download`, onto the Libvirt host `pool_images_folder`.

The selected cloud image in `cluster_node_base_image` will then be used as the base disk for guest VM(s).

Initial customizations on the guest VM(s) is carried out by cloudinit (via ISO disks). See `terraform/templates/` folder.

All disk resources created such guest OS disks and cloudinit ISO's are created inside a dedicated libvirt resource pool backed by the `pool_location`directory.

A dedicated libvirt network is also created. `net_mode` controls whether the network will be in `nat`, `bridge` or `route` mode. Default is `nat`

Bridge name to use can also be specified in `net_bridge` when required. By default is `null` which means don't provide it unless one is explicitly set.

Libvirt network can be configured to use dhcp (`net_dhcp = true`, which is the default) or not (`net_dhcp = false`).

When `net_dhcp` is `false`, the network interface on the guest will be configured using static IPs.

IPv6 support is out of scope for now.

See `config.auto.tfvars.example` file for simple working example.

Once the VM's are up, you can further configure them using a tool such Ansible and its libvirt inventory plugin.

## TODO

- Configure DNS resolution on Libvirt host to resolve guest names
- Test using bridged libvirt network
- Extract components into terraform modules, so one can create disparate clusters for other projects.
- Provision VMs into something useful like K8s cluster
- Add small makefile for running things (ie. file ansible-playbook )
