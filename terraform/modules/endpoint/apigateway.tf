resource "aws_api_gateway_rest_api" "api" {
  name = "serverless_hello_world_lambda_gw"
}

resource "aws_api_gateway_gateway_response" "unauthorised" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  status_code   = "401"
  response_type = "UNAUTHORIZED"

  response_templates = {
    "application/json" = "{'message':$context.error.messageString}"
  }

  response_parameters = {
    "gatewayresponse.header.Access-Control-Allow-Origin"  = "'*'"
    "gatewayresponse.header.Access-Control-Allow-Headers" = "'*'"
  }
}

resource "aws_api_gateway_gateway_response" "forbidden" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  status_code   = "403"
  response_type = "DEFAULT_4XX"

  response_templates = {
    "application/json" = "{'message':$context.error.messageString}"
  }

  response_parameters = {
    "gatewayresponse.header.Access-Control-Allow-Origin"  = "'*'"
    "gatewayresponse.header.Access-Control-Allow-Headers" = "'*'"
  }
}

resource "aws_api_gateway_gateway_response" "internal_server_error" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  status_code   = "500"
  response_type = "DEFAULT_5XX"

  response_templates = {
    "application/json" = "{'message':$context.error.messageString}"
  }

  response_parameters = {
    "gatewayresponse.header.Access-Control-Allow-Origin"  = "'*'"
    "gatewayresponse.header.Access-Control-Allow-Headers" = "'*'"
  }
}

resource "aws_api_gateway_resource" "endpoint" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "hello"
}

resource "aws_api_gateway_method" "endpoint" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.endpoint.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "endpoint" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.endpoint.id
  http_method = aws_api_gateway_method.endpoint.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration" "endpoint" {
  depends_on = [
    aws_api_gateway_method.endpoint,
    aws_api_gateway_method_response.endpoint
  ]

  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_method.endpoint.resource_id
  http_method             = aws_api_gateway_method.endpoint.http_method
  integration_http_method = "GET"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.this.invoke_arn
}

resource "aws_api_gateway_integration_response" "endpoint" {
  depends_on = [aws_api_gateway_integration.endpoint]

  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.endpoint.id
  http_method = aws_api_gateway_method.endpoint.http_method
  status_code = aws_api_gateway_method_response.endpoint.status_code

  response_templates = {
    "application/json" = ""
  }
}

#module "cors" {
#  source = "squidfunk/api-gateway-enable-cors/aws"
#  version = "0.3.3"
#
#  api_id          = aws_api_gateway_rest_api.api.id
#  api_resource_id = aws_api_gateway_resource.endpoint.id
#
#  allow_headers = [
#    "Authorization",
#    "Content-Type",
#    "X-Amz-Date",
#    "X-Amz-Security-Token",
#    "X-Api-Key",
#    "X-Charge"
#  ]
#}

resource "aws_api_gateway_deployment" "api" {
  depends_on = [aws_api_gateway_integration_response.endpoint]

  rest_api_id = aws_api_gateway_rest_api.api.id
  description = "Deployed endpoint at ${timestamp()}"
}

resource "aws_api_gateway_stage" "api" {
  stage_name    = "dev"
  rest_api_id   = aws_api_gateway_rest_api.api.id
  deployment_id = aws_api_gateway_deployment.api.id
}











#resource "aws_apigatewayv2_api" "this" {
#  name          = "serverless_hello_world_lambda_gw"
#  protocol_type = "HTTP"
#}
#
#resource "aws_apigatewayv2_stage" "this" {
#  api_id = aws_apigatewayv2_api.this.id
#
#  name        = "serverless_${var.function_name}_lambda_stage"
#  auto_deploy = true
#
#  access_log_settings {
#    destination_arn = aws_cloudwatch_log_group.api_gw_this.arn
#
#    format = jsonencode({
#      requestId               = "$context.requestId"
#      sourceIp                = "$context.identity.sourceIp"
#      requestTime             = "$context.requestTime"
#      protocol                = "$context.protocol"
#      httpMethod              = "$context.httpMethod"
#      resourcePath            = "$context.resourcePath"
#      routeKey                = "$context.routeKey"
#      status                  = "$context.status"
#      responseLength          = "$context.responseLength"
#      integrationErrorMessage = "$context.integrationErrorMessage"
#    }
#    )
#  }
#}
#
#resource "aws_apigatewayv2_integration" "this" {
#  api_id = aws_apigatewayv2_api.this.id
#
#  integration_uri    = aws_lambda_function.this.invoke_arn
#  integration_type   = "AWS_PROXY"
#  integration_method = "POST"
#}
#
#resource "aws_apigatewayv2_route" "this" {
#  api_id = aws_apigatewayv2_api.this.id
#
#  route_key = "${var.method} ${var.path}"
#  target    = "integrations/${aws_apigatewayv2_integration.this.id}"
#}
#
#resource "aws_cloudwatch_log_group" "api_gw_this" {
#  name              = "/aws/api_gw/${aws_apigatewayv2_api.this.name}"
#  retention_in_days = 30
#}
#
#resource "aws_lambda_permission" "this" {
#  statement_id  = "AllowExecutionFromAPIGateway"
#  action        = "lambda:InvokeFunction"
#  function_name = aws_lambda_function.this.function_name
#  principal     = "apigateway.amazonaws.com"
#
#  source_arn = "${aws_apigatewayv2_api.this.execution_arn}/*/*"
#}
