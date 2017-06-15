resource "baremetal_core_instance" "chef-server" {
  availability_domain = "${var.ad_name}"
  compartment_id = "${var.compartment_id}"
  display_name = "${var.display_name}"
  image = "${var.image}"
  shape = "${var.shape}"
  subnet_id = "${var.subnet}"
  metadata {
    ssh_authorized_keys = "${var.public_key}"
  }

  provisioner "chef"  {
    on_failure = "continue"
    attributes_json = "${var.json-attributes}"
    run_list = "${var.chef-recipes}"
    node_name = "${var.display_name}"
    server_url = "https://api.chef.io/organizations/bmc_devops"
    recreate_client = true
    user_name = "bmc_devops-validator"
    user_key = "${file(var.chef_key)}"
    version = "13.0.113"
    connection {
      host = "${baremetal_core_instance.chef-server.private_ip}"
      type = "ssh"
      user = "opc"
      private_key = "${file(var.devops_key)}"
      bastion_host = "${var.bastion_host}"
      bastion_private_key = "${file(var.bastion_private_key_path)}"
      bastion_user = "opc"
      timeout = "3m"
    }
  }
}
