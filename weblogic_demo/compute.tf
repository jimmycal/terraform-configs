resource "baremetal_core_instance" "instance" {
  count = "${var.compute_scale}"
  availability_domain = "${lookup(module.bmc_resources.ads[var.ad - 1],"name")}"
  compartment_id = "${lookup(module.bmc_resources.compartments, var.compartment_name)}"
  display_name = "${var.identifier}-${var.server_display_name}-${count.index}"
  image = "${lookup(module.bmc_resources.images, var.image_name)}"
  shape = "${var.shape_name}"
  subnet_id = "${baremetal_core_subnet.app-subnet-1.id}"
  # hostname_label = "${var.hostname}-${count.index}"
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

resource "baremetal_core_volume" "volume" {
  count = "${var.compute_scale}"
  availability_domain = "${lookup(module.bmc_resources.ads[var.ad - 1],"name")}"
  compartment_id = "${lookup(module.bmc_resources.compartments, var.compartment_name)}"
  display_name = "${var.identifier}-app_volume-${count.index}"
  size_in_mbs = "262144"
}

resource "baremetal_core_volume_attachment" "volume-attach" {

  count = "${var.compute_scale}"
  attachment_type = "iscsi"
  compartment_id = "${lookup(module.bmc_resources.compartments, var.compartment_name)}"
  instance_id = "${baremetal_core_instance.instance.*.id[count.index]}"
  volume_id = "${baremetal_core_volume.volume.*.id[count.index]}"
}


resource "null_resource" "chef" {
  count = "${var.compute_scale}"

  triggers {
    cluster_instance_ids = "${join(",", baremetal_core_instance.instance.*.id)}"
  }

  provisioner "chef" {
    attributes_json = <<-EOF
      {
        "volume": {
          "iqn": "${baremetal_core_volume_attachment.volume-attach.*.iqn[count.index]}",
          "ipv4":"${baremetal_core_volume_attachment.volume-attach.*.ipv4[count.index]}",
          "port":"${baremetal_core_volume_attachment.volume-attach.*.port[count.index]}",
          "path": "/u01"
        }
      }
    EOF
    run_list = ["bmc_servers::attach_volume","bmcwls::install-wls122", "bmcwls::create_domain"]
    node_name = "${var.chef_node_name}-${count.index}"
    server_url = "${var.chef_server}"
    user_name = "${var.chef_user}"
    recreate_client=true
    user_key = "${file(var.chef_key)}"
    connection {
      host = "${baremetal_core_instance.instance.*.public_ip[count.index]}"
      type = "ssh"
      user = "opc"
      private_key = "${file(var.ssh_private_key)}"
      timeout = "3m"
    }
  }

}

resource "baremetal_load_balancer_backend" "lb-be" {
  count = "${var.compute_scale}"
  load_balancer_id = "${baremetal_load_balancer.weblogic-lb.id}"
  backendset_name  = "${baremetal_load_balancer_backendset.weblogic-backend-set.id}"
  ip_address       = "${baremetal_core_instance.instance.*.private_ip[count.index]}"
  port             = 80
  backup           = false
  drain            = false
  offline          = false
  weight           = 1
}

