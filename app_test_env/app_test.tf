resource "baremetal_core_instance" "bastion" {
  availability_domain = "${lookup(module.bmc_resources.ads[var.ad - 1],"name")}"
  compartment_id = "${lookup(module.bmc_resources.compartments, var.compartment_name)}"
  display_name = "${var.identifier} Bastion"
  image = "${lookup(module.bmc_resources.images, var.image_name)}"
  shape = "${var.shape_name}"
  subnet_id = "${baremetal_core_subnet.bastion-subnet.id}"
  hostname_label = "${var.identifier}-bastion"
  metadata {
    ssh_authorized_keys = "${var.ssh_public_key}"
  }
}

module "mysql-server" {
  source = "../modules/mysql-server"
  compartment_name =  "${lookup(module.bmc_resources.compartments, var.compartment_name)}"
  ad_name = "${lookup(module.bmc_resources.ads[var.ad - 1],"name")}"
  hostname = "${var.identifier}-test-mysql"
  server_display_name = "${var.identifier} Test MySql"
  shape_name = "${var.shape_name}"
  subnet_name = "${baremetal_core_subnet.db-subnet-1.id}"
  ssh_public_key = "${var.ssh_public_key}"
  manage_with_omc = "${var.manage_with_omc}"
  bastion_host="${baremetal_core_instance.bastion.public_ip}"
  bastion_ssh_private_key="${var.ssh_private_key}"
  ssh_private_key = "${var.ssh_private_key}"
  chef_user = "${var.chef_user}"
  chef_node_name = "${var.identifier}-test-mysql"
  chef_key = "${var.chef_key}"
  region = "${var.region}"
  customer = "${var.customer}"
}

module "tomcat-server" {
  source = "../modules/tomcat-server"
  compartment_name =  "${lookup(module.bmc_resources.compartments, var.compartment_name)}"
  ad_name = "${lookup(module.bmc_resources.ads[var.ad - 1],"name")}"
  hostname = "${var.identifier}-test-tomcat"
  server_display_name = "${var.identifier} Test Tomcat"
  shape_name = "${var.shape_name}"
  subnet_name = "${baremetal_core_subnet.app-subnet-1.id}"
  ssh_public_key = "${var.ssh_public_key}"
  manage_with_omc = "${var.manage_with_omc}"
  bastion_host="${baremetal_core_instance.bastion.public_ip}"
  bastion_ssh_private_key="${var.ssh_private_key}"
  ssh_private_key = "${var.ssh_private_key}"
  chef_user = "${var.chef_user}"
  chef_node_name = "${var.identifier}-test-tomcat"
  chef_key = "${var.chef_key}"
  region = "${var.region}"
}





