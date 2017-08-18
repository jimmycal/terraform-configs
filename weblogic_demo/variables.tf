#BMC Provider Configuration
variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}

variable "region" {
  description = "Region to create your instance, valid values are us-phoenix-1, or us-ashburn-1"
}

#SSH access to the server
variable "ssh_public_key" {
  description = "Public key to load onto a server during creation to allow for OPC user ssh access"
}

variable "ssh_private_key" {
  description = "Private key for terraform to use to ssh to the server for post creation instance configuration"
}

#Instance specific variables
variable "ad" {
  description = "Value of 1,2 or 3 expected to represent the AD your start your server instance in"
}

variable "shape_name" {
  description = "BMC server shape common name, find valid values in the BMC console drop down"
}

variable "image_name" {
  description = "BMC server image common name, find valid values in the BMC console drop down"
  default = "Oracle-Linux-7.3-2017.05.23-0"
}

variable "compartment_name" {
  description = "Compartment that the OMC managed server will be created in"
}

variable "server_display_name" {
  description = "Display name for your server instance"
}

variable "hostname" {
  description = "DNS hostname for your server instance"
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

variable "json_attributes" {
  description = "Path Chef recipe configuration attributes file"
}

variable "chef_recipes" {
  description = "List of recipes for Chef to run"
  type = "list"
}

variable "chef_server" {
  description = "URL for your chef server"
}

#Custom Environment Variables
variable "identifier" {
  description = "Environment Identifier"
}

variable "compute_scale" {
  description = "Number of Compute nodes to scale out/in to"
}