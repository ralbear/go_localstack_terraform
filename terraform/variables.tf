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
  default = {
    api_gateway = {
      "api_get_grettings" = {
        "method" = "GET",
        "path" = "/hello"
      }
    },
    sqs = {

    }
  }
}
