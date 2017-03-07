
resource "google_compute_instance" "ci" {
  name         = "ci"
  machine_type = "g1-small"
  zone         = "us-central1-b"
  tags         = ["ci", "public"]

  disk {
    image = "coreos-cloud/coreos-stable"
    size = 20
  }

  metadata {
    user-data = "${data.template_file.ci_cloud_config.rendered}"
    sshKeys = "core:${file(".secret/keys/id_rsa.pub")}"
  }

  network_interface {
    network = "default"
    access_config {
      nat_ip = "${google_compute_address.ci.address}"
    }
  }
}

data "template_file" "ci_cloud_config" {
    template = "${file("cloud-config/ci")}"
    vars {
        concourse_github_client_id = "${var.concourse_github_client_id}"
        concourse_github_client_secret = "${var.concourse_github_client_secret}"

        concourse_pg_password = "${var.concourse_pg_password}"
        concourse_pg_host = "${google_compute_instance.db.network_interface.0.address}"

        ci_tls_key = "${replace(file(".secret/certs/ci.anubot.io.key"), "\n", "\n    ")}"
        ci_tls_cert = "${replace(file(".secret/certs/ci.anubot.io.combined"), "\n", "\n    ")}"
        tls_dhparam = "${replace(file(".secret/certs/dhparam.pem"), "\n", "\n    ")}"

        concourse_web_session_signing_key = "${replace(file(".secret/keys/concourse/web/session_signing_key"), "\n", "\n    ")}"
        concourse_web_session_signing_key_pub = "${file(".secret/keys/concourse/web/session_signing_key.pub")}"
        concourse_web_tsa_host_key = "${replace(file(".secret/keys/concourse/web/tsa_host_key"), "\n", "\n    ")}"
        concourse_web_tsa_host_key_pub = "${file(".secret/keys/concourse/web/tsa_host_key.pub")}"
        concourse_worker_worker_key = "${replace(file(".secret/keys/concourse/worker/worker_key"), "\n", "\n    ")}"
        concourse_worker_worker_key_pub = "${file(".secret/keys/concourse/worker/worker_key.pub")}"
    }
}
