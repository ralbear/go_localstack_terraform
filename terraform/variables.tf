variable "aws_region" {
  type = string
}

variable "aws_access_key" {
  type = string
}

variable "aws_secret_key" {
  type = string
}

variable "functions" {
  api_gateway = {
    "api_get_grettings" = {}
  },
  sqs = {

  }
}
