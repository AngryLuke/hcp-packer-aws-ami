packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

local "full_source_ami_name" {
  expression = "${var.source_ami_name}-${local.timestamp}"
  sensitive  = false
}

local "filter_name" {
  expression = "${var.ami_name_filter}-*"
  sensitive  = false
}

locals {
  mandatory_tags = {
    "Owner"     = var.ami_owner
    "timestamp" = local.timestamp
  }
}

source "amazon-ebs" "ubuntu" {
  ami_name      = local.full_source_ami_name
  instance_type = var.ami_instance_type
  region        = var.ami_region
  source_ami_filter {
    filters = {
      name                = local.filter_name
      root-device-type    = var.ami_root_dev_type
      virtualization-type = var.ami_root_virt_type
    }
    most_recent = var.ami_most_recent
    owners      = [var.source_ami_owner]
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
    bucket_name = "${var.ami_name}-${var.ami_owner}"
    description = <<EOT
This is a test where image being published to HCP Packer Registry.
    EOT
    bucket_labels = {
      "version" = "1.0.0",
      "region"  = var.ami_region,
    }
  }
  sources = [
    "source.amazon-ebs.eu-weast-3"
  ]
}
