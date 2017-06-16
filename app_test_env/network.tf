resource "baremetal_core_virtual_network" "vcn" {
  cidr_block = "10.0.0.0/16"
  compartment_id = "${lookup(module.bmc_resources.compartments, var.compartment_name)}"
  display_name = "${var.identifier}-test-Network"
  dns_label = "${var.identifier}"
}

resource "baremetal_core_internet_gateway" "internet-gateway" {
  compartment_id = "${lookup(module.bmc_resources.compartments, var.compartment_name)}"
  display_name = "Public-IG"
  vcn_id = "${baremetal_core_virtual_network.vcn.id}"
}

resource "baremetal_core_route_table" "route-table" {
  compartment_id = "${lookup(module.bmc_resources.compartments, var.compartment_name)}"
  vcn_id = "${baremetal_core_virtual_network.vcn.id}"
  display_name = "Public-RT"
  route_rules {
    cidr_block = "0.0.0.0/0"
    network_entity_id = "${baremetal_core_internet_gateway.internet-gateway.0.id}"
  }
}

resource "baremetal_core_dhcp_options" "bastion-dhcp" {
  compartment_id = "${lookup(module.bmc_resources.compartments, var.compartment_name)}"
  display_name = "bastion-dhcp"
  options {
    type = "DomainNameServer"
    server_type = "VcnLocalPlusInternet"
  }
  options {
    type = "SearchDomain"
    search_domain_names = ["bastion.${var.identifier}.oraclevcn.com"]
  }
  vcn_id = "${baremetal_core_virtual_network.vcn.id}"
}

resource "baremetal_core_dhcp_options" "app-dhcp" {
  compartment_id = "${lookup(module.bmc_resources.compartments, var.compartment_name)}"
  display_name = "app-dhcp"
  options {
    type = "DomainNameServer"
    server_type = "VcnLocalPlusInternet"
  }
  options {
    type = "SearchDomain"
    search_domain_names = ["app.${var.identifier}.oraclevcn.com"]
  }
  vcn_id = "${baremetal_core_virtual_network.vcn.id}"
}

resource "baremetal_core_dhcp_options" "db-dhcp" {
  compartment_id = "${lookup(module.bmc_resources.compartments, var.compartment_name)}"
  display_name = "db-dhcp"
  options {
    type = "DomainNameServer"
    server_type = "VcnLocalPlusInternet"
  }
  options {
    type = "SearchDomain"
    search_domain_names = ["db.${var.identifier}.oraclevcn.com"]
  }
  vcn_id = "${baremetal_core_virtual_network.vcn.id}"
}


resource "baremetal_core_security_list" "lb-sl" {
  compartment_id = "${lookup(module.bmc_resources.compartments, var.compartment_name)}"
  display_name = "LB-SL"
  vcn_id = "${baremetal_core_virtual_network.vcn.id}"
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol = "6"
  }
  ingress_security_rules =
  [{
    tcp_options {
      max = "8080"
      min = "8080"
    }
    protocol = "6"
    source= "0.0.0.0/0"
  }]
}

resource "baremetal_core_subnet" "lb-subnet-1" {
  availability_domain = "${lookup(module.bmc_resources.ads[var.ad - 1],"name")}"
  cidr_block = "${cidrsubnet("10.0.0.0/24",4,0)}"
  display_name = "LB-1"
  dns_label = "lb1"
  compartment_id = "${lookup(module.bmc_resources.compartments, var.compartment_name)}"
  vcn_id = "${baremetal_core_virtual_network.vcn.id}"
  route_table_id = "${baremetal_core_route_table.route-table.0.id}"
  security_list_ids = ["${baremetal_core_security_list.lb-sl.id}"]
  provisioner "local-exec"  {
    command = "sleep 10"
  }
}

resource "baremetal_core_subnet" "lb-subnet-2" {
  availability_domain = "${lookup(module.bmc_resources.ads[var.ad - 1],"name")}"
  cidr_block = "${cidrsubnet("10.0.0.0/24",4,1)}"
  display_name = "LB-2"
  dns_label = "lb2"
  compartment_id = "${lookup(module.bmc_resources.compartments, var.compartment_name)}"
  vcn_id = "${baremetal_core_virtual_network.vcn.id}"
  route_table_id = "${baremetal_core_route_table.route-table.0.id}"
  security_list_ids = ["${baremetal_core_security_list.lb-sl.id}"]
  provisioner "local-exec"  {
    command = "sleep 10"
  }
}

resource "baremetal_core_security_list" "bastion-sl" {
  compartment_id = "${lookup(module.bmc_resources.compartments, var.compartment_name)}"
  display_name = "BASTION-SL"
  vcn_id = "${baremetal_core_virtual_network.vcn.id}"
  egress_security_rules =
  [{
    destination = "0.0.0.0/0"
    protocol = "6"
  }]
  ingress_security_rules =
  [{
    tcp_options {
      max = "22"
      min = "22"
    }
    protocol = "6"
    source= "0.0.0.0/0"
  }]
}

resource "baremetal_core_subnet" "bastion-subnet" {
  availability_domain = "${lookup(module.bmc_resources.ads[var.ad - 1],"name")}"
  cidr_block = "${cidrsubnet("10.0.1.0/24",4,0)}"
  display_name = "BASTION"
  dns_label = "bastion"
  compartment_id = "${lookup(module.bmc_resources.compartments, var.compartment_name)}"
  vcn_id = "${baremetal_core_virtual_network.vcn.id}"
  route_table_id = "${baremetal_core_route_table.route-table.0.id}"
  security_list_ids = ["${baremetal_core_security_list.bastion-sl.id}"]
  dhcp_options_id = "${baremetal_core_dhcp_options.bastion-dhcp.id}"
  provisioner "local-exec"  {
    command = "sleep 10"
  }
}

resource "baremetal_core_security_list" "app-sl" {
  compartment_id = "${lookup(module.bmc_resources.compartments, var.compartment_name)}"
  display_name = "APP-SL"
  vcn_id = "${baremetal_core_virtual_network.vcn.id}"
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol = "6"
  }
  ingress_security_rules =
  [{
    tcp_options {
      max = "8080"
      min = "8080"
    }
    protocol = "6"
    source= "0.0.0.0/0"
  },
    {
      tcp_options {
        max = "22"
        min = "22"
      }
      protocol = "6"
      source= "10.0.1.0/24"
    }]
}

resource "baremetal_core_subnet" "app-subnet-1" {
  availability_domain = "${lookup(module.bmc_resources.ads[var.ad - 1],"name")}"
  cidr_block = "${cidrsubnet("10.0.2.0/24",4,0)}"
  display_name = "APP"
  dns_label = "app"
  compartment_id = "${lookup(module.bmc_resources.compartments, var.compartment_name)}"
  vcn_id = "${baremetal_core_virtual_network.vcn.id}"
  route_table_id = "${baremetal_core_route_table.route-table.0.id}"
  security_list_ids = ["${baremetal_core_security_list.app-sl.id}"]
  dhcp_options_id = "${baremetal_core_dhcp_options.app-dhcp.id}"

  provisioner "local-exec"  {
    command = "sleep 10"
  }
}


resource "baremetal_core_security_list" "db-sl" {
  compartment_id = "${lookup(module.bmc_resources.compartments, var.compartment_name)}"
  display_name = "DB-SL"
  vcn_id = "${baremetal_core_virtual_network.vcn.id}"
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol = "6"
  }
  ingress_security_rules =
  [{
    tcp_options {
      max = "3306"
      min = "3306"
    }
    protocol = "6"
    source= "10.0.2.0/24"
  },
    {
      tcp_options {
        max = "22"
        min = "22"
      }
      protocol = "6"
      source= "10.0.1.0/24"
    }]
}

resource "baremetal_core_subnet" "db-subnet-1" {
  availability_domain = "${lookup(module.bmc_resources.ads[var.ad - 1],"name")}"
  cidr_block = "${cidrsubnet("10.0.3.0/24",4,0)}"
  display_name = "DB"
  dns_label = "db"
  compartment_id = "${lookup(module.bmc_resources.compartments, var.compartment_name)}"
  vcn_id = "${baremetal_core_virtual_network.vcn.id}"
  route_table_id = "${baremetal_core_route_table.route-table.0.id}"
  security_list_ids = ["${baremetal_core_security_list.db-sl.id}"]
  dhcp_options_id = "${baremetal_core_dhcp_options.db-dhcp.id}"
  provisioner "local-exec"  {
    command = "sleep 10"
  }
}
