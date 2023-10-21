module "vpc" {
  source               = "terraform-aws-modules/vpc/aws"
  name                 = var.VPC_NAME
  cidr                 = var.vpccidr
  azs                  = [var.ZONE1, var.ZONE2, var.ZONE3]
  private_subnets      = [var.PrivSub1cidr, var.PrivSub2cidr, var.PrivSub3cidr]
  public_subnets       = [var.PubSub1cidr, var.PubSub2cidr, var.PubSub3cidr]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Terraform   = "true"
    Environment = "Prod"
  }
  vpc_tags = {
    Name = var.VPC_NAME
  }
}