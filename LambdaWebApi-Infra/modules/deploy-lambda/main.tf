locals {
    function_name = "${var.application}-aspnet-core-api"
} 

# Creates S3 Bucket
resource "aws_s3_bucket" "deployment_bucket" {
  bucket = var.s3_bucket_name
  force_destroy = var.destroy_bucket_on_teardown
}

# IAM role for Lambda
resource "aws_iam_role" "lambda_role" {  
  name = "${local.function_name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Custom IAM policy for Lambda
resource "aws_iam_role_policy" "lambda_policy" {
  name = "${local.function_name}-policy"
  role = aws_iam_role.lambda_role.id

  policy = templatefile("${path.module}/policies/lambda-role-policy.json", {
    s3_bucket = var.s3_bucket_name
  })
}

# Basic Lambda execution policy
resource "aws_iam_role_policy_attachment" "lambda_basic" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_role.name
}

# Lambda function
resource "aws_lambda_function" "api_lambda" {
  function_name = local.function_name
  role          = aws_iam_role.lambda_role.arn
  handler       = "LambdaWebApi::LambdaWebApi.LambdaEntryPoint::FunctionHandlerAsync"
  runtime       = "dotnet8" 

  s3_bucket = var.s3_bucket_name
  s3_key    = aws_s3_object.package_upload_to_s3.key ## <-- this is the deployment/package.zip

  memory_size = 512  # Adjust based on your needs
  timeout     = 30   # Adjust based on your needs

  environment {
    variables = {
      Environment = var.environment
      ASPNETCORE_ENVIRONMENT = var.environment
    }
  }

  depends_on = [aws_s3_object.package_upload_to_s3]
}

# API Gateway
resource "aws_apigatewayv2_api" "lambda_api" {
  name          = var.api_name
  protocol_type = "HTTP"
}

# API Gateway stage
resource "aws_apigatewayv2_stage" "lambda_stage" {
  api_id = aws_apigatewayv2_api.lambda_api.id
  name   = var.stage_name
  auto_deploy = true
}

# API Gateway integration with Lambda
resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id = aws_apigatewayv2_api.lambda_api.id

  integration_type   = "AWS_PROXY"
  integration_method = "POST"
  integration_uri    = aws_lambda_function.api_lambda.invoke_arn
}

# API Gateway route
resource "aws_apigatewayv2_route" "lambda_route" {
  api_id = aws_apigatewayv2_api.lambda_api.id
  route_key = "ANY /{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

# Lambda permission for API Gateway
resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.api_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.lambda_api.execution_arn}/*/*"
}