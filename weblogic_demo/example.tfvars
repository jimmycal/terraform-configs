region = "us-ashburn-1"

#BMC Instance Variables
ad = 2
compartment_name = "DEMO"
image_name = "Oracle-Linux-7.3-2017.05.23-0"
server_display_name = "App"
hostname = "tf-app"
shape_name = "VM.Standard1.2"

#Chef Configuration Variables
chef_node_name = "tf_app_node"
chef_key = "/Users/jcalise/.chef/jcalise.pem"
chef_server = "https://api.chef.io/organizations/bmc_devops"
chef_user = "jcalise"

#Environment Specific Variables
identifier = "weblogic"
compute_scale = 1