provider "google" {
  credentials = file("/path/to/credentials.json")
  project     = "${var.gcp_project}"
  region      = "${var.gcp_region}"
  zone        = "${var.gcp_zone}"
}