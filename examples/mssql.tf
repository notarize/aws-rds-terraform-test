provider "aws" {
  version = "~> 1.2"
  region  = "us-east-1"
}

data "aws_kms_secrets" "rds_credentials" {
  secret {
    name    = "password"
    payload = "AQICAHj9P8B8y7UnmuH+/93CxzvYyt+la85NUwzunlBhHYQwSAG+eG8tr978ncilIYv5lj1OAAAAaDBmBgkqhkiG9w0BBwagWTBXAgEAMFIGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMoasNhkaRwpAX9sglAgEQgCVOmIaSSj/tJgEE5BLBBkq6FYjYcUm6Dd09rGPFdLBihGLCrx5H"
  }
}

module "vpc" {
  source = "git@github.com:rackspace-infrastructure-automation/aws-terraform-vpc_basenetwork?ref=v0.0.9"

  vpc_name = "Test1VPC"
}

module "rds_mssql" {
  source = "git@github.com:rackspace-infrastructure-automation/aws-terraform-rds?ref=v0.0.13"

  ##################
  # Required Configuration
  ##################

  subnets         = module.vpc.private_subnets                                 #  Required
  security_groups = ["${module.vpc.default_sg}"]                               #  Required
  name            = "sample-mssql-rds"                                         #  Required
  engine          = "sqlserver-se"                                             #  Required
  instance_class  = "db.m4.large"                                              #  Required
  password        = data.aws_kms_secrets.rds_credentials.plaintext["password"] #  Required

  # username = "dbadmin"

  ##################
  # VPC Configuration
  ##################

  # create_subnet_group   = true
  # existing_subnet_group = "some-subnet-group-name"

  ##################
  # Backups and Maintenance
  ##################

  # maintenance_window      = "Sun:07:00-Sun:08:00"
  # backup_retention_period = 35
  # backup_window           = "05:00-06:00"
  # db_snapshot_id          = "some-snapshot-id"

  ##################
  # Basic RDS
  ##################

  # dbname                = "mydb"
  # engine_version        = "14.00.3015.40.v1"
  # port                  = "1433"
  # copy_tags_to_snapshot = true
  # timezone              = "US/Central"
  # storage_type          = "gp2"
  # storage_size          = 100
  # storage_iops          = 0

  ##################
  # RDS Advanced
  ##################

  # publicly_accessible           = false
  # auto_minor_version_upgrade    = true
  # family                        = "sqlserver-se-14.00"
  # multi_az                      = false
  # storage_encrypted             = false
  # kms_key_id                    = "some-kms-key-id"
  # parameters                    = []
  # create_parameter_group        = true
  # existing_parameter_group_name = "some-parameter-group-name"
  # options                       = []
  # create_option_group           = true
  # existing_option_group_name    = "some-option-group-name"

  ##################
  # RDS Monitoring
  ##################

  # notification_topic           = "arn:aws:sns:<region>:<account>:some-topic"
  # alarm_write_iops_limit       = 100
  # alarm_read_iops_limit        = 100
  # alarm_free_space_limit       = 1024000000
  # alarm_cpu_limit              = 60
  # monitoring_interval          = 0
  # existing_monitoring_role = ""

  ##################
  # Other parameters
  ##################

  # environment = "Production"

  # tags = {
  #   SomeTag = "SomeValue"
  # }
}
