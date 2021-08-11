// Authentication Variables 
variable "vcenter_server" {
  type        = string
  description = "IP or DNS entry for vCenter Server for VM deployment and object lookup. Specified in secrets.tfvars"
}

variable "vcenter_username" {
  type        = string
  description = "Username used for authenticating to vCenter Server"
  default     = "administrator@vsphere.local"
}

variable "vcenter_password" {
  type        = string
  description = "Password used for authenticating to vCenter Server"
}