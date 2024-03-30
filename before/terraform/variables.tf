variable "region" {
  description = "Default region"
  default = "eu-central-1"
  type = string
}

variable "access_key" {
  description = "AWS auth"
  sensitive = true
  type = string
}

variable "secret_key" {
  description = "AWS auth"
  type = string
  sensitive = true
}

variable "db_username" {
  description = "Ecommerce DB username"
  type = string
  sensitive = true
}

variable "db_password" {
  description = "Ecommerce DB password"
  type = string
  sensitive = true
}