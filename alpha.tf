
resource "digitalocean_ssh_key" "anubot" {
    name = "anubot-ssh-key"
    public_key = "${file("keys/id_rsa.pub")}"
}

resource "digitalocean_volume" "anubot" {
    region      = "nyc1"
    name        = "anubot"
    size        = 20
    description = "Storage for anubot databases."
}

data "template_file" "api_server_user_data" {
    template = "${file("user_data/api_server")}"
    vars {
        tls_key = "${replace(file("certs/anubot.io.key"), "\n", "\n    ")}"
        tls_cert = "${replace(file("certs/anubot.io.combined"), "\n", "\n    ")}"
        ci_tls_key = "${replace(file("certs/ci.anubot.io.key"), "\n", "\n    ")}"
        ci_tls_cert = "${replace(file("certs/ci.anubot.io.combined"), "\n", "\n    ")}"
        tls_dhparam = "${replace(file("certs/dhparam.pem"), "\n", "\n    ")}"
        discord_client_id = "${var.anubot_discord_oauth_client_id}"
        discord_client_secret = "${var.anubot_discord_oauth_client_secret}"
        discord_redirect_uri = "${var.anubot_discord_oauth_redirect_uri}"
        twitch_client_id = "${var.anubot_twitch_oauth_client_id}"
        twitch_client_secret = "${var.anubot_twitch_oauth_client_secret}"
        twitch_redirect_uri = "${var.anubot_twitch_oauth_redirect_uri}"
        concourse_github_client_id = "${var.concourse_github_oauth_client_id}"
        concourse_github_client_secret = "${var.concourse_github_oauth_client_secret}"

        concourse_pg_password = "${var.concourse_pg_password}"
        concourse_web_session_signing_key = "${replace(file("keys/concourse/web/session_signing_key"), "\n", "\n    ")}"
        concourse_web_session_signing_key_pub = "${file("keys/concourse/web/session_signing_key.pub")}"
        concourse_web_tsa_host_key = "${replace(file("keys/concourse/web/tsa_host_key"), "\n", "\n    ")}"
        concourse_web_tsa_host_key_pub = "${file("keys/concourse/web/tsa_host_key.pub")}"
        concourse_worker_worker_key = "${replace(file("keys/concourse/worker/worker_key"), "\n", "\n    ")}"
        concourse_worker_worker_key_pub = "${file("keys/concourse/worker/worker_key.pub")}"
    }
}

resource "digitalocean_droplet" "api_server" {
    image = "coreos-stable"
    name = "api-server"
    region = "nyc1"
    size = "1gb"
    ssh_keys = ["${digitalocean_ssh_key.anubot.id}"]
    user_data = "${data.template_file.api_server_user_data.rendered}"
    volume_ids = ["${digitalocean_volume.anubot.id}"]
}
