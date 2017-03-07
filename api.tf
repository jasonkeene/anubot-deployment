
resource "google_compute_instance" "api" {
  name         = "api"
  machine_type = "f1-micro"
  zone         = "us-central1-b"
  tags         = ["api", "public"]

  disk {
    image = "coreos-cloud/coreos-stable"
  }

  metadata {
    user-data = "${data.template_file.api_cloud_config.rendered}"
    sshKeys = "core:${file(".secret/keys/id_rsa.pub")}"
  }

  network_interface {
    network = "default"
    access_config {
      nat_ip = "${google_compute_address.api.address}"
    }
  }
}

data "template_file" "api_cloud_config" {
    template = "${file("cloud-config/api")}"
    vars {
        anubot_encryption_key = "${var.anubot_encryption_key}"

        anubot_pg_host = "${google_compute_instance.db.network_interface.0.address}"
        anubot_pg_password = "${var.anubot_pg_password}"

        api_tls_key = "${replace(file(".secret/certs/api.anubot.io.key"), "\n", "\n    ")}"
        api_tls_cert = "${replace(file(".secret/certs/api.anubot.io.combined"), "\n", "\n    ")}"
        tls_dhparam = "${replace(file(".secret/certs/dhparam.pem"), "\n", "\n    ")}"

        discord_client_id = "${var.anubot_discord_oauth_client_id}"
        discord_client_secret = "${var.anubot_discord_oauth_client_secret}"
        discord_redirect_uri = "${var.anubot_discord_oauth_redirect_uri}"

        twitch_client_id = "${var.anubot_twitch_oauth_client_id}"
        twitch_client_secret = "${var.anubot_twitch_oauth_client_secret}"
        twitch_redirect_uri = "${var.anubot_twitch_oauth_redirect_uri}"
    }
}
