resource "oci_core_virtual_network" "pdns_vcn" {
  cidr_block     = var.oci_cidr_vcn
  dns_label      = "pdnsvcn"
  compartment_id = var.oci_compartment_ocid
  display_name   = "pdns-vcn"
}

resource "oci_core_subnet" "dns_forward_subnet" {
  cidr_block        = var.oci_cidr_forward_subnet
  compartment_id    = var.oci_compartment_ocid
  vcn_id            = oci_core_virtual_network.pdns_vcn.id
  display_name      = "dns-forward-subnet"
  dns_label         = "dnsfwsubnet"
  security_list_ids = [oci_core_security_list.pdns_sl.id]
}

resource "oci_core_subnet" "private_subnet" {
  cidr_block        = var.oci_cidr_private_subnet
  compartment_id    = var.oci_compartment_ocid
  vcn_id            = oci_core_virtual_network.pdns_vcn.id
  display_name      = "private-subnet"
  dns_label         = "privsubnet"
  dhcp_options_id   = oci_core_dhcp_options.pdns_dhcp_options.id
  security_list_ids = [oci_core_security_list.private_sl.id]
}

resource "oci_core_subnet" "public_subnet" {
  cidr_block      = var.oci_cidr_public_subnet
  compartment_id  = var.oci_compartment_ocid
  vcn_id          = oci_core_virtual_network.pdns_vcn.id
  display_name    = "public-subnet"
  dns_label       = "pubsubnet"
  dhcp_options_id = oci_core_dhcp_options.pdns_dhcp_options.id
}

resource "oci_core_internet_gateway" "pdns_igw" {
  display_name   = "pdns-internet-gateway"
  compartment_id = var.oci_compartment_ocid
  vcn_id         = oci_core_virtual_network.pdns_vcn.id
}

resource "oci_core_default_route_table" "default_route_table" {
  manage_default_resource_id = oci_core_virtual_network.pdns_vcn.default_route_table_id

  route_rules {
    network_entity_id = oci_core_internet_gateway.pdns_igw.id
    destination       = "0.0.0.0/0"
  }
}

resource "oci_core_security_list" "pdns_sl" {
  compartment_id = var.oci_compartment_ocid
  vcn_id         = oci_core_virtual_network.pdns_vcn.id
  display_name   = "pdns-security-list"

  ingress_security_rules {
    source   = "0.0.0.0/0"
    protocol = "1"
  }

  ingress_security_rules {
    source   = "0.0.0.0/0"
    protocol = "6"

    tcp_options {
      min = "22"
      max = "22"
    }
  }

  ingress_security_rules {
    source   = var.oci_cidr_vcn
    protocol = "6"

    tcp_options {
      min = "53"
      max = "53"
    }
  }

  ingress_security_rules {
    source   = var.oci_cidr_vcn
    protocol = "17"

    udp_options {
      min = "53"
      max = "53"
    }
  }

  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
  }
}

resource "oci_core_security_list" "private_sl" {
  compartment_id = var.oci_compartment_ocid
  vcn_id         = oci_core_virtual_network.pdns_vcn.id
  display_name   = "private-security-list"

  ingress_security_rules {
    source   = "10.0.0.0/16"
    protocol = "1"
  }

  ingress_security_rules {
    source   = "10.0.0.0/16"
    protocol = "6"

    tcp_options {
      min = "22"
      max = "22"
    }
  }

  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
  }
}

