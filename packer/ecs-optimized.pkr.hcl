packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.1"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "ami_prefix" {
  type    = string
  default = "custom-ecs-optimized"
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "amazon-ebs" "ecs-optimized" {
  ami_name      = "${var.ami_prefix}-${local.timestamp}"
  instance_type = "t2.micro"
  region        = "ap-northeast-1"
  source_ami_filter {
    filters = {
      name                = "amzn2-ami-ecs-hvm-*-x86_64-ebs"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["amazon"]
  }
  ssh_username = "ec2-user"
}

build {
  sources = [
    "source.amazon-ebs.ecs-optimized"
  ]

  provisioner "shell" {
    inline = [
      "sudo amazon-linux-extras install epel -y",
      "sudo yum -y update",
      "sudo yum install ansible -y"
    ]
  }

  provisioner "ansible-local" {
    playbook_file = "./playbook.yml"
  }
}
