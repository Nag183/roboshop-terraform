terraform {
  backend "s3" {
    bucket = "terra-d72"
    key    = "roboshop/dev/terraform.tfstate"
    region = "us-east-1"
  }
}
