
data "oci_identity_availability_domains" "pdns_ads" {
  compartment_id = "${var.oci_compartment_ocid}"
}


data "template_file" "dnsmasq" {
  template = "${file("templates/dnsmasq.tpl")}"
  vars {
    private_domain = "${var.private_dns_domain}"
    zone_dns_1 = "${join("",data.dns_a_record_set.ns1.addrs)}" 
    zone_dns_2 = "${join("",data.dns_a_record_set.ns2.addrs)}" 
  }
}

resource "oci_core_instance" "dns_forward_instance_01" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.pdns_ads.availability_domains[0],"name")}"
  compartment_id      = "${var.oci_compartment_ocid}"
  shape               = "VM.Standard2.1"

  create_vnic_details {
    subnet_id              = "${oci_core_subnet.dns_forward_subnet.id}"
    assign_public_ip = true
    skip_source_dest_check = true
  }

  display_name = "dnsforward-01"

  metadata {
    ssh_authorized_keys = "${var.ssh_public_key}"
    user_data = "${base64encode(data.template_file.dnsmasq.rendered)}"
  }

  source_details {
    source_id   = "${var.oci_base_image}"
    source_type = "image"
  }

  preserve_boot_volume = false

}

resource "oci_core_instance" "dns_forward_instance_02" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.pdns_ads.availability_domains[1],"name")}"
  compartment_id      = "${var.oci_compartment_ocid}"
  shape               = "VM.Standard2.1"

  create_vnic_details {
    subnet_id              = "${oci_core_subnet.dns_forward_subnet.id}"
    assign_public_ip = true
    skip_source_dest_check = true
  }

  display_name = "dnsforward-02"

  metadata {
    ssh_authorized_keys = "${var.ssh_public_key}"
    user_data = "${base64encode(data.template_file.dnsmasq.rendered)}"
  }

  source_details {
    source_id   = "${var.oci_base_image}"
    source_type = "image"
  }

  preserve_boot_volume = false

}



resource "oci_core_instance" "pdns_public_instance_01" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.pdns_ads.availability_domains[0],"name")}"
  compartment_id      = "${var.oci_compartment_ocid}"
  shape               = "VM.Standard2.1"

  create_vnic_details {
    subnet_id              = "${oci_core_subnet.public_subnet.id}"
    assign_public_ip = true
    skip_source_dest_check = true
  }

  display_name = "pdns-pub-01"

  metadata {
    ssh_authorized_keys = "${var.ssh_public_key}"
  }

  source_details {
    source_id   = "${var.oci_base_image}"
    source_type = "image"
  }

  preserve_boot_volume = false

}


resource "oci_core_instance" "pdns_private_instance_01" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.pdns_ads.availability_domains[1],"name")}"
  compartment_id      = "${var.oci_compartment_ocid}"
  shape               = "VM.Standard2.1"

  create_vnic_details {
    subnet_id              = "${oci_core_subnet.private_subnet.id}"
    assign_public_ip = false 
    skip_source_dest_check = true
  }

  display_name = "pdns-priv-01"

  metadata {
    ssh_authorized_keys = "${var.ssh_public_key}"
  }

  source_details {
    source_id   = "${var.oci_base_image}"
    source_type = "image"
  }

  preserve_boot_volume = false

}




