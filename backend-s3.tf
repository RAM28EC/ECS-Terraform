terraform {
  backend "s3" {
    bucket = "terra-task-state21"
    key    = "terraform1/backend"
    region = "ap-south-1"
  }
}