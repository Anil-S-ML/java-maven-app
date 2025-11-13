variable "avail_zone" {
  default = "us-east-1"
}
variable "vpc_cider_block" {
  default = "10.0.0.0/16"
}
variable "subnet_cider_block" {
  default = "10.0.100.0/24"
}
variable "env_prefix" {
  default = "dev"
}
variable "my_ip" {
  default = "0.0.0.0/0"
}
variable "jenkins_ip"{
  default = "104.214.169.48/32"
}
variable "instance_type" {
  default = "t2.micro"
}
variable "region" {
  default = "eu-west-3"
}