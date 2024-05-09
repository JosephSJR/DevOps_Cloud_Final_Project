module "db" {
  source = "terraform-aws-modules/rds/aws"

  identifier = "mysql-database-${terraform.workspace}"

  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = var.db_instance_class
  storage_encrypted = false
  allocated_storage = 5

  db_name  = "MySQLDB"
  username = var.db_user
  password = "admin"
  port     = "3306"

  iam_database_authentication_enabled = false
  deletion_protection = false

  create_db_subnet_group = true
  db_subnet_group_name   = module.vpc.database_subnet_group_name
  vpc_security_group_ids = [module.rds_mysql_sg.security_group_id]
  

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  # Enhanced Monitoring - see example for details on how to create the role
  # by yourself, in case you don't want to create it automatically
  monitoring_interval    = "30"
  monitoring_role_name   = "MyRDSMonitoringRole-${terraform.workspace}"
  create_monitoring_role = true

  tags = {
    Owner       = "user"
    Environment = "${terraform.workspace}"
  }

  #Subnet
  subnet_ids = module.vpc.private_subnets

  # DB parameter groupte
  family = "mysql8.0"

  # DB option group
  major_engine_version = "8.0"


  parameters = [
    {
      name  = "character_set_client"
      value = "utf8mb4"
    },
    {
      name  = "character_set_server"
      value = "utf8mb4"
    }
  ]

  options = [
    {
      option_name = "MARIADB_AUDIT_PLUGIN"

      option_settings = [
        {
          name  = "SERVER_AUDIT_EVENTS"
          value = "CONNECT"
        },
        {
          name  = "SERVER_AUDIT_FILE_ROTATIONS"
          value = "37"
        },
      ]
    },
  ]
}

