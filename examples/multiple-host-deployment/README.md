# Multi-Host Example

This example can be used to deploy multiple hosts into a vSphere environment. Make sure that you modify the terraform.tfvars file to match your environment as well as the deploy_hosts.yaml file. 


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

Ensure that you modify the deploy_hosts.yaml file to match the hosts that you would like to deploy as this is what the module uses to deploy and configure the nested hosts.


### Additional information.

This configuration will deploy as many ESXi hosts as you have specified within the yaml definition. It will iterate through the map and provision each new host on a trunk port group. This assumes that you have already built one yourself (dvPortGroup or port group with vlans 0-4095 allowed). 

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_vsphere"></a> [vsphere](#requirement\_vsphere) | >=1.25.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_nested-esxi"></a> [nested-esxi](#module\_nested-esxi) | kalenarndt/nested-esxi/vsphere | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_vcenter_password"></a> [vcenter\_password](#input\_vcenter\_password) | Password used for authenticating to vCenter Server | `string` | n/a | yes |
| <a name="input_vcenter_server"></a> [vcenter\_server](#input\_vcenter\_server) | IP or DNS entry for vCenter Server for VM deployment and object lookup. Specified in secrets.tfvars | `string` | n/a | yes |
| <a name="input_vcenter_username"></a> [vcenter\_username](#input\_vcenter\_username) | Username used for authenticating to vCenter Server | `string` | `"administrator@vsphere.local"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->