
variable "gcp_project" {
    type = "string"
}

variable "gcp_region" {
    type = "string"
}

variable "anubot_pg_password" {
    type = "string"
}

variable "anubot_encryption_key" {
    type = "string"
}

variable "anubot_discord_oauth_client_id" {
    type = "string"
}

variable "anubot_discord_oauth_client_secret" {
    type = "string"
}

variable "anubot_discord_oauth_redirect_uri" {
    type = "string"
    default = "https://api.anubot.io/v1/discord_oauth/done"
}

variable "anubot_twitch_oauth_client_id" {
    type = "string"
}

variable "anubot_twitch_oauth_client_secret" {
    type = "string"
}

variable "anubot_twitch_oauth_redirect_uri" {
    type = "string"
    default = "https://api.anubot.io/v1/twitch_oauth/done"
}

variable "concourse_pg_password" {
    type = "string"
}

variable "concourse_github_client_id" {
    type = "string"
}

variable "concourse_github_client_secret" {
    type = "string"
}
