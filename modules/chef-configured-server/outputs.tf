output "public_ip" {
  value = ["${baremetal_core_instance.chef-server.public_ip}"]
}

output "private_ip" {
  value = ["${baremetal_core_instance.chef-server.private_ip}"]
}

output "ocid" {
  value = ["${baremetal_core_instance.chef-server.ocid}"]
}
