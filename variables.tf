variable "vsphere_datacenter" {
  description = "Datacenter that contains hosts, networks, and storage that you want to deploy to."
  type        = string
}
variable "vsphere_datastore" {
  description = "Target datastore to deploy VMs to"
  type        = string
}

variable "vsphere_cluster" {
  description = "Target cluster or resource pool where you want to deploy VMs to"
  type        = string
}

variable "target_host" {
  description = "Specific host in the cluster to deploy objects to. Required by the provider for some reason"
  type        = string
}


variable "trunk_network_name" {
  description = "Trunk Port Group on the VDS"
  type        = string
}


variable "nested_host_config" {
  description = "Configuration data to configure the required virtual machines"
  type        = map(any)
}

