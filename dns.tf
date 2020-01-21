resource "oci_dns_zone" "pdns_zone" {
    compartment_id = "${var.oci_compartment_ocid}"
    name = "${var.private_dns_domain}"
    zone_type = "PRIMARY"
}


resource "oci_dns_record" "pdns_record_01" {
    zone_name_or_id = "${oci_dns_zone.pdns_zone.id}"
    domain = "01.priv.appserver.${var.private_dns_domain}"
    rtype = "A"
    rdata = "${oci_core_instance.pdns_private_instance_01.private_ip}"
    ttl = 300
}

resource "oci_dns_record" "pdns_record_02" {
    zone_name_or_id = "${oci_dns_zone.pdns_zone.id}"
    domain = "02.pub.appserver.${var.private_dns_domain}"
    rtype = "A"
    rdata = "${oci_core_instance.pdns_public_instance_01.private_ip}"
    ttl = 300
}




