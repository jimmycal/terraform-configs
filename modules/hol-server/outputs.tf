output "public_ip" {
  value = ["${module.hol-server.public_ip}"]
}

output "private_ip" {
  value = ["${module.hol-server.private_ip}"]
}

output "ocid" {
  value = ["${module.hol-server.ocid}"]
}
