output "public_ip" {
  value = ["${baremetal_core_instance.mysql-server.public_ip}"]
}

output "private_ip" {
  value = ["${baremetal_core_instance.mysql-server.private_ip}"]
}

output "ocid" {
  value = ["${baremetal_core_instance.mysql-server.id}"]
}
