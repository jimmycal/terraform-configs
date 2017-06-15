

module "tomcat-server" {
  source = "../base/server-config"
  compartment_name = "${var.compartment_name}"
  image_name = "ocid1.image.oc1.phx.aaaaaaaalik6vg357qookumocv7pv4p6brp2opssavp6jvgyp2deqepzblyq"
  ad_name = "${var.ad_name}"
  server_display_name = "${var.server_display_name}"
  hostname = "${var.hostname}"
  shape_name = "${var.shape_name}"
  subnet_name = "${var.subnet_name}"
  public_key = "${var.public_key}"
}

resource "null_resource" "server_instance_config"{

  provisioner "chef"  {
          attributes_json = <<-EOF
          {
            "set_fqdn":"${var.hostname}.omc"
          }
          EOF
          run_list = ["hostnames::default","bmc_servers::monitored_server","bmc_servers::monitored_helloworld_tomcat"]
          node_name = "${var.server_display_name}"
          server_url = "https://api.chef.io/organizations/bmc_devops"
          recreate_client = true
          user_name = "bmc_devops-validator"
          user_key = "${file("/Users/jcalise/Projects/DevOps/chef-repo/.chef/bmc_devops-validator.pem")}"
          version = "13.0.113"
          connection {
            host = "${module.tomcat-server.private_ip}"
            type = "ssh"
            user = "opc"
            private_key = "${file(var.devops_key)}"
            bastion_host = "${var.bastion_host}"
            bastion_private_key = "${file(var.bastion_private_key_path)}"
            bastion_user = "opc"
          }
  }
}
