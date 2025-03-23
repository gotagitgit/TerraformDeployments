variable "application" {
  type    = string
  default = "app1"
  description = "name of your application you want to deploy"
}

variable "environment" {
  type    = string
  default = "dev"
  validation {
    condition     = contains(["dev", "prod", "staging"], var.environment)
    error_message = "Environment must be one of: dev, prod, staging"
  }
}

variable "destroy_bucket_on_teardown" {
    description = "If true, enables force_destroy. If false, prevents bucket destruction."
    type = bool
    default = true
}

variable "s3_bucket_name" {
  type        = string
  description = "Name of the S3 bucket"
}

variable "s3_key" {
  type        = string
  description = "Subfolder where package is copied"
}

variable "tag" {
  type        = string
  description = "Value for the Name tag"
}

variable "api_name" {
  type        = string
  description = "Name of the API Gateway"
}

variable "stage_name" {
  type        = string
  description = "Name of the API Gateway stage"
  default     = "dev"
}

variable "package_name" {
  type        = string
  description = "Compressed file package name *.zip"
}

variable "application_dir" {
  type = string
  description = "Path of your .net project. Relative to LambdaWebApi-infra folder i.e. ..\\..\\my-dotnet-project"
}