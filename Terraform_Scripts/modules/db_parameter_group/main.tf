provider "aws" {
    region = "${var.aws_region}"
}

resource "aws_db_parameter_group" "default" {
  name   = "rds-logpg"
  family = "mysql5.7"

  parameter {
    name  = "character_set_server"
    value = "utf8"
  }

  parameter {
    name = "slow_query_log"
    value = "1"
  }

  parameter {
    name = "general_log"
    value = "1"
  }

  parameter {
    name = "long_query_time"
    value = "2"
  }
  parameter {
    name = "log_output"
    value = "FILE"
  }


}