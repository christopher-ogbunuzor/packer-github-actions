terraform {
  backend "s3" {
    bucket         = "chris16555tfstate"
    key            = "PackerAnsible/terraform.tfstate"
    dynamodb_table = "terraform-lock"
  }
}