output "public_ip" {
  value = ["${oci_core_instance.tomcat-server.public_ip}"]
}

output "private_ip" {
  value = ["${oci_core_instance.tomcat-server.private_ip}"]
}

output "ocid" {
  value = ["${oci_core_instance.tomcat-server.id}"]
}
