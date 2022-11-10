variable "aws_region" {
  type = string
}

variable "aws_access_key" {
  type = string
}

variable "aws_secret_key" {
  type = string
}

variable "localstack_url" {
  description = "Localstack endpoint"
  default     = "http://localhost:4566"
}

variable "functions" {
  default = {
    api_gateway = {
      "api_get_greetings" = {
        "method" = "GET",
        "path" = "hello",
        "stage" = "dev"
      }
    },
    sqs = {
      "sqs_greetings" = {}
    }
  }
}
