provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key

  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    apigateway       = var.localstack_url
    cloudformation   = var.localstack_url
    cloudwatch       = var.localstack_url
    cloudwatchevents = var.localstack_url
    cloudwatchlogs   = var.localstack_url
    dynamodb         = var.localstack_url
    ec2              = var.localstack_url
    es               = var.localstack_url
    iam              = var.localstack_url
    lambda           = var.localstack_url
    rds              = var.localstack_url
    s3               = var.localstack_url
    secretsmanager   = var.localstack_url
    sns              = var.localstack_url
    sqs              = var.localstack_url
  }
}
