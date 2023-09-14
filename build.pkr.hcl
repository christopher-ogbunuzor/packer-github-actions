// source "amazon-ebs" "ubuntu-lts" {
//   region = "us-west-1"
//   source_ami_filter {
//     filters = {
//       virtualization-type = "hvm"
//       name                = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
//       root-device-type    = "ebs"
//     }
//     owners      = ["099720109477"]
//     most_recent = true
//   }
//   instance_type  = "t2.small"
//   ssh_username   = "ubuntu"
//   ssh_agent_auth = false

//   ami_name    = "hashicups_{{timestamp}}"
//   ami_regions = ["us-west-1"]
// }

// build {
//   sources = [
//     "source.amazon-ebs.ubuntu-lts",
//   ]

//   # systemd unit for HashiCups service
//   provisioner "file" {
//     source      = "hashicups.service"
//     destination = "/tmp/hashicups.service"
//   }

//   # Set up HashiCups
//   provisioner "shell" {
//     scripts = [
//       "setup-deps-hashicups.sh"
//     ]
//   }

//   post-processor "manifest" {
//     output     = "packer_manifest.json"
//     strip_path = true
//     custom_data = {
//       iteration_id = packer.iterationID
//     }
//   }
// }

// # This file was autogenerated by the 'packer hcl2_upgrade' command. We
// # recommend double checking that everything is correct before going forward. We
// # also recommend treating this file as disposable. The HCL2 blocks in this
// # file can be moved to other files. For example, the variable blocks could be
// # moved to their own 'variables.pkr.hcl' file, etc. Those files need to be
// # suffixed with '.pkr.hcl' to be visible to Packer. To use multiple files at
// # once they also need to be in the same folder. 'packer inspect folder/'
// # will describe to you what is in that folder.

// # Avoid mixing go templating calls ( for example ```{{ upper(`string`) }}``` )
// # and HCL2 calls (for example '${ var.string_value_example }' ). They won't be
// # executed together and the outcome will be unknown.

// # See https://www.packer.io/docs/templates/hcl_templates/blocks/packer for more info
// packer {
//   required_plugins {
//     amazon = {
//       source  = "github.com/hashicorp/amazon"
//       version = "~> 1"
//     }
//     ansible = {
//       source  = "github.com/hashicorp/ansible"
//       version = "~> 1"
//     }
//   }
// }

// # All generated input variables will be of 'string' type as this is how Packer JSON
// # views them; you can change their type later on. Read the variables type
// # constraints documentation
// # https://www.packer.io/docs/templates/hcl_templates/variables#type-constraints for more info.
// // variable "aws_access_key" {
// //   type    = string
// //   default = "${env("AWS_ACCESS_KEY_ID")}"
// // }

// variable "aws_region" {
//   type    = string
//   default = "eu-west-2"
// }

// // variable "aws_secret_key" {
// //   type    = string
// //   default = "${env("AWS_SECRET_ACCESS_KEY")}"
// // }

// # The amazon-ami data block is generated from your amazon builder source_ami_filter; a data
// # from this block can be referenced in source and locals blocks.
// # Read the documentation for data blocks here:
// # https://www.packer.io/docs/templates/hcl_templates/blocks/data
// # Read the documentation for the Amazon AMI Data Source here:
// # https://www.packer.io/plugins/datasources/amazon/ami

// // data "amazon-ami" "autogenerated_1" {
// //   // access_key = "${var.aws_access_key}"
// //   filters = {
// //     name                = "ubuntu/images/*ubuntu-xenial-16.04-amd64-server*"
// //     root-device-type    = "ebs"
// //     virtualization-type = "hvm"
// //   }
// //   most_recent = true
// //   owners      = ["099720109477"]
// //   region      = "${var.aws_region}"
// //   // secret_key  = "${var.aws_secret_key}"
// // }

// # source blocks are generated from your builders; a source can be referenced in
// # build blocks. A build block runs provisioner and post-processors on a
// # source. Read the documentation for source blocks here:
// # https://www.packer.io/docs/templates/hcl_templates/blocks/source
// source "amazon-ebs" "autogenerated_1" {
//   // access_key    = "${var.aws_access_key}"
//   ami_name      = "devylawyer-image"
//   instance_type = "t2.micro"
//   region        = "us-east-1"

//   // region        = "${var.aws_region}"
//   // secret_key    = "${var.aws_secret_key}" 
//   // source_ami    = "${data.amazon-ami.autogenerated_1.id}"

//   source_ami    = "ami-08c40ec9ead489470"
//   ssh_username  = "ubuntu"
// }

// # a build block invokes sources and runs provisioning steps on them. The
// # documentation for build blocks can be found here:
// # https://www.packer.io/docs/templates/hcl_templates/blocks/build
// build {
//   sources = ["source.amazon-ebs.autogenerated_1"]

//   provisioner "ansible" {
//     playbook_file = "./ansible/ansible_playbook.yml"
//   }

// }

packer {
 required_plugins {
   amazon = {
     source = "github.com/hashicorp/amazon"
     version = "~> 1.1.1"
   }
 }
}

// variable "timestamp" {
//   default = timestamp()
// }

locals {
  packerstarttime = formatdate("YYYY-MM-DD-hhmm", timestamp())
  # Also here I believe naming this variable `buildtime` could lead to 
  # confusion mainly because this is evaluated a 'parsing-time'.
}

source "amazon-ebs" "custom-ami" {
 ami_name      = "packer-custom-ami-${local.packerstarttime}"
 instance_type = "t2.micro"
 region        = "us-east-1"
 source_ami    = "ami-08c40ec9ead489470"
 ssh_username  = "ubuntu"
//  profile       = "aws-profile-name". REMOVED SO IT WILL USE MY AWS CLI CREDS
 tags = {
   Name = "packer-custom-ami"
 }
}
build {
 sources = ["source.amazon-ebs.custom-ami"]

 provisioner "ansible" {
   playbook_file = "./ansible/playbook.yml"
   user          = "ubuntu"
   ansible_ssh_extra_args = ["-o HostKeyAlgorithms=+ssh-rsa"]

  //  ansible_ssh_extra_args = ["-o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedAlgorithms=+ssh-rsa"]
  //  extra_arguments = ["-vvv"]
 }
}

