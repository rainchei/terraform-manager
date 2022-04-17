variable "vpc_name" {}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.vpc_name
  cidr = "10.0.0.0/16"

  azs = [
    data.aws_availability_zones.available.names[0],
    data.aws_availability_zones.available.names[1]
  ]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_ipv6 = false
  enable_dns_hostnames = true
  enable_nat_gateway = true
  single_nat_gateway = false

  tags = {
    Environment = var.env
  }

  vpc_tags = {
    Name = var.vpc_name
  }
}
