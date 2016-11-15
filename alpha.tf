
resource "digitalocean_ssh_key" "anubot" {
    name = "anubot-ssh-key"
    public_key = "${var.anubot_ssh_public_key}"
}

data "template_file" "api_server_user_data" {
    template = "${file("user_data/api_server")}"
    vars {
        tls_key = "${replace(file("certs/anubot.io.key"), "\n", "\n    ")}"
        tls_cert = "${replace(file("certs/anubot.io.combined"), "\n", "\n    ")}"
        discord_client_id = "${var.anubot_discord_oauth_client_id}"
        discord_client_secret = "${var.anubot_discord_oauth_client_secret}"
        discord_redirect_uri = "${var.anubot_discord_oauth_redirect_uri}"
        twitch_client_id = "${var.anubot_twitch_oauth_client_id}"
        twitch_client_secret = "${var.anubot_twitch_oauth_client_secret}"
        twitch_redirect_uri = "${var.anubot_twitch_oauth_redirect_uri}"
    }
}

resource "digitalocean_droplet" "api_server" {
    image = "coreos-stable"
    name = "api-server"
    region = "nyc3"
    size = "512mb"
    ssh_keys = ["${digitalocean_ssh_key.anubot.id}"]
    user_data = "${data.template_file.api_server_user_data.rendered}"
}
