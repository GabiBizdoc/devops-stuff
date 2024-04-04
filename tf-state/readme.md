# Setting up Terraform with S3 Backend and DynamoDB Lock Table

## Steps

1. **Remove Existing `backend.tf` File**:
    - If a `backend.tf` file exists in your project directory, remove it using the command:
      ```shell
      rm backend.tf
      ```

2. **Initialize Terraform**:
    - Run the following command to initialize Terraform:
      ```shell
      terraform init
      ```

3. **Apply Changes**:
    - Execute the following command to apply the defined infrastructure changes:
      ```shell
      terraform apply
      ```

4. **Create `backend.tf` File**:
    - Create a new file named `backend.tf` with the following content:
      ```terraform
         terraform {
         backend "s3" {
            encrypt     = true
            config_file = "backend.conf"
         }
      }
      ```

5. **Create `backend.conf` File**:
    - Create a new file named `backend.conf` with the following content:
      ```shell
      key            = "<your-project>/tf-state/terraform.tfstate"
      region         = "<your-region>"
      dynamodb_table = "<your-dynamodb_table-tfstate-lock>"
      bucket         = "<your-tfbackend-bucket>"
      profile        = "<your_aws_cli_profile>"
      ```

6. **Migrate Configuration**:
    - Run the following command to migrate your configuration to use the backend defined in `backend.tf`:
      ```shell
      terraform init -migrate-state
      # or 
      terraform init --backend-config=backend.conf -migrate-state
      ```

7. **Apply Changes**:
    - Run `terraform apply` to use the new backend configuration.
