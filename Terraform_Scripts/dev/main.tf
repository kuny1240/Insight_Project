module "parameter_group1" {
  source = "../modules/db_parameter_group"
  aws_region = "us-west-2"
}


module "db_test" {
  source = "../modules/rds"
  account_id = "391807337052"
  parameter_group = "rds-logpg"
  region = "us-west-2"
}

module "Ubuntu-1"{
  source = "../modules/monitoring_ec2"
  aws_region = "us-west-2"
  name = "Monitor"
}

module "Server-Ec2"{
  source = "../modules/server_ec2"
  aws_region = "us-west-2"
}