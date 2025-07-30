output "public_ip" {
  value = aws_instance.web.public_ip
}

output "site_url" {
  value = "http://${aws_instance.web.public_ip}"
}
