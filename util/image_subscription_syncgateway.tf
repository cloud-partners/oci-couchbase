#Local variables pointing to the Marketplace catalog resource
#Eg. Modify accordingly to your Application/Listing
locals {
  mp_listing_id_syncgateway               = "${var.mp_listing_id_syncgateway}"
  mp_listing_resource_id_syncgateway      = "${var.mp_listing_resource_id_syncgateway}"
  mp_listing_resource_version_syncgateway = "${var.mp_listing_resource_version_syncgateway}"
}

#Get Image Agreement
resource "oci_core_app_catalog_listing_resource_version_agreement" "mp_image_agreement_syncgateway" {
  count = "${var.use_marketplace_image ? 1 : 0}"

  listing_id               = "${local.mp_listing_id_syncgateway}"
  listing_resource_version = "${local.mp_listing_resource_version_syncgateway}"
}

#Accept Terms and Subscribe to the image, placing the image in a particular compartment
resource "oci_core_app_catalog_subscription" "mp_image_subscription_syncgateway" {
  count                    = "${var.use_marketplace_image ? 1 : 0}"
  compartment_id           = "${var.compartment_ocid}"
  eula_link                = "${oci_core_app_catalog_listing_resource_version_agreement.mp_image_agreement_syncgateway.eula_link}"
  listing_id               = "${oci_core_app_catalog_listing_resource_version_agreement.mp_image_agreement_syncgateway.listing_id}"
  listing_resource_version = "${oci_core_app_catalog_listing_resource_version_agreement.mp_image_agreement_syncgateway.listing_resource_version}"
  oracle_terms_of_use_link = "${oci_core_app_catalog_listing_resource_version_agreement.mp_image_agreement_syncgateway.oracle_terms_of_use_link}"
  signature                = "${oci_core_app_catalog_listing_resource_version_agreement.mp_image_agreement_syncgateway.signature}"
  time_retrieved           = "${oci_core_app_catalog_listing_resource_version_agreement.mp_image_agreement_syncgateway.time_retrieved}"

  timeouts {
    create = "20m"
  }
}

# Gets the partner image subscription
data "oci_core_app_catalog_subscriptions" "mp_image_subscription_syncgateway" {
  #Required
  compartment_id = "${var.compartment_ocid}"

  #Optional
  listing_id = "${local.mp_listing_id_syncgateway}"

  filter {
    name   = "listing_resource_version"
    values = ["${local.mp_listing_resource_version_syncgateway}"]
  }
}