variable "compartment_name" {
  description = "Compartment to run server in"
}


variable "region" {
  description = "Region Deployment"
}

#SSH access to the server
variable "ssh_public_key" {
  description = "Public key to load onto a server during creation to allow for OPC user ssh access"
}

variable "ssh_private_key" {
  description = "Private key for terraform to use to ssh to the server for post creation instance configuration"
}

variable "shape_name" {
  description = "BMC Shape IDs"
}

variable "ad_name" {
  description = "BMC Availability Domains"
}

variable "subnet_name" {
  description = "Network Subnets"
}

variable "server_display_name" {
  description = "Server Name"
}

variable "hostname" {
  description = "Server hostname label"
}


variable "manage_with_omc" {
  description = "Manage Server with OMC flag"
}

variable "cloud_init_file" {
  description = "User provided Cloud Init"
  default = ""
}

variable "bastion_host" {
  description = "Bastion Host Public IP"
  default = ""
}
variable "bastion_ssh_private_key" {
  description = "Path to Private Key to access bastion"
  default = ""
}

#Chef Configuration Variables
variable "chef_user" {
  description = "User name to access your Chef server"
}
variable "chef_key" {
  description = "Path to Private Key for your chef_user to access Chef server"
}

variable "chef_node_name" {
  description = "Chef Server Node Name, must be unique"
}


