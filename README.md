
# Terraform Nested ESXi

This Terraform module creates multiple nested ESXi hosts in a VMware environment. This module allows for OVF based uploads and modification of the nested hosts during the time of deployment.


## Acknowledgements

 - [Based on module by Riverpoint Technology](https://github.com/rptcloud/terraform-vsphere-nestedesxi)

  
## Usage/Examples

```hcl
locals {
  # Deployment Details
  infra_deploy   = yamldecode(file("${path.module}/deploy_hosts.yaml"))

  # Nested Hosts
  parent_infra_details = local.infra_deploy.infra_config
  nested_host_config   = local.infra_deploy.nested_hosts
}

module "nested-esxi" {
  source             = "kalenarndt/nested-esxi/vsphere"
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
    vlan: "21"
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

  
!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_vsphere"></a> [vsphere](#requirement\_vsphere) | >=1.25.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_vsphere"></a> [vsphere](#provider\_vsphere) | >=1.25.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [vsphere_virtual_machine.deploy](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/resources/virtual_machine) | resource |
| [vsphere_datacenter.dc](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/data-sources/datacenter) | data source |
| [vsphere_datastore.datastore](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/data-sources/datastore) | data source |
| [vsphere_host.target_host](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/data-sources/host) | data source |
| [vsphere_network.trunk](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/data-sources/network) | data source |
| [vsphere_resource_pool.compute_cluster](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/data-sources/resource_pool) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_nested_host_config"></a> [nested\_host\_config](#input\_nested\_host\_config) | Configuration data to configure the required virtual machines | `map(any)` | n/a | yes |
| <a name="input_target_host"></a> [target\_host](#input\_target\_host) | Specific host in the cluster to deploy objects to. Required by the provider for some reason | `string` | n/a | yes |
| <a name="input_trunk_network_name"></a> [trunk\_network\_name](#input\_trunk\_network\_name) | Trunk Port Group on the VDS | `string` | n/a | yes |
| <a name="input_vsphere_cluster"></a> [vsphere\_cluster](#input\_vsphere\_cluster) | Target cluster or resource pool where you want to deploy VMs to | `string` | n/a | yes |
| <a name="input_vsphere_datacenter"></a> [vsphere\_datacenter](#input\_vsphere\_datacenter) | Datacenter that contains hosts, networks, and storage that you want to deploy to. | `string` | n/a | yes |
| <a name="input_vsphere_datastore"></a> [vsphere\_datastore](#input\_vsphere\_datastore) | Target datastore to deploy VMs to | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_nested_host_output"></a> [nested\_host\_output](#output\_nested\_host\_output) | n/a |
<!-- END_TF_DOCS -->