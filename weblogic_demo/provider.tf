provider "baremetal" {
  region               = "${var.region}"
  tenancy_ocid         = "${var.tenancy_ocid}"
  user_ocid            = "${var.user_ocid}"
  fingerprint          = "${var.fingerprint}"
  private_key_path     = "${var.private_key_path}"
  disable_auto_retries = "true"
}

module "bmc_resources" {
  source = "../modules/datasources"
  tenancy_ocid = "${var.tenancy_ocid}"
}
