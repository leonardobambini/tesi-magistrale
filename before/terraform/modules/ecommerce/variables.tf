variable "alb_subnets" {
  description = "ALB subnets"
  type = list
}

variable "alb_sgs" {
  description = "ALB security groups"
  type = list
}

variable "vpc_id" {
  type = string
}