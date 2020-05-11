variable "oci_tenancy_ocid" {
}

variable "oci_user_ocid" {
}

variable "oci_fingerprint" {
}

variable "oci_private_key_path" {
}

variable "oci_compartment_ocid" {
}

variable "oci_region" {
  default = "eu-frankfurt-1"
}

variable "oci_cidr_vcn" {
  default = "10.0.0.0/16"
}

variable "oci_cidr_forward_subnet" {
  default = "10.0.99.0/24"
}

variable "oci_cidr_private_subnet" {
  default = "10.0.1.0/24"
}

variable "oci_cidr_public_subnet" {
  default = "10.0.2.0/24"
}

variable "ssh_public_key" {
}

variable "private_dns_domain" {
  default = "oci.local"
}

variable "oci_base_image" {
  # CentOS7 frankfurt
  default = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaayr4br26ycze7ku5ygfxbyuvllpadmkcif7hwffmcd6d5fftwl35a"
}

