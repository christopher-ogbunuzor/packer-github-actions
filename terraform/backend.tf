terraform {
  backend "s3" {
    bucket         = "chris16555tfstateeast"
    key            = "PackerAnsible/terraform.tfstate"
    dynamodb_table = "terraform-lock-east"
  }
}