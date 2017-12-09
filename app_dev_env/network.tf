resource "oci_core_virtual_network" "vcn" {
  cidr_block = "10.0.0.0/16"
  compartment_id = "${lookup(module.oci_resources.compartments, var.compartment_name)}"
  display_name = "${var.identifier}-dev-network"
  dns_label = "${var.identifier}"
}

resource "oci_core_internet_gateway" "internet-gateway" {
  compartment_id =  "${lookup(module.oci_resources.compartments, var.compartment_name)}"
  display_name = "Public-IG"
  vcn_id = "${oci_core_virtual_network.vcn.id}"
}

resource "oci_core_route_table" "route-table" {
  compartment_id = "${lookup(module.oci_resources.compartments, var.compartment_name)}"
  vcn_id = "${oci_core_virtual_network.vcn.id}"
  display_name = "Public-RT"
  route_rules {
    cidr_block = "0.0.0.0/0"
    network_entity_id = "${oci_core_internet_gateway.internet-gateway.0.id}"
  }
}

resource "oci_core_security_list" "bastion-sl" {
  compartment_id = "${lookup(module.oci_resources.compartments, var.compartment_name)}"
  display_name = "BASTION-SL"
  vcn_id = "${oci_core_virtual_network.vcn.id}"
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
  },
    {
      icmp_options {
        code = "4"
        type = "3"
      }
      protocol = "1"
      source= "0.0.0.0/0"
    }]
}

resource "oci_core_dhcp_options" "bastion-dhcp" {
  compartment_id = "${lookup(module.oci_resources.compartments, var.compartment_name)}"
  display_name = "bastion-dhcp"
  options {
    type = "DomainNameServer"
    server_type = "VcnLocalPlusInternet"
  }
  options {
    type = "SearchDomain"
    search_domain_names = ["bastion.${var.identifier}.oraclevcn.com"]
  }
  vcn_id = "${oci_core_virtual_network.vcn.id}"
}

resource "oci_core_subnet" "bastion-subnet" {
  availability_domain = "${lookup(module.oci_resources.ads[var.ad - 1],"name")}"
  cidr_block = "${cidrsubnet("10.0.1.0/24",4,0)}"
  display_name = "BASTION"
  dns_label = "bastion"
  dhcp_options_id = "${oci_core_dhcp_options.bastion-dhcp.id}"
  compartment_id = "${lookup(module.oci_resources.compartments, var.compartment_name)}"
  vcn_id = "${oci_core_virtual_network.vcn.id}"
  route_table_id = "${oci_core_route_table.route-table.0.id}"
  security_list_ids = ["${oci_core_security_list.bastion-sl.id}"]
  provisioner "local-exec"  {
    command = "sleep 10"
  }
}

resource "oci_core_security_list" "app-sl" {
  compartment_id = "${lookup(module.oci_resources.compartments, var.compartment_name)}"
  display_name = "APP-SL"
  vcn_id = "${oci_core_virtual_network.vcn.id}"
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol = "6"
  }
  ingress_security_rules =
  [{
    tcp_options {
      max = "80"
      min = "80"
    }     
    protocol = "6"
    source= "0.0.0.0/0"
  },
    {
      tcp_options {
        max = "7001"
        min = "7001"
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

resource "oci_core_dhcp_options" "app-dhcp" {
  compartment_id = "${lookup(module.oci_resources.compartments, var.compartment_name)}"
  display_name = "app-dhcp"
  options {
    type = "DomainNameServer"
    server_type = "VcnLocalPlusInternet"
  }
  options {
    type = "SearchDomain"
    search_domain_names = ["app.${var.identifier}.oraclevcn.com"]
  }
  vcn_id = "${oci_core_virtual_network.vcn.id}"
}

resource "oci_core_subnet" "app-subnet-1" {
  availability_domain = "${lookup(module.oci_resources.ads[var.ad - 1],"name")}"
  cidr_block = "${cidrsubnet("10.0.3.0/24",4,0)}"
  display_name = "APP"
  dns_label = "app"
  dhcp_options_id = "${oci_core_dhcp_options.app-dhcp.id}"
  compartment_id = "${lookup(module.oci_resources.compartments, var.compartment_name)}"
  vcn_id = "${oci_core_virtual_network.vcn.id}"
  route_table_id = "${oci_core_route_table.route-table.0.id}"
  security_list_ids = ["${oci_core_security_list.app-sl.id}"]
  provisioner "local-exec"  {
    command = "sleep 10"
  }
}