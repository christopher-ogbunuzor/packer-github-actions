module "network" {
  source = "github.com/chris-cloudreach/talent-academy-vpc-module"

  vpc_cidr         = var.vpc_cidr
  region           = var.region
  vpc_name         = var.vpc_name
  internet_gw_name = var.internet_gw_name
  public_a_cidr    = var.public_a_cidr
  # public_b_cidr    = var.public_b_cidr
  # public_c_cidr    = var.public_c_cidr
  private_a_cidr   = var.private_a_cidr
}

# EC2 - PUBLIC
resource "aws_instance" "my_public_server" {
  count                  = 5
  ami                    = data.aws_ami.packer_latest_ami_ssm.id
  instance_type          = var.instance_type

  # no need to specify keyname as we using ssm
    # key_name               = var.keypair_name

  # use private subnet
  subnet_id              = module.network.private_subnet_a_id
  vpc_security_group_ids = [
    aws_security_group.my_app_sg.id
    ]
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name

}