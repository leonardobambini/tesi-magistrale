variable "region" {
  default = "eu-central-1"
  type = string
}

variable "access_key" {
  sensitive = true
  type = string
}

variable "secret_key" {
  type = string
}