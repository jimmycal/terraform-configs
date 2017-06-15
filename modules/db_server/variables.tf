variable "compartment_name" {
 description = "Compartment to run server in"
}

variable "public_key" {
 description = "Public key to access the Server"
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

variable "devops_key" {
  description = "Private Key path to access the server"
  default = ""
}

variable "bastion_private_key_path" {
  description = "Path to Private Key to access bastion"
  default = ""
}
