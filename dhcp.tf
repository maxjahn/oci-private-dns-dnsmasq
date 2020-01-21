
resource "oci_core_dhcp_options" "pdns_dhcp_options" {
    compartment_id = "${var.oci_compartment_ocid}"
    options {
        type = "DomainNameServer"
        server_type = "CustomDnsServer"
        custom_dns_servers = [ "${oci_core_instance.dns_forward_instance_01.private_ip}" , "${oci_core_instance.dns_forward_instance_02.private_ip}",  "169.254.169.254" ]
    }

    options {
        type = "SearchDomain"
        search_domain_names = [ "${var.private_dns_domain}" ]
    }

    vcn_id = "${oci_core_virtual_network.pdns_vcn.id}"
}


