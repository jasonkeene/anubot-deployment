
resource "google_compute_firewall" "public" {
  name    = "public"
  network = "default"

  source_ranges = [
    "0.0.0.0/0"
  ]

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = [
      "22",
      "42224",
      "443",
    ]
  }

  target_tags = ["public"]
}
