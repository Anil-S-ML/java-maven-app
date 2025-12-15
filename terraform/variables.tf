# variable "avail_zone" {
#   default = "us-east-1a"
# }
# variable "vpc_cider_block" {
#   default = "10.0.0.0/16"
# }
# variable "subnet_cider_block" {
#   default = "10.0.10.0/24"
# }
# variable "env_prefix" {
#   default = "dev"
# }
# variable "my_ip" {
#   default = "0.0.0.0/0"
# }
# variable "jenkins_ip"{
#   default = "104.214.169.48/32"
# }
# variable "instance_type" {
#   default = "t3.micro"
# }
# variable "region" {
#   default = "us-east-1"
# }

variable "vpc_cidr_block" {}
variable "subnet_cidr_block" {}
variable "avail_zone" {}
variable "env_prefix" {}
variable "my_ip" {}
variable "instance_type" {}
variable "my_public_key" {}
# variable "ssh_private_key"{}