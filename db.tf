
resource "google_compute_instance" "db" {
  name         = "db"
  machine_type = "g1-small"
  zone         = "us-central1-b"
  tags         = ["db"]

  disk {
    image = "coreos-cloud/coreos-stable"
  }

  disk {
    disk = "${google_compute_disk.anubot_postgres.name}"
    auto_delete = false
    device_name = "anubot-postgres"
  }

  metadata {
    user-data = "${data.template_file.db_cloud_config.rendered}"
    sshKeys = "core:${file(".secret/keys/id_rsa.pub")}"
  }

  network_interface {
    network = "default"
    access_config {}
  }
}

resource "google_compute_disk" "anubot_postgres" {
  name  = "anubot-postgres"
  size = 20
  type  = "pd-ssd"
  zone  = "us-central1-b"
}

data "template_file" "db_cloud_config" {
    template = "${file("cloud-config/db")}"
    vars {
        anubot_pg_password = "${var.anubot_pg_password}"
        concourse_pg_password = "${var.concourse_pg_password}"
    }
}
