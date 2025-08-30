output "launch_template_id" {
  description = "ID of the launch template"
  value       = aws_launch_template.main.id
}

output "autoscaling_group_name" {
  description = "Name of the Auto Scaling Group"
  value       = aws_autoscaling_group.main.name
}

output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.launch_template_sg.id
}