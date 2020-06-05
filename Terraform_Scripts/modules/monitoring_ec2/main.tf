

provider "aws" {
    region = "${var.aws_region}"
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

################################
# Set Up Ubuntu Instance For EC2
################################

//data "aws_ami" "ubuntu" {
//    most_recent = true
//
//    filter {
//        name   = "name"
//        values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
//    }
//
//    filter {
//        name   = "virtualization-type"
//        values = ["hvm"]
//    }
//
//    owners = ["099720109477"] # Canonical
//}

data "aws_ami" "costum" {
    most_recent = true

    filter {
        name   = "name"
        values = ["packer-linux-aws-demo-1581038484"]
    }

    owners = ["391807337052"] # Kun
}

resource "aws_instance" "web" {
    ami           = "${data.aws_ami.costum.id}"
    instance_type = "t2.micro"
    key_name      = "kun-IAM-keypair"

    tags = {
        Name = "${var.name}"
    }
}

output "image_id" {
    value = "${data.aws_ami.costum.id}"
}