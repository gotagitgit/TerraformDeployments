variable "application" {
  type    = string
  default = "app"
}

variable "s3_bucket_name" {
    description = "Name of bucket"
    type = string
}

variable "s3_key" {
  type        = string
  description = "S3 key for the Lambda deployment package"
}

variable "destroy_bucket_on_teardown" {
    description = "If true, enables force_destroy. If false, prevents bucket destruction."
    type = bool
    default = true
}

variable "environment" {
  type        = string
  description = "Environment (e.g., dev, prod)"
  default     = "dev"
}

variable "tag" {
  type        = string
  description = "application tag"
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