output "public_ip" {
  value = ["${oci_core_instance.mysql-server.public_ip}"]
}

output "private_ip" {
  value = ["${oci_core_instance.mysql-server.private_ip}"]
}

output "ocid" {
  value = ["${oci_core_instance.mysql-server.id}"]
}
