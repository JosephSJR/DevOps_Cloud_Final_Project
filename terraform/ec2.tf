module "ec2_frontend" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "${var.instance_names[0]}-instance-${terraform.workspace}"

  instance_type          = var.instance_type
  key_name               = var.aws_key_pair
  monitoring             = true
  vpc_security_group_ids = [module.frontend_sg.security_group_id]
  subnet_id              = module.vpc.private_subnets[0]
  ami                    = var.ami_id

  tags = {
    Terraform   = "true"
    Environment = "${terraform.workspace}"
  }
}

module "ec2_backend" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "${var.instance_names[1]}-instance-${terraform.workspace}"

  instance_type          = var.instance_type
  key_name               = var.aws_key_pair
  monitoring             = true
  vpc_security_group_ids = [module.backend_sg.security_group_id]
  subnet_id              = module.vpc.private_subnets[1]
  ami                    = var.ami_id

  tags = {
    Terraform   = "true"
    Environment = "${terraform.workspace}"
  }
}

module "ec2_bastion_host" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "${var.instance_names[2]}-instance-${terraform.workspace}"

  instance_type          = var.instance_type
  key_name               = var.aws_key_pair
  monitoring             = true
  vpc_security_group_ids = [module.bastion_sg.security_group_id]
  subnet_id              = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  ami                    = var.ami_id

  tags = {
    Terraform   = "true"
    Environment = "${terraform.workspace}"
  }
}

module "ec2_nat_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "${var.instance_names[3]}-instance-${terraform.workspace}"

  instance_type          = var.instance_type
  key_name               = var.aws_key_pair
  monitoring             = true
  vpc_security_group_ids = [module.nat_instance_sg.security_group_id]
  subnet_id              = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  ami                    = var.nat_ami

  tags = {
    Terraform   = "true"
    Environment = "${terraform.workspace}"
  }
}
