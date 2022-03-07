packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.2"
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
  name    = "packer-${var.os_name}-${var.os_version}-golden"
  sources = ["source.amazon-ebs.ubuntu"]

  # execute commands before push image to HCP registry
  provisioner "shell" {
    inline = [
      "sudo apt update",
      "sudo apt install -y nginx",
      "sudo ufw enable",
      "sudo ufw allow 'nginx http' && sudo ufw allow 'nginx https'",
      "sudo ufw reload && sudo systemctl enable nginx"
    ]
  }


  # push new artifact to HCP registry
  hcp_packer_registry {
    bucket_name = "${var.os_name}-${var.os_cpu_arch}-${var.os_suffix}"
    description = <<EOT
This is a golden image base built on top of ubuntu 20.04.
    EOT
    bucket_labels = {
      "team"       = "engineering",
      "os"         = "ubuntu",
      "os-version" = "20.04"
    }
  }

}
