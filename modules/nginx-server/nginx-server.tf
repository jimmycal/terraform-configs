resource "baremetal_core_instance" "nginix_server" {
  availability_domain = "${var.ad_name}"
  compartment_id = "${var.compartment_name}"
  display_name = "${var.server_display_name}"
  image = "${var.region == "us-phoenix-1" ? "ocid1.image.oc1.phx.aaaaaaaawcvuel67op5mvot77kfrtruywsxy6byvx7haac5b6uih45migqrq" : "ocid1.image.oc1.iad.aaaaaaaaqosg7kfw6a4usld7fkq4vwgoqkdmirvzmvapi4t3iftgwjeh5qrq"}"
  shape = "${var.shape_name}"
  subnet_id = "${var.subnet_name}"
  hostname_label = "${var.hostname}"
  metadata {
    ssh_authorized_keys = "${file(var.ssh_public_key)}"
  }
  #You will need knife.rb in your current path in order for this command to complete successfully.
  provisioner "local-exec" {
    when = "destroy"
    on_failure = "continue" #This will hide errors, be careful
    command = "knife node delete ${var.chef_node_name}-${count.index} -y",
  }
}


resource "null_resource" "managed_server_instance_config"{
  count = "${var.manage_with_omc}"
  provisioner "chef"  {
          on_failure = "continue"
          attributes_json = <<-EOF
          {
           "env-omc":{
                "regkey":"RvnWiqoF63rVq2ZW9G09Gu4W0N"
            }
          }
          EOF
          run_list = ["bmc_servers::monitored_server","bmc_servers::docker_nginx"]
          node_name = "${var.chef_node_name}"
          server_url = "https://api.chef.io/organizations/bmc_devops"
          user_name = "${var.chef_user}"
          user_key = "${file(var.chef_key)}"
          connection {
            host = "${baremetal_core_instance.nginix_server.private_ip}"
            type = "ssh"
            user = "omc"
            private_key = "${file(var.ssh_private_key)}"
            bastion_host = "${var.bastion_host}"
            bastion_private_key = "${file(var.bastion_ssh_private_key)}"
            bastion_user = "opc"
          }
  }

}

resource "null_resource" "server_instance_config"{
  count = "${1 - var.manage_with_omc}"
  provisioner "chef"  {
    run_list = ["bmc_servers::docker_nginx"]
    node_name = "${var.chef_node_name}"
    server_url = "https://api.chef.io/organizations/bmc_devops"
    user_name = "${var.chef_user}"
    user_key = "${file(var.chef_key)}"
    connection {
      host = "${baremetal_core_instance.nginix_server.private_ip}"
      type = "ssh"
      user = "opc"
      private_key = "${file(var.ssh_private_key)}"
      bastion_host = "${var.bastion_host}"
      bastion_private_key = "${file(var.bastion_ssh_private_key)}"
      bastion_user = "opc"
    }
  }
}
