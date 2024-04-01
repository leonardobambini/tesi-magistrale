variable "alb_subnets" {
  description = "ALB subnets"
  type = list
}

variable "alb_sgs" {
  description = "ALB security groups"
  type = list
}

variable "security_groups_dev" {
  type = list
}

variable "vpc_id" {
  type = string
}

variable "subnet_prd_1_id" {
  type = string
}

variable "subnet_prd_2_id" {
  type = string
}

variable "subnet_dev_id" {
  type = string
}