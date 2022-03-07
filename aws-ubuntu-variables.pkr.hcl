variable "ami_region" {
  type    = string
  default = "eu-west-3"
}

variable "source_ami_owner" {
  type    = string
  default = "099720109477"
}

variable "ami_instance_type" {
  type    = string
  default = "t3.micro"
}

variable "ami_name_filter" {
  type    = string
  default = "ubuntu/images/*ubuntu-focal-20.04-amd64-server"
}

variable "ami_root_dev_type" {
  type    = string
  default = "ebs"
}

variable "ami_root_virt_type" {
  type    = string
  default = "hvm"
}

variable "ami_most_recent" {
  type    = bool
  default = true
}

variable "source_ami_name" {
  type    = string
  default = "packer-aws-ubuntu-20.04"
}

variable "ami_name" {
  type    = string
  default = "aws-ubuntu-20.04"
}

variable "ami_owner" {
  type    = string
  default = "lbolli"
}



