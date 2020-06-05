provider "aws" {
  region = "${var.region}"
}

##############################################################
# Data sources to get VPC, subnets and security group details
##############################################################
data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "all" {
  vpc_id = data.aws_vpc.default.id
}

data "aws_security_group" "default" {
  vpc_id = data.aws_vpc.default.id
  name   = "default"
}

##################################################
# Create an IAM role to allow enhanced monitoring
##################################################
resource "aws_iam_role" "rds_enhanced_monitoring" {
  name_prefix        = "rds-enhanced-monitoring-"
  assume_role_policy = data.aws_iam_policy_document.rds_enhanced_monitoring.json
}

resource "aws_iam_role_policy_attachment" "rds_enhanced_monitoring" {
  role       = aws_iam_role.rds_enhanced_monitoring.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

data "aws_iam_policy_document" "rds_enhanced_monitoring" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }
  }
}

#####
# DB
#####

resource "aws_db_instance" "visor" {
  identifier           = "visor-master"
  allocated_storage    = 160
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7.23"
  instance_class       = "db.t3.medium"
  username             = ""
  password             = ""
  enabled_cloudwatch_logs_exports = ["error","general","slowquery"]
  parameter_group_name = "${var.parameter_group}"
  monitoring_interval  = "30"
  monitoring_role_arn  = aws_iam_role.rds_enhanced_monitoring.arn
  multi_az             = true
  publicly_accessible = true
  final_snapshot_identifier = "final-snapshot"
  backup_retention_period = 7
}


resource "aws_db_instance" "visor_read" {
  replicate_source_db = "${aws_db_instance.visor.id}"

  identifier           = "visor-read"

  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7.23"
  instance_class       = "db.t3.medium"

  username             = ""
  password             = ""

  publicly_accessible = true
  final_snapshot_identifier = "final-snapshot-read"

  enabled_cloudwatch_logs_exports = ["error","general","slowquery"]
  parameter_group_name = "${var.parameter_group}"

  monitoring_interval  = "30"
  monitoring_role_arn  = aws_iam_role.rds_enhanced_monitoring.arn

  multi_az             = false
  backup_retention_period = 0
}

resource "aws_db_instance" "visor_read_two" {
  replicate_source_db = "${aws_db_instance.visor.id}"

  identifier           = "visor-read-2"

  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7.23"
  instance_class       = "db.t3.medium"

  username             = ""
  password             = ""

  enabled_cloudwatch_logs_exports = ["error","general","slowquery"]
  parameter_group_name = "${var.parameter_group}"

  monitoring_interval  = "30"
  monitoring_role_arn  = aws_iam_role.rds_enhanced_monitoring.arn

  publicly_accessible = true
  final_snapshot_identifier = "final-snapshot-read"

  multi_az             = false
  backup_retention_period = 0
}

resource "aws_db_instance" "visor_metrics" {
  replicate_source_db = "${aws_db_instance.visor.id}"

  identifier           = "visor-metrics"

  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7.23"
  instance_class       = "db.t3.medium"

  username             = ""
  password             = ""

  publicly_accessible = true
  final_snapshot_identifier = "final-snapshot-read"

  enabled_cloudwatch_logs_exports = ["error","general","slowquery"]
  parameter_group_name = "${var.parameter_group}"

  monitoring_interval  = "30"
  monitoring_role_arn  = aws_iam_role.rds_enhanced_monitoring.arn

  multi_az             = false
  backup_retention_period = 0
}
