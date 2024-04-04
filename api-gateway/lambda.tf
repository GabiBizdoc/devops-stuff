resource "aws_lambda_function" "hello_world_lambda" {
  filename      = "${path.module}/dist/app.zip"
  function_name = "hello-world-lambda"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler"
  runtime       = "nodejs20.x"

  source_code_hash = filebase64sha256("${path.module}/dist/app.zip")

  tracing_config {
    mode = "Active"
  }

  # Environment variables for the Lambda function
  environment {
    variables = {}
  }
}

# IAM Role resource block for Lambda function
resource "aws_iam_role" "lambda_role" {
  name = "lambda_role"

  # Assume role policy allowing Lambda service to assume this role
  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "hello_lambda_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_role.name
}
