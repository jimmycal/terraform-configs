output "public_ip" {
  value = "${baremetal_core_instance.nginix_server.public_ip}"
}

output "private_ip" {
  value = ["${baremetal_core_instance.nginix_server.private_ip}"]
}

output "ocid" {
  value = ["${baremetal_core_instance.nginix_server.ocid}"]
}
