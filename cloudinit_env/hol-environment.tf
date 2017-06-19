resource "baremetal_core_instance" "hol-server" {
  count = "${var.scale}"
  availability_domain = "${lookup(module.bmc_resources.ads[var.ad - 1],"name")}"
  compartment_id = "${lookup(module.bmc_resources.compartments, var.compartment_name)}"
  display_name = "${var.identifier} ${count.index}"
  image = "${var.region == "us-phoenix-1" ? "ocid1.image.oc1.phx.aaaaaaaaqdyh2bhw35d4zftxqlmjtcqaz67hppkz5dg4azaz7ibj3panowgq" : "ocid1.image.oc1.iad.aaaaaaaa22rde66vbqx5cg7vllfzoyaux572dusbsgra4fy4yldu5a6iqbbq"}"
  hostname_label = "${var.identifier}-${count.index}"
  shape = "${var.shape_name}"
  subnet_id = "${baremetal_core_subnet.app-subnet-1.id}"
  metadata {
    ssh_authorized_keys = "${var.ssh_public_key}"
    user_data = "${base64encode(file("${var.cloud_init_file}"))}"
  }
  provisioner "remote-exec" {
    inline = [
      "while [ ! -f /tmp/signal ]; do sleep 2; done"
    ]
    connection {
      host = "${baremetal_core_instance.hol-server.public_ip}"
      type = "ssh"
      user = "opc"
      private_key =  "${file(var.ssh_private_key)}"
    }
  }
}