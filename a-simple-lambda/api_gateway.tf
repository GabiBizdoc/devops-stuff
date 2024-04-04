# Define an AWS API Gateway v2 API resource
resource "aws_apigatewayv2_api" "api" {
  name          = var.app_name
  protocol_type = "HTTP"

}

# Define a CloudWatch Logs group to store logs related to the API Gateway
resource "aws_cloudwatch_log_group" "hello_api_gateway" {
  name              = "/aws/api-gateway/${aws_apigatewayv2_api.api.name}"
  retention_in_days = 7
}

# Define a stage for the API with automatic deployment enabled and request-based access logging.
resource "aws_apigatewayv2_stage" "stage" {
  api_id      = aws_apigatewayv2_api.api.id
  name        = var.api_stage_name
  auto_deploy = true

  # Configure access log settings for the stage
  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.hello_api_gateway.arn
    format          = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      httpMethod              = "$context.httpMethod"
    })
  }
}

# Define an integration between the API Gateway and our Lambda function
resource "aws_apigatewayv2_integration" "lambda_hello" {
  api_id             = aws_apigatewayv2_api.api.id
  integration_type   = "AWS_PROXY"
  integration_uri    = aws_lambda_function.hello_world_lambda.invoke_arn
  integration_method = "POST"
}

# Define a route for the API that directs requests to the Lambda integration
resource "aws_apigatewayv2_route" "any_hello" {
  api_id    = aws_apigatewayv2_api.api.id
  #  route_key = "ANY /{proxy+}"
  route_key = "$default"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_hello.id}"
}

# Define permissions for the API Gateway to invoke the Lambda function
resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.hello_world_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.api.execution_arn}/*/*"
}
