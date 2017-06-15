output "public_ip" {
  value = ["${baremetal_core_instance.tomcat-server.public_ip}"]
}

output "private_ip" {
  value = ["${baremetal_core_instance.tomcat-server.private_ip}"]
}

output "ocid" {
  value = ["${baremetal_core_instance.tomcat-server.id}"]
}
