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
  count         = "${lenght(var.ami_regions)}"
  ami_name      = local.full_source_ami_name
  instance_type = var.ami_instance_type
  //region        = var.ami_eu_region_west_3
  region = "${var.ami_regions[count.list]}"
  source_ami_filter {
    filters = {
      name                = local.filter_name
      root-device-type    = var.ami_root_dev_type
      virtualization-type = var.ami_root_virt_type
    }
    most_recent = var.ami_most_recent
    //owners      = [var.source_ami_owner_eu_west_3]
    owners = "${var.source_ami_owners[count.list]}"
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

// source "amazon-ebs" "ubuntu-eu-west-3" {
//   ami_name      = local.full_source_ami_name
//   instance_type = var.ami_instance_type
//   region        = var.ami_eu_region_west_3
//   source_ami_filter {
//     filters = {
//       name                = local.filter_name
//       root-device-type    = var.ami_root_dev_type
//       virtualization-type = var.ami_root_virt_type
//     }
//     most_recent = var.ami_most_recent
//     owners      = [var.source_ami_owner_eu_west_3]
//   }
//   ssh_username = "ubuntu"

//   # add tag
//   tags = "${merge(
//     local.mandatory_tags,
//     {
//       Name = local.full_source_ami_name
//     }
//   )}"
// }

// source "amazon-ebs" "ubuntu-eu-central-1" {
//   ami_name      = local.full_source_ami_name
//   instance_type = var.ami_instance_type
//   region        = var.ami_eu_region_central_1
//   source_ami_filter {
//     filters = {
//       name                = local.filter_name
//       root-device-type    = var.ami_root_dev_type
//       virtualization-type = var.ami_root_virt_type
//     }
//     most_recent = var.ami_most_recent
//     owners      = [var.source_ami_owner_eu_central_1]
//   }
//   ssh_username = "ubuntu"

//   # add tag
//   tags = "${merge(
//     local.mandatory_tags,
//     {
//       Name = local.full_source_ami_name
//     }
//   )}"
// }

build {
  hcp_packer_registry {
    bucket_name = "${var.ami_name}-${var.ami_owner}"
    description = <<EOT
This is a test where image being published to HCP Packer Registry.
    EOT
    bucket_labels = {
      "team"       = "ubuntu-server",
      "os"         = "ubuntu",
      "os-version" = "20.04"
    }
  }

  sources = ["source.amazon-ebs.ubuntu"]
  // sources = [
  //   "source.amazon-ebs.ubuntu-eu-west-3", 
  //   "source.amazon-ebs.ubuntu-eu-central-1" 
  // ]
}
