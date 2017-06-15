output "public_ip" {
  value = ["${module.mysql-server.public_ip}"]
}

output "private_ip" {
  value = ["${module.mysql-server.private_ip}"]
}

output "ocid" {
  value = ["${module.mysql-server.ocid}"]
}
