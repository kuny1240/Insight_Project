resource "aws_vpc" "main" {
  cidr_block       = "${var.vpc_cidr}"
  instance_tenancy = "${var.tenancy}"

  tags = {
    Name = "test_vpc"
  }
}

resource "aws_subnet" "main" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "${var.subnet_cidr}"

  tags = {
    Name = "test_subnet"
  }
}


