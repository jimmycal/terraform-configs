resource "oci_core_instance" "mysql-server" {
  availability_domain = "${var.ad_name}"
  compartment_id = "${var.compartment_name}"
  display_name = "${var.server_display_name}"
  image = "${var.region == "us-phoenix-1" ? "ocid1.image.oc1.phx.aaaaaaaawcvuel67op5mvot77kfrtruywsxy6byvx7haac5b6uih45migqrq" : "ocid1.image.oc1.iad.aaaaaaaaqosg7kfw6a4usld7fkq4vwgoqkdmirvzmvapi4t3iftgwjeh5qrq"}"
  shape = "${var.shape_name}"
  subnet_id = "${var.subnet_name}"
  hostname_label = "${var.hostname}"
  metadata {
    ssh_authorized_keys = "${var.ssh_public_key}"
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
    run_list = ["bmc_servers::mysql_install","bmc_servers::mysql_config"]
    node_name = "${var.chef_node_name}"
    server_url = "https://api.chef.io/organizations/bmc_devops"
    user_name = "${var.chef_user}"
    user_key = "${file(var.chef_key)}"
    recreate_client = true
    connection {
      host = "${oci_core_instance.mysql-server.private_ip}"
      type = "ssh"
      user = "opc"
      private_key = "${file(var.ssh_private_key)}"
      bastion_host = "${var.bastion_host}"
      bastion_private_key = "${file(var.bastion_ssh_private_key)}"
      bastion_user = "opc"
      timeout = "3m"
    }
  }

  #You will need knife.rb in your current path in order for this command to complete successfully.
  provisioner "local-exec" {
    when = "destroy"
    on_failure = "continue" #This will hide errors, be careful
    command = "knife node delete ${var.chef_node_name} -y",
  }
}
