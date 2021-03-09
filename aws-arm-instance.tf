variable "aws_access_key" {
  type = string
}
variable "aws_secret_key" {
  type = string
}
variable "ssh_public_key" {
  type = string
}

provider "aws" {
    access_key = var.aws_access_key
    secret_key = var.aws_secret_key
    region = "us-east-1"
}

resource "aws_security_group" "arm-secgroup" {
    name = "arm-secgroup"
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_key_pair" "arm-pem" {
    key_name = "arm-pem"
    public_key = var.ssh_public_key
}

resource "aws_instance" "arm-instance" {
    ami = "ami-0c3dda3deab25a563"
    instance_type = "t4g.micro"
    subnet_id = "subnet-2a1b1605"
    key_name = "arm-pem"
    security_groups = [aws_security_group.arm-secgroup.id]
}
