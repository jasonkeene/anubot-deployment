
resource "digitalocean_floating_ip" "api_server" {
    droplet_id = "${digitalocean_droplet.api_server.id}"
    region = "nyc1"
}

resource "digitalocean_domain" "anubot" {
    name = "anubot.io"
    ip_address = "${digitalocean_floating_ip.api_server.ip_address}"
}
