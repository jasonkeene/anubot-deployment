
provider "google" {
    credentials = "${file(".secret/credentials.json")}"
    project     = "${var.gcp_project}"
    region      = "${var.gcp_region}"
}
