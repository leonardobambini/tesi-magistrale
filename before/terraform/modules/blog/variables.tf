variable "vpc_id" {
  type = string
}

variable "subnet_prd_id" {
  type = string
}

variable "subnet_dev_id" {
  type = string
}

variable "security_groups" {
  type = list
}

variable "security_groups_dev" {
  type = list
}