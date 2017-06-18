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


#Custom Environment Variables
variable "identifier" {
  description = "Environment Identifier"
}

variable "scale" {
  description = "Number of Serves to Scale out/in to"
}

variable "cloud_init_file" {
  description = "Instance Configuration Definition"
}
