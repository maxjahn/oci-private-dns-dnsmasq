variable "oci_tenancy_ocid" {}
variable "oci_user_ocid" {}
variable "oci_fingerprint" {}
variable "oci_private_key_path" {}
variable "oci_compartment_ocid" {}
variable "oci_region" {}
variable "oci_cidr_vcn" {}
variable "oci_cidr_forward_subnet" {}
variable "oci_cidr_private_subnet" {}
variable "oci_cidr_public_subnet" {}

variable "ssh_public_key" {}
variable "ssh_private_key" {}

variable "private_dns_domain" { default = "oci.private"}

variable "oci_base_image" {
  # CentOS7 frankfurt
  default = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaayr4br26ycze7ku5ygfxbyuvllpadmkcif7hwffmcd6d5fftwl35a"
}
