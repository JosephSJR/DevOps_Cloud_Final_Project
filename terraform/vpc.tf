module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.vpc_name}-${terraform.workspace}"
  cidr = var.vpc_cidr_block

  azs             = data.aws_availability_zones.available.names 
  private_subnets = var.private_subnet_cidr_blocks 
  public_subnets  = var.public_subnet_cidr_blocks
  database_subnet_group_name = var.db_subnet_group_name

  enable_nat_gateway = false
  enable_vpn_gateway = true
  create_igw = true

  

  tags = {
    Terraform = "true"
    Environment = "${terraform.workspace}"
  }
}