resource "baremetal_core_instance" "hol-server" {
  availability_domain = "${var.ad_name}"
  compartment_id = "${var.compartment_name}"
  display_name = "${var.server_display_name}"
  image_name = "${var.region == "us-phoenix-1" ? "ocid1.image.oc1.phx.aaaaaaaawcvuel67op5mvot77kfrtruywsxy6byvx7haac5b6uih45migqrq" : "ocid1.image.oc1.iad.aaaaaaaaqosg7kfw6a4usld7fkq4vwgoqkdmirvzmvapi4t3iftgwjeh5qrq"}"
  hostname_label = "${var.hostname}"
  shape = "${var.shape_name}"
  subnet_id = "${var.subnet_name}"
  metadata {
    ssh_authorized_keys = "${var.public_key}"
    user_data = "${base64encode(file("${var.cloud_init_file}"))}"
  }
}

data "baremetal_core_vnic_attachments" "vnics" {
  compartment_id = "${var.compartment_name}"
  availability_domain = "${var.ad_name}"
  instance_id = "${baremetal_core_instance.hol-server.id}"
}

data "baremetal_core_vnic" "vnic" {
  vnic_id = "${lookup(data.baremetal_core_vnic_attachments.vnics.vnic_attachments[0],"vnic_id")}"
}

resource "null_resource" "wait_for_application"{

   provisioner "remote-exec" {
        inline = [
        "while [ ! -f /tmp/signal ]; do sleep 2; done"
        ]
        connection {
          host = "${baremetal_core_instance.hol-server.private_ip_address}"
          type = "ssh"
          user = "oracle"
          private_key = "${file(var.devops_key)}"
          bastion_host = "${var.bastion_host}"
          bastion_private_key = "${file(var.bastion_private_key_path)}"
          bastion_user = "opc"
        }
    }
  }
