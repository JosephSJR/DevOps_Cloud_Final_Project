module "frontend_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "frontend_sg-${terraform.workspace}"
  description = "Security group for Frontend"
  vpc_id      = module.vpc.vpc_id

  egress_with_cidr_blocks = [
    {
      from_port       = 0
      to_port         = 0
      protocol        = "-1"
      description     = "Allow all outbound traffic to the internet"
      cidr_blocks     = "0.0.0.0/0"
    }
  ]

  ingress_cidr_blocks      = [module.vpc.vpc_cidr_block]
  #ingress_rules            = ["https-443-tcp"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "Frontend Traffic"
      cidr_blocks = module.vpc.vpc_cidr_block
    },
    {
      from_port       = 22
      to_port         = 22
      protocol        = "tcp"
      description     = "SSH traffic"
      cidr_blocks     = module.vpc.vpc_cidr_block
    },
  ]
}

module "backend_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "backend_sg-${terraform.workspace}"
  description = "Security group for Backend"
  vpc_id      = module.vpc.vpc_id

  egress_with_cidr_blocks = [
    {
      from_port       = 0
      to_port         = 0
      protocol        = "-1"
      description     = "Allow all outbound traffic to the internet"
      cidr_blocks     = "0.0.0.0/0"
    }
  ]

  ingress_cidr_blocks      = [module.vpc.vpc_cidr_block]
  #ingress_rules            = ["http-80-tcp"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "Frontend Web Traffic"
      cidr_blocks = module.vpc.vpc_cidr_block
    },
    {
      from_port       = 22
      to_port         = 22
      protocol        = "tcp"
      description     = "SSH traffic"
      cidr_blocks     = module.vpc.vpc_cidr_block
    },
     {
      from_port       = 3000
      to_port         = 3000
      protocol        = "tcp"
      description     = "Backend traffic from ALB"
      cidr_blocks     = module.vpc.vpc_cidr_block
    },
  ]
}

module "bastion_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "bastion_sg-${terraform.workspace}"
  description = "Security group for Bastion/Host"
  vpc_id      = module.vpc.vpc_id

  egress_with_cidr_blocks = [
    {
      from_port       = 0
      to_port         = 0
      protocol        = "-1"
      description     = "Allow all outbound traffic to the internet"
      cidr_blocks     = "0.0.0.0/0"
    }
  ]

  ingress_cidr_blocks      = [module.vpc.vpc_cidr_block]
  ingress_with_cidr_blocks = [
    {
      from_port       = 22
      to_port         = 22
      protocol        = "tcp"
      description     = "SSH traffic from remote machines"
      cidr_blocks     = "0.0.0.0/0"
    },
  ]
}

module "rds_mysql_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "rds-mysql-sg-${terraform.workspace}"
  description = "Security group for MySQL RDS instance"
  vpc_id      = module.vpc.vpc_id

  egress_with_cidr_blocks = [
    {
      from_port       = 0
      to_port         = 0
      protocol        = "-1"
      description     = "Allow all outbound traffic to the internet"
      cidr_blocks     = "0.0.0.0/0"
    }
  ]

  ingress_cidr_blocks      = [module.vpc.vpc_cidr_block]
  ingress_with_cidr_blocks = [
    {
      from_port       = 3306
      to_port         = 3306
      protocol        = "tcp"
      description     = "MySQL traffic from backend"
      cidr_blocks     = module.vpc.vpc_cidr_block
    },
    {
      from_port       = 0
      to_port         = 0
      protocol        = "-1"
      description     = "Allow all traffic within the VPC"
      cidr_blocks     = module.vpc.vpc_cidr_block
    }

    
  ]
}

module "nat_instance_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "nat_instance_sg-${terraform.workspace}"
  description = "Security group for NAT Instance"
  vpc_id      = module.vpc.vpc_id

  egress_with_cidr_blocks = [
    {
      from_port       = 0
      to_port         = 0
      protocol        = "-1"
      description     = "Allow all outbound traffic to the internet"
      cidr_blocks     = "0.0.0.0/0"
    }
  ]

  ingress_cidr_blocks      = [module.vpc.vpc_cidr_block]
  ingress_with_cidr_blocks = [
    {
      from_port       = 22
      to_port         = 22
      protocol        = "tcp"
      description     = "SSH traffic"
      cidr_blocks     = "0.0.0.0/0" 
    },
    {
      from_port       = 0
      to_port         = 0
      protocol        = "-1"
      description     = "Allow all traffic within the VPC"
      cidr_blocks     = module.vpc.vpc_cidr_block
    }
    
  ]
}
