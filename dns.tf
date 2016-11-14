
resource "digitalocean_domain" "anubot" {
    name = "anubot.io"
    ip_address = "${digitalocean_droplet.api_server.ipv4_address}"
}
