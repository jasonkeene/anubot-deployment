
resource "google_dns_managed_zone" "prod" {
  name        = "anubot-prod-zone"
  dns_name    = "anubot.io."
}

resource "google_compute_address" "api" {
  name = "api-address"
}

resource "google_dns_record_set" "api" {
  name = "api.${google_dns_managed_zone.prod.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = "${google_dns_managed_zone.prod.name}"

  rrdatas = [
    "${google_compute_address.api.address}"
  ]
}

resource "google_compute_address" "ci" {
  name = "ci-address"
}

resource "google_dns_record_set" "ci" {
  name = "ci.${google_dns_managed_zone.prod.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = "${google_dns_managed_zone.prod.name}"

  rrdatas = [
    "${google_compute_address.ci.address}"
  ]
}
