module "alb_igw_frontend" {
  source = "terraform-aws-modules/alb/aws"

  name    = "${var.alb_igw_frontend_name}-${terraform.workspace}"
  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.public_subnets

  # Security Group
  security_group_ingress_rules = {
    all_http = {
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      description = "HTTP web traffic"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }
  security_group_egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = module.vpc.vpc_cidr_block
    }
  }

  access_logs = {
    bucket = "alb-logs"
  }

  listeners = {
    ex-http = {
      port     = 80
      protocol = "HTTP"

      forward = {
        target_group_key = "frontend-instance"
      }
    }
  }

  target_groups = {
    frontend-instance = {
      name_prefix      = "front"
      protocol         = "HTTP"
      port             = 80
      target_type      = "instance"
      target_id        = module.ec2_frontend.id
    }
  }

  tags = {
    Environment = "${terraform.workspace}"
  }
}


module "alb_frontend_backend" {
  source = "terraform-aws-modules/alb/aws"

  name    = "${var.alb_frontend_backend_name}-${terraform.workspace}"
  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.private_subnets
  internal = true

  # Security Group
  security_group_ingress_rules = {
    all_http = {
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      description = "HTTP web traffic"
      cidr_ipv4   = "0.0.0.0/0"
    }
    
  }
  security_group_egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = module.vpc.vpc_cidr_block
    }
  }

  access_logs = {
    bucket = "alb-logs"
  }

  listeners = {
    frontend-to-backend = {
      port     = 80
      protocol = "HTTP"

      forward = {
        target_group_key = "backend-instance"
      }
    }
  }

  target_groups = {
    backend-instance = {
      name_prefix      = "back"
      protocol         = "HTTP"
      port             = 3000
      target_type      = "instance"
      target_id        = module.ec2_backend.id
    }
  }

  tags = {
    Environment = "${terraform.workspace}"
  }
}