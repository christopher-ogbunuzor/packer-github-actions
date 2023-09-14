resource "aws_iam_role" "ec2_ssmRole" {
  assume_role_policy = <<POLICY
  {
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Effect": "Allow",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        }
      }
    ],
    "Version": "2012-10-17"
  }
  POLICY

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
   ]
  max_session_duration = "3600"
  name                 = "EC2_SSM_Role"
#   path                 = "/service-role/"

  tags = {
    Name   = "Chef SSM ROLE"
  }

  tags_all = {
    Name   = "Chef SSM ROLE"
    
  }
}



resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "EC2_SSM_Instance_Profile"
  role = aws_iam_role.ec2_ssmRole.name
}