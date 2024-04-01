resource "aws_vpc" "ecommerce_prd_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "ecommerce_prd_vpc"
  }
}

resource "aws_subnet" "ecommerce_prd_subnet1" {
  vpc_id     = aws_vpc.ecommerce_prd_vpc.id
  availability_zone = "eu-central-1a"
  cidr_block = "10.0.1.0/24"
  depends_on = [
    aws_vpc.ecommerce_prd_vpc
  ]

  tags = {
    Name = "ecommerce_prd_subnet1"
  }
}

resource "aws_subnet" "ecommerce_prd_subnet2" {
  vpc_id     = aws_vpc.ecommerce_prd_vpc.id
  availability_zone = "eu-central-1b"
  cidr_block = "10.0.2.0/24"
  depends_on = [
    aws_vpc.ecommerce_prd_vpc
  ]

  tags = {
    Name = "ecommerce_prd_subnet2"
  }
}

resource "aws_vpc" "ecommerce_dev_vpc" {
  cidr_block = "10.1.0.0/16"

  tags = {
    Name = "ecommerce_dev_vpc"
  }
}

resource "aws_subnet" "ecommerce_dev_subnet" {
  vpc_id     = aws_vpc.ecommerce_dev_vpc.id
  cidr_block = "10.1.1.0/24"
  depends_on = [
    aws_vpc.ecommerce_dev_vpc
  ]

  tags = {
    Name = "ecommerce_dev_subnet"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.ecommerce_prd_vpc.id
}

resource "aws_security_group" "ecommerce-sg" {
  name        = "ecommerce-sg"
  description = "Security group for the ecommerce webapp"
  vpc_id      = aws_vpc.ecommerce_prd_vpc.id

  tags = {
    Name = "ecommerce-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ecommerce_allow_https" {
  depends_on = [
    aws_security_group.ecommerce-sg
  ]
  security_group_id = aws_security_group.ecommerce-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "ecommerce_allow_http" {
  depends_on = [
    aws_security_group.ecommerce-sg
  ]
  security_group_id = aws_security_group.ecommerce-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "ecommerce_allow_ssh" {
  depends_on = [
    aws_security_group.ecommerce-sg
  ]
  security_group_id = aws_security_group.ecommerce-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "ecommerce_allow_all_traffic_ipv4" {
  depends_on = [
    aws_security_group.ecommerce-sg
  ]
  security_group_id = aws_security_group.ecommerce-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc" "blog_prd_vpc" {
  cidr_block = "10.2.0.0/16"

  tags = {
    Name = "blog_prd_vpc"
  }
}

resource "aws_subnet" "blog_prd_subnet" {
  depends_on = [
    aws_vpc.blog_prd_vpc
  ]
  vpc_id     = aws_vpc.blog_prd_vpc.id
  cidr_block = "10.2.1.0/24"

  tags = {
    Name = "blog_prd_subnet"
  }
}

resource "aws_vpc" "blog_dev_vpc" {
  cidr_block = "10.3.0.0/16"

  tags = {
    Name = "blog_dev_vpc"
  }
}

resource "aws_subnet" "blog_dev_subnet" {
  depends_on = [
    aws_vpc.blog_dev_vpc
  ]  
  vpc_id     = aws_vpc.blog_dev_vpc.id
  cidr_block = "10.3.1.0/24"

  tags = {
    Name = "blog_dev_subnet"
  }
}
 
 resource "aws_security_group" "blog-sg" {
  name        = "ecommerce-sg"
  description = "Security group for the ecommerce webapp"
  vpc_id      = aws_vpc.blog_prd_vpc.id

  tags = {
    Name = "ecommerce-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "blog_allow_https" {
  depends_on = [
    aws_security_group.blog-sg
  ]
  security_group_id = aws_security_group.blog-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "blog_allow_http" {
  depends_on = [
    aws_security_group.blog-sg
  ]
  security_group_id = aws_security_group.blog-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "blog_allow_ssh" {
  depends_on = [
    aws_security_group.blog-sg
  ]
  security_group_id = aws_security_group.blog-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "blog_allow_all_traffic_ipv4" {
  depends_on = [
    aws_security_group.blog-sg
  ]
  security_group_id = aws_security_group.blog-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

 resource "aws_security_group" "blog-dev-sg" {
  name        = "blog-dev-sg"
  description = "Security group for the ecommerce webapp"
  vpc_id      = aws_vpc.blog_dev_vpc.id

  tags = {
    Name = "blog-dev-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "blog_dev_allow_https" {
  depends_on = [
    aws_security_group.blog-dev-sg
  ]
  security_group_id = aws_security_group.blog-dev-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "blog_dev_allow_http" {
  depends_on = [
    aws_security_group.blog-dev-sg
  ]
  security_group_id = aws_security_group.blog-dev-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "blog_dev_allow_ssh" {
  depends_on = [
    aws_security_group.blog-dev-sg
  ]
  security_group_id = aws_security_group.blog-dev-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "blog_dev_allow_all_traffic_ipv4" {
  depends_on = [
    aws_security_group.blog-dev-sg
  ]
  security_group_id = aws_security_group.blog-dev-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_security_group" "ecommerce-dev-sg" {
  name        = "ecommerce-dev-sg"
  description = "Security group for the ecommerce webapp"
  vpc_id      = aws_vpc.ecommerce_dev_vpc.id

  tags = {
    Name = "ecommerce-dev-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ecommerce_dev_allow_https" {
  depends_on = [
    aws_security_group.ecommerce-dev-sg
  ]
  security_group_id = aws_security_group.ecommerce-dev-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "ecommerce_dev_allow_http" {
  depends_on = [
    aws_security_group.ecommerce-dev-sg
  ]
  security_group_id = aws_security_group.ecommerce-dev-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "ecommerce_dev_allow_ssh" {
  depends_on = [
    aws_security_group.ecommerce-dev-sg
  ]
  security_group_id = aws_security_group.ecommerce-dev-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "ecommerce_dev_allow_all_traffic_ipv4" {
  depends_on = [
    aws_security_group.ecommerce-dev-sg
  ]
  security_group_id = aws_security_group.ecommerce-dev-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}