
variable "anubot_discord_oauth_client_id" {
    type = "string"
}

variable "anubot_discord_oauth_client_secret" {
    type = "string"
}

variable "anubot_discord_oauth_redirect_uri" {
    type = "string"
    default = "https://anubot.io/discord_oauth/done"
}

variable "anubot_twitch_oauth_client_id" {
    type = "string"
}

variable "anubot_twitch_oauth_client_secret" {
    type = "string"
}

variable "anubot_twitch_oauth_redirect_uri" {
    type = "string"
    default = "https://anubot.io/twitch_oauth/done"
}

variable "concourse_pg_password" {
    type = "string"
}
