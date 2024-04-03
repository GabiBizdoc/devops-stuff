
resource "aws_apigatewayv2_api" "api" {
  name          = var.app_name
  protocol_type = "HTTP"

}

resource "aws_apigatewayv2_stage" "stage" {
  api_id      = aws_apigatewayv2_api.api.id
  name        = var.stage_name
  auto_deploy = true

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

resource "aws_cloudwatch_log_group" "hello_api_gateway" {
  name              = "/aws/api-gateway/${aws_apigatewayv2_api.api.name}"
  retention_in_days = 7
}

resource "aws_apigatewayv2_integration" "lambda_hello" {
  api_id             = aws_apigatewayv2_api.api.id
  integration_type   = "AWS_PROXY"
  integration_uri    = aws_lambda_function.hello_world_lambda.invoke_arn
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "any_hello" {
  api_id    = aws_apigatewayv2_api.api.id
  #  route_key = "ANY /{proxy+}"
  route_key = "$default"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_hello.id}"
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.hello_world_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.api.execution_arn}/*/*"
}
