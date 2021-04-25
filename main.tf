locals {
  vsphere_datacenter = var.vsphere_datacenter
  vsphere_datastore  = var.vsphere_datastore
  vsphere_cluster    = var.vsphere_cluster
  target_host        = var.target_host
  trunk_network_name = var.trunk_network_name
  nested_host_config = var.nested_host_config
}


data "vsphere_datacenter" "dc" {
  name = local.vsphere_datacenter
}

data "vsphere_datastore" "datastore" {
  name          = local.vsphere_datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_resource_pool" "compute_cluster" {
  name          = local.vsphere_cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_host" "target_host" {
  name          = local.target_host
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "trunk" {
  name          = local.trunk_network_name
  datacenter_id = data.vsphere_datacenter.dc.id
}


resource "vsphere_virtual_machine" "deploy" {
  for_each                   = local.nested_host_config
  name                       = each.value.name
  datastore_id               = data.vsphere_datastore.datastore.id
  resource_pool_id           = data.vsphere_resource_pool.compute_cluster.id
  datacenter_id              = data.vsphere_datacenter.dc.id
  num_cpus                   = each.value.num_cpus
  memory                     = each.value.memory
  host_system_id             = data.vsphere_host.target_host.id
  nested_hv_enabled          = each.value.nested_hv_enabled
  wait_for_guest_net_timeout = 0
  wait_for_guest_ip_timeout  = 0

  network_interface {
    network_id = data.vsphere_network.trunk.id
  }

  network_interface {
    network_id = data.vsphere_network.trunk.id
  }

  disk {
    label       = "os"
    unit_number = 0
    size        = each.value.os_size
  }

  disk {
    label       = "vsan1"
    unit_number = 1
    size        = each.value.vsan1_size
  }

  disk {
    label       = "vsan2"
    unit_number = 2
    size        = each.value.vsan2_size
  }

  ovf_deploy {
    local_ovf_path       = each.value.ovf_path
    ip_protocol          = "IPV4"
    ip_allocation_policy = "STATIC_MANUAL"
    disk_provisioning    = each.value.disk_provisioning
    ovf_network_map = {
      "Trunk-1" = data.vsphere_network.trunk.id
      "Trunk-2" = data.vsphere_network.trunk.id
    }
  }

  vapp {
    properties = {
      "guestinfo.hostname"  = each.value.name,
      "guestinfo.ipaddress" = each.value.ip_address,
      "guestinfo.netmask"   = each.value.netmask,
      "guestinfo.gateway"   = each.value.gateway,
      "guestinfo.vlan"      = each.value.vlan,
      "guestinfo.dns"       = each.value.dns,
      "guestinfo.domain"    = each.value.domain,
      "guestinfo.ntp"       = each.value.ntp,
      "guestinfo.password"  = each.value.password
    }
  }
  lifecycle {
    ignore_changes = [
      annotation,
      disk[0].io_share_count,
      disk[1].io_share_count,
      disk[2].io_share_count,
      vapp[0].properties,
    ]
  }
}

locals {
  nested_host_output = { for vm, vm_name in vsphere_virtual_machine.deploy : (vm_name.name) => vm_name }
}
