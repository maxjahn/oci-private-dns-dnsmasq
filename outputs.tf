
data "oci_dns_zones" "zs" {
  compartment_id = "${var.oci_compartment_ocid}"
  name_contains = "pdns"
}

data "dns_a_record_set" "ns1" {
  host = "${lookup(oci_dns_zone.pdns_zone.nameservers[0],"hostname","")}"
}

data "dns_a_record_set" "ns2" {
  host = "${lookup(oci_dns_zone.pdns_zone.nameservers[1],"hostname","")}"
}

output "authorative nameservers" {
  value = "${join(", ", data.dns_a_record_set.ns1.addrs, data.dns_a_record_set.ns2.addrs)}"
}


output "dns_forward_01_node_private_ip" {
  value = ["${oci_core_instance.dns_forward_instance_01.private_ip}"]
}

output "dns_forward_01_node_public_ip" {
  value = ["${oci_core_instance.dns_forward_instance_01.public_ip}"]
}

output "dns_forward_02_node_private_ip" {
  value = ["${oci_core_instance.dns_forward_instance_02.private_ip}"]
}

output "dns_forward_02_node_public_ip" {
  value = ["${oci_core_instance.dns_forward_instance_02.public_ip}"]
}


output "private_node_private_ip" {
  value = ["${oci_core_instance.pdns_private_instance_01.private_ip}"]
}

output "private_node_public_ip" {
  value = ["${oci_core_instance.pdns_private_instance_01.public_ip}"]
}

output "public_node_private_ip" {
  value = ["${oci_core_instance.pdns_public_instance_01.private_ip}"]
}

output "public_node_public_ip" {
  value = ["${oci_core_instance.pdns_public_instance_01.public_ip}"]
}

