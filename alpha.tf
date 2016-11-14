
resource "digitalocean_ssh_key" "anubot" {
    name = "anubot-ssh-key"
    public_key = "${var.anubot_ssh_public_key}"
}

resource "digitalocean_droplet" "api_server" {
    image = "coreos-stable"
    name = "api-server"
    region = "nyc3"
    size = "512mb"
    ssh_keys = ["${digitalocean_ssh_key.anubot.id}"]
    user_data = "${file("user_data/api_server")}"
}
