provider "aws" {
  region = var.REGION
}
locals {
  name = "ecs-tags"
}