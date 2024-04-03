# Terraform AWS Lambda Deployment

This project demonstrates setting up an API in AWS cloud using Terraform. It:

- Creates an API Gateway v2 HTTP API.
- Sets up a stage with automatic deployment and access log settings.
- Establishes a CloudWatch log group for API Gateway.
- Configures logs to include HTTP method, request ID, source IP, and request time.
- Integrates an AWS Lambda function with API Gateway.
- Creates a default route for the Lambda integration.
- Sets Lambda function permission for API Gateway invocation.
- Generates a domain name for API Gateway.
- Requests an ACM certificate for the domain.
- Configures DNS validation for the ACM certificate.
- Maps the domain name to the API Gateway stage.
- Defines an AWS Lambda function with Node.js 20.x runtime.
- Attaches the AWSLambdaBasicExecutionRole policy to the Lambda IAM role.
- Defines the AWS provider with region and profile configurations.
- Provides outputs for the API stage URL and domain name ID.

TODO: 
- [ ] Continuous deployment via github actions
- [ ] Improve documentation

NOTE: This setup is compatible only on Unix system
## Prerequisites

Before you begin, ensure you have the following prerequisites installed:

- [Terraform](https://developer.hashicorp.com/terraform/install)
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) configured with appropriate permissions
- [Nodejs](https://nodejs.org/en/download) and [PNPM](https://pnpm.io/installation)

## Usage

1. Clone the Repository
    ```bash
    git clone git@github.com:GabiBizdoc/terraform-with-me.git
    cd a-simple-lambda
    ```

2. Build the Lambda Function
    ```sh
    cd app/scripts && ./sh build.sh
    ```
3. Configure your environment by creating a file named `terraform.tfvars` based on this example.
   ```tf
   # region: Specifies the AWS region where resources will be deployed
   region = "us-west-2"
   # profile: Refers to the AWS CLI profile used for authentication
   profile = "my_aws_profile"
   # app_name: Represents the name of the API
   app_name = "my_api"
   # stage_name: Indicates the stage name (e.g., dev, prod, test, stage...)
   stage_name = "dev"
   # domain_name: Specifies the domain name for the API Gateway
   domain_name = "example.com"
   # zone_id: Refers to the Route 53 hosted zone ID for DNS configuration
   zone_id = "ABC123DEF456"
   ```
4. Initialize Terraform by running the following command:
    ```sh
        terraform init
    ```

5. Review the execution plan by running (optional):
   ```sh
       terraform plan -out=terraform.plan
   ```

6. Apply the Terraform configuration to create the AWS resources:
    ```sh
        terraform apply
        # or
        terraform apply terraform.plan
    ```

7. Cleanup
    ```sh
        terraform destroy
    ```
