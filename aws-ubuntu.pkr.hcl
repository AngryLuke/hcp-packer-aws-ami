packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.1"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

local "full_source_ami_name" {
  expression = "packer-aws-${var.os_name}-${var.os_version}-${local.timestamp}"
  sensitive  = false
}

local "filter_name" {
  expression = "${var.os_name}/images/*${var.os_name}-${var.os_custom_name}-${var.os_version}-${var.os_cpu_arch}-${var.os_suffix}-*"
  sensitive  = false
}

locals {
  mandatory_tags = {
    "Owner"      = var.ami_owner
    "timestamp"  = local.timestamp
    "os"         = "ubuntu"
    "os-version" = "20.04"
  }
}

source "amazon-ebs" "ubuntu-eu-west-3" {
  ami_name      = local.full_source_ami_name
  instance_type = var.ami_instance_type
  region        = "eu-west-3"
  source_ami_filter {
    filters = {
      name                = local.filter_name
      root-device-type    = var.ami_root_dev_type
      virtualization-type = var.ami_root_virt_type
    }
    most_recent = var.ami_most_recent
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"

  # add tag
  tags = "${merge(
    local.mandatory_tags,
    {
      Name = local.full_source_ami_name
    }
  )}"
}

source "amazon-ebs" "ubuntu-eu-west-1" {
  ami_name      = local.full_source_ami_name
  instance_type = var.ami_instance_type
  region        = "eu-west-1"
  source_ami_filter {
    filters = {
      name                = local.filter_name
      root-device-type    = var.ami_root_dev_type
      virtualization-type = var.ami_root_virt_type
    }
    most_recent = var.ami_most_recent
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"

  # add tag
  tags = "${merge(
    local.mandatory_tags,
    {
      Name = local.full_source_ami_name
    }
  )}"
}

source "amazon-ebs" "ubuntu-eu-west-2" {
  ami_name      = local.full_source_ami_name
  instance_type = var.ami_instance_type
  region        = "eu-west-2"
  source_ami_filter {
    filters = {
      name                = local.filter_name
      root-device-type    = var.ami_root_dev_type
      virtualization-type = var.ami_root_virt_type
    }
    most_recent = var.ami_most_recent
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"

  # add tag
  tags = "${merge(
    local.mandatory_tags,
    {
      Name = local.full_source_ami_name
    }
  )}"
}

source "amazon-ebs" "ubuntu-eu-central-1" {
  ami_name      = local.full_source_ami_name
  instance_type = var.ami_instance_type
  region        = "eu-central-1"
  source_ami_filter {
    filters = {
      name                = local.filter_name
      root-device-type    = var.ami_root_dev_type
      virtualization-type = var.ami_root_virt_type
    }
    most_recent = var.ami_most_recent
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"

  # add tag
  tags = "${merge(
    local.mandatory_tags,
    {
      Name = local.full_source_ami_name
    }
  )}"
}

source "amazon-ebs" "ubuntu-eu-north-1" {
  ami_name      = local.full_source_ami_name
  instance_type = var.ami_instance_type
  region        = "eu-north-1"
  source_ami_filter {
    filters = {
      name                = local.filter_name
      root-device-type    = var.ami_root_dev_type
      virtualization-type = var.ami_root_virt_type
    }
    most_recent = var.ami_most_recent
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"

  # add tag
  tags = "${merge(
    local.mandatory_tags,
    {
      Name = local.full_source_ami_name
    }
  )}"
}

build {
  hcp_packer_registry {
    bucket_name = "${var.os_name}-${var.os_cpu_arch}-${var.os_suffix}"
    channel     = "staging"
    description = <<EOT
This is a test where image being published to HCP Packer Registry.
    EOT
    bucket_labels = {
      "team"       = "engineering",
      "os"         = "ubuntu",
      "os-version" = "20.04"
    }
  }

  sources = [
    "source.amazon-ebs.ubuntu-eu-west-3",
    "source.amazon-ebs.ubuntu-eu-west-1",
    "source.amazon-ebs.ubuntu-eu-west-2",
    "source.amazon-ebs.ubuntu-eu-central-1",
    "source.amazon-ebs.ubuntu-eu-north-1"
  ]

  provisioner "shell" {
    inline = [
      "sudo apt update",
      "sudo apt install -y nginx",
      "sudo ufw enable",
      "sudo ufw allow 'nginx http' && sudo ufw allow 'nginx https'",
      "sudo ufw reload && sudo systemctl enable nginx"
    ]
  }

}
