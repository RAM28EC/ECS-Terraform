variable "REGION" {
  default = "ap-south-1"
}
variable "AMIS" {
 default  = "ami-0287a05f0ef0e9d9a"
}


variable "USERNAME" {
  default = "ubuntu"
}
variable "MYIP" {
  default = "202.89.77.101/32"
}

variable "instance_count" {
  default = "1"
}
variable "VPC_NAME" {
  default = "task-vpc"
}
variable "ZONE1" {
  default = "ap-south-1a"
}
variable "ZONE2" {
  default = "ap-south-1b"
}
variable "ZONE3" {
  default = "ap-south-1c"
}

variable "vpccidr" {
  default = "172.21.0.0/16"
}
variable "PubSub1cidr" {
  default = "172.21.1.0/24"
}
variable "PubSub2cidr" {
  default = "172.21.2.0/24"
}
variable "PubSub3cidr" {
  default = "172.21.3.0/24"
}

variable "PrivSub1cidr" {
  default = "172.21.5.0/24"
}
variable "PrivSub2cidr" {
  default = "172.21.6.0/24"
}
variable "PrivSub3cidr" {
  default = "172.21.7.0/24"
}
