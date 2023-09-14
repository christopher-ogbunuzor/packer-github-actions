# Using amazon linux 2 since it comes with SSM agent installed
# No need to install agent again
# if not, we would need to install ssm agent if not amazon linux ami

data "aws_ami" "packer_latest_ami_ssm" {
  most_recent = true

#   filter {
#     name   = "owner-alias"
#     values = ["amazon"]
#   }

  filter {
    name   = "name"
    values = ["packer-custom-ami*"]
  }
}

# data "aws_ami" "my_aws_ami" {
#   owners      = ["099720109477"]
#   most_recent = true
#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
#   }
# }