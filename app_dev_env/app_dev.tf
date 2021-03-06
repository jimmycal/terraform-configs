resource "oci_core_instance" "bastion" {
  availability_domain = "${lookup(module.oci_resources.ads[var.ad - 1],"name")}"
  compartment_id = "${lookup(module.oci_resources.compartments, var.compartment_name)}"
  display_name = "${var.identifier} Dev Bastion"
  image = "${lookup(module.oci_resources.images, var.image_name)}"
  shape = "${var.shape_name}"
  subnet_id = "${oci_core_subnet.bastion-subnet.id}"
  hostname_label = "${var.identifier}-bastion"
  metadata {
    ssh_authorized_keys = "${var.ssh_public_key}"
  }
}

module "tomcat-server" {
  source = "../modules/tomcat-server"
  compartment_name =  "${lookup(module.oci_resources.compartments, var.compartment_name)}"
  ad_name = "${lookup(module.oci_resources.ads[var.ad - 1],"name")}"
  hostname = "${var.identifier}-tomcat"
  server_display_name = "${var.identifier} Dev Tomcat"
  shape_name = "${var.shape_name}"
  subnet_name = "${oci_core_subnet.app-subnet-1.id}"
  ssh_public_key = "${var.ssh_public_key}"
  manage_with_omc = "${var.manage_with_omc}"
  bastion_host="${oci_core_instance.bastion.public_ip}"
  bastion_ssh_private_key="${var.ssh_private_key}"
  ssh_private_key = "${var.ssh_private_key}"
  chef_user = "${var.chef_user}"
  chef_node_name = "${var.identifier}-dev-tomcat"
  chef_key = "${var.chef_key}"
  region = "${var.region}"
}