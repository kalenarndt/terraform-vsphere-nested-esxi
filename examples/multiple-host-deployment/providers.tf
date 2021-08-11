terraform {
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = ">=1.25.0"
    }
  }
}

provider "vsphere" {
  user                 = var.vcenter_username
  password             = var.vcenter_password
  vsphere_server       = var.vcenter_server
  allow_unverified_ssl = true
}