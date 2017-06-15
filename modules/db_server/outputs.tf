output "public_ip" {
  value = ["${module.tomcat-server.public_ip}"]
}

output "private_ip" {
  value = ["${module.tomcat-server.private_ip}"]
}

output "ocid" {
  value = ["${module.tomcat-server.ocid}"]
}
