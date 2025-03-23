provider "aws" {
  region = "us-east-1" 
  
  # Optional: Add default tags for all resources
  default_tags {
    tags = {
      Environment = var.environment
      Terraform   = "true"
      Project     = "lambda-web-api"
    }
  }
}