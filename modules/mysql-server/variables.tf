
#Instance Provisioning Variables
variable "compartment_name" {
 description = "Compartment to access the server"
}

variable "public_key" {
 description = "Public key to access the server"
}

variable "shape" {
  description = "BMC shape OCID"
}

variable "ad_name" {
  description = "Availability Domain to run the server"
}

variable "subnet_name" {
  description = "Subnet to run the server in"
}

variable "server_display_name" {
  description = "Server Name"
}

#Instance Configuration Variables
variable "manage_with_omc" {
  description = "Manage Server with OMC flag"
}

variable "customer" {
  description = "Chef DB configuration variable"
}

variable "bastion_host" {
  description = "Host public IP to gain SSH access to this instance"
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

variable "chef_key" {
  description = "Path to Private Key to access chef server"
  default = ""
}

variable "region" {
  description = "Region Deployment"
}