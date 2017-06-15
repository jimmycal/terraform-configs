
#Instance Provisioning Variables
variable "compartment_id" {
 description = "Compartment to access the server"
}

variable "public_key" {
 description = "Public key to access the server"
}

variable "shape" {
  description = "BMC shape OCID"
}

variable "image" {
  description = "BMC image OCID"
}
variable "ad_name" {
  description = "Availability Domain to run the server"
}

variable "subnet" {
  description = "Subnet to run the server in"
}

variable "display_name" {
  description = "Server Name"
}

#Instance Configuration Variables

variable "bastion_host" {
  description = "Host public IP to gain SSH access to this instance"
}

variable "host_private_key_path" {
  description = "Private Key path to access the server"
}

variable "bastion_private_key_path" {
  description = "Path to Private Key to access bastion"
}

variable "chef_key" {
  description = "Path to Private Key to access chef server"
}

variable "json-attributes" {
  description = "Chef recipe configuration attributes"
}


variable "chef-recipes" {
  description = "List of recipes for Chef to run"
  type = "list"
}