variable "project_name" {
  description = "Project Name"
  type = string
  default = "aws_ecs_study"
}

variable "administrator_cidr_blocks" {
  description = "Administrator CIDR Blocks"
  type = list(string)
}

variable "ssh_key_name" {
  description = "SSH Key Name For Instance Login"
  type = string
}

variable "access_key" {
  description = "AWS Access Key"
  type = string
}

variable "secret_key" {
  description = "AWS Secret Key"
  type = string
}

variable "region" {
  description = "AWS Region"
  type = string
  default = "ap-northeast-1"
}

variable "vpc_cidr_block" {
  description = "VPC CIDR Block"
  type = string
  default = "192.168.0.0/16"
}

variable "subnet_1_cidr_block" {
  description = "Subnet-1 CIDR Block"
  type = string
  default = "192.168.0.0/24"
}

variable "subnet_2_cidr_block" {
  description = "Subnet-2 CIDR Block"
  type = string
  default = "192.168.1.0/24"
}

variable "subnet_1_az" {
  description = "Subnet-1 Availability Zone"
  type = string
  default = "ap-northeast-1a"
}

variable "subnet_2_az" {
  description = "Subnet-2 Availability Zone"
  type = string
  default = "ap-northeast-1c"
}

variable "ami" {
  description = "Container Instance AMI"
  type = string
  default = "ami-0d4cb7ae9a06c40c9"

}
