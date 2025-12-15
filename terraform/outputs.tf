
output "ec2_public_ip_1" {
  value = aws_instance.my_app_server_one.public_ip
}