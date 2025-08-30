variable aws_profile {
  description = "The AWS profile to use"
  nullable    = true
  type        = string
}

variable aws_region {
  description = "The AWS region to use"
  nullable    = false
  type        = string
}

variable "launch_template_name" {
  description = "Name of the launch template"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "health_check_grace_period" {
  description = "Health check grace period in seconds"
  type        = number
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "tag_prefix" {
  description = "Prefix for resource tags"
  type        = string
}