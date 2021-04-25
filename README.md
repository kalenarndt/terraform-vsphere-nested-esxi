
# Terraform Nested ESXi

This Terraform module creates multiple nested ESXi hosts in a VMware environment. This module allows for OVF based uploads and modification of the nested hosts during the time of deployment.


## Acknowledgements

 - [Based on module by Riverpoint Technology](https://github.com/rptcloud/terraform-vsphere-nestedesxi)

  
## Usage/Examples

```hcl
locals {
  # Nested vCenter
  infra_deploy   = yamldecode(file("${path.module}/deploy_hosts.yaml"))

  # Nested Hosts
  parent_infra_details = local.infra_deploy.infra_config
  nested_host_config   = local.infra_deploy.nested_hosts
}

module "deploy_nested_hosts" {
  source             = "github.com/kalenarndt/terraform-nested-esxi"
  for_each           = local.parent_infra_details
  vsphere_datacenter = each.value.vsphere_datacenter
  vsphere_datastore  = each.value.vsphere_datastore
  vsphere_cluster    = each.value.vsphere_cluster_root
  target_host        = each.value.target_host
  trunk_network_name = each.value.target_network
  nested_host_config = local.nested_host_config
}
```

Ensure that you modify the deploy_hosts.yaml file to match the hosts that you would like to deploy_hosts as this is what the module uses to deploy and configure the nested hosts.

Place the deploy_hosts.yaml file where your main.tf file is in your deployment or modify the usage example for the path to your yaml

```yaml
nested_hosts:
  esxi1-sb:
    name: esxi1-sb.bmrf.io
    num_cpus: 6
    memory: 24576
    guest_id: vmkernel65Guest
    nested_hv_enabled: true
    ovf_path: /binaries/esxi/Nested_ESXi7.0u2_Appliance_Template_v1.ova
    network: ESXi-Trunk
    ip_address: "172.16.21.11"
    netmask: "255.255.255.0"
    gateway: "172.16.21.1"
    dns: "172.16.11.2"
    ntp: time.bmrf.io
    domain: bmrf.io  
    password: VMware123!
    ssh: true
    # size in GB
    os_size: 8
    vsan1_size: 50
    vsan2_size: 150
    disk_provisioning: thin

infra_config:
  parent_vcenter:
    vsphere_datacenter: Black Mesa
    vsphere_datastore: iSCSI-R5
    vsphere_cluster_root: Compute/Resources
    target_host: esxi2.bmrf.io
    target_network: ESXi-Trunk
```

  
## License

[MIT](https://choosealicense.com/licenses/mit/)

  