output "public_ip" {
  value = ["${module.weblogic-server.public_ip}"]
}

output "private_ip" {
  value = ["${module.weblogic-server.private_ip}"]
}

output "ocid" {
  value = ["${module.weblogic-server.ocid}"]
}
