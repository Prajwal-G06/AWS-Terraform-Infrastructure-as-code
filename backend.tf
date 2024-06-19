terraform {
  backend "s3" {
    bucket = "demo65"
    key    = "terraform/backend"
    region = "ap-south-1"
  }
}

