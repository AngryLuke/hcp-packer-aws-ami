variable "ami_eu_region_west_3" {
  type    = string
  default = "eu-west-3"
}

variable "source_ami_owner_eu_west_3" {
  type    = string
  default = "099720109477"
}

variable "ami_eu_region_central_1" {
  type    = string
  default = "eu-central-1"
}
variable "source_ami_owner_eu_central_1" {
  type    = string
  default = "099720109477"
}

// variable "ami_regions" {
//   type    = list(string)
//   default = ["eu-west-3", "eu-central-1"]
// }

// variable "source_ami_owners" {
//   type    = list(string)
//   default = ["099720109477", "137112412989"]
// }

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

variable "os_name" {
  type    = string
  default = "ubuntu"
}

variable "os_custom_name" {
  type    = string
  default = "focal"
}

variable "os_cpu_arch" {
  type    = string
  default = "amd64"
}

variable "os_suffix" {
  type    = string
  default = "server"
}

variable "os_version" {
  type    = string
  default = "20.04"
}

variable "source_ami_name" {
  type    = string
  default = "packer-aws-ubuntu-20.04"
}

variable "ami_name" {
  type    = string
  default = "aws-ubuntu"
}

variable "ami_owner" {
  type    = string
  default = "lbolli"
}
