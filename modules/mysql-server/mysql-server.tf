resource "baremetal_core_instance" "mysql-server" {
  availability_domain = "${var.ad_name}"
  compartment_id = "${var.compartment_id}"
  display_name = "${var.display_name}"
  image = "${var.region == "us-phoenix-1" ? "ocid1.image.oc1.phx.aaaaaaaaqdyh2bhw35d4zftxqlmjtcqaz67hppkz5dg4azaz7ibj3panowgq" : "ocid1.image.oc1.iad.aaaaaaaa22rde66vbqx5cg7vllfzoyaux572dusbsgra4fy4yldu5a6iqbbq"}"
  shape = "${var.shape}"
  subnet_id = "${var.subnet}"
  metadata {
    ssh_authorized_keys = "${var.public_key}"
  }

  provisioner "chef"  {
    on_failure = "continue"
    attributes_json = <<-EOF
          {
            "database":{
              "root_password":"Welcome1#",
              "admin_password":"Welcome1#",
              "customer":"${var.customer}"
            }
          }
          EOF
    run_list = ["bmc_servers::default","bmc_servers::database_config"]
    node_name = "${var.server_display_name}"
    server_url = "https://api.chef.io/organizations/bmc_devops"
    recreate_client = true
    user_name = "bmc_devops-validator"
    user_key = "${file(var.chef_key)}"
    version = "13.0.113"
    connection {
      host = "${baremetal_core_instance.mysql-server.private_ip}"
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
