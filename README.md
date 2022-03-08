# hcp-packer-aws-ec2-ubuntu
This repo contains a demo on how to use HCP Packer for manage an AWS EC2 AMI

## Prerequisites for use HCP Packer

* Packer must be at least version 1.7.9
Refer to this link for update/install it: https://learn.hashicorp.com/tutorials/packer/get-started-install-cli
* HCP account
* Public cloud account

## Get owner-id of an AMI image
Actually this repo works for eu-central-1 and eu-west-3 AWS regions

```
aws ec2 describe-images --image-ids ami-0c6ebbd55ab05f070 --region eu-west-3 | jq -r ".Images[].OwnerId"
aws ec2 describe-images --image-ids ami-0d527b8c289b4af7f --region eu-central-1 | jq -r ".Images[].OwnerId"
```

## Configure your env to make it use HCP Packer

Refer to this link for setup HCP Packer: https://learn.hashicorp.com/tutorials/packer/hcp-push-image-metadata?in=packer/hcp-get-started

export HCP_CLIENT_ID=
export HCP_CLIENT_SECRET=

```
packer init .
packer fmt .
packer validate .
```

### Build semplice
```
packer build <file>.hcl
```

Or if you want to use a variables file, first create a file *.pkrvars.hcl 

```
packer build --var-file=<file.pkrvars.hcl> <file.pkr.hcl>
```

