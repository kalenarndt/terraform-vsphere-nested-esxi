locals {
  # Deployment Details
  infra_deploy   = yamldecode(file("${path.module}/deploy_hosts.yaml"))

  # Nested Hosts
  parent_infra_details = local.infra_deploy.infra_config
  nested_host_config   = local.infra_deploy.nested_hosts
}

module "deploy_nested_hosts" {
  source             = "github.com/kalenarndt/terraform-vsphere-nested-esxi"
  for_each           = local.parent_infra_details
  vsphere_datacenter = each.value.vsphere_datacenter
  vsphere_datastore  = each.value.vsphere_datastore
  vsphere_cluster    = each.value.vsphere_cluster_root
  target_host        = each.value.target_host
  trunk_network_name = each.value.target_network
  nested_host_config = local.nested_host_config
}