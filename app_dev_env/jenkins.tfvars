region = "us-ashburn-1"

#BMC Instance Variables
ad = 1
compartment_name = "DEMO"
image_name = "Oracle-Linux-7.5-2018.07.20-0"
server_display_name = "App"
hostname = "tf-app"
shape_name = "VM.Standard1.2"

#Chef Configuration Variables
chef_node_name = "jenkins_dev_tomcat"
chef_key = "/home/opc/keys/.chef/jcalise.pem"
chef_server = "https://api.chef.io/organizations/bmc_devops"
chef_user = "jcalise"

#Environment Specific Variables
identifier = "jenkins"
manage_with_omc = false

#SSH Access
ssh_private_key = "/home/opc/keys/.user/id_rsa"
ssh_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC0G5R0I21xfA0PyCFOI+TCRqSGtuEbAO9c7zRsE652jQ/LDGLS6uCL+U3eB4+e8FnnRF3A1IB9jPO7pLvhbL9nlD2PbOwqmWMp4W3a8xyjjHEcTaQ9Hc085GDtUki6hyW4+jtJ3GdK5Wp7liH438tND6EAdVeUcrt07/o99eKeDjtTd6R5AeL08JPW7OuEYLcYHH2ZkMyu795XuWAIQXeDMfbnLj6gcTgyftVZViGPoELO39Cl7g/JxVXsnNTCVtTa5CRRmaF/mKVcGuj+5fiTafx8CNh/6hkBm2hryBdTcSwGkiZgXs1GkOfmEEkk+61kNJbpHSo0FiBz1h4B91zD jamescalise@Jamess-MacBook-Pro.local"

fingerprint="dd:6f:5f:68:ce:bb:4c:cf:55:81:d0:2c:0e:7d:c3:08"
tenancy_ocid="ocid1.tenancy.oc1..aaaaaaaay7s6icq755xqlytpl33i7ysjzzb2kv3vk3itg5ilsxanrzqmsaha"
user_ocid="ocid1.user.oc1..aaaaaaaabdas4dyl47ie2p3mo5ro7h6dy6drdlvtpzhzaqmwh2cwigvhboma"
private_key_path="/home/opc/.oci/oci_api_key.pem"


