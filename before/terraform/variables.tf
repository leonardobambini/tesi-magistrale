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

variable "alb_sgs" {
  type = list
}

variable "db_username" {
  description = "Webapp DB username"
  type = string
  sensitive = true
}

variable "db_password" {
  description = "Webapp DB password"
  type = string
  sensitive = true
}