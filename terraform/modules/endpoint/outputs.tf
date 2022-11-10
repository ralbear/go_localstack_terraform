#output "base_url" {
#  description = "Base URL for API Gateway stage."
#
#  value = aws_apigatewayv2_stage.this.invoke_url
#}

output "base_url" {
  description = "Base URL for API Gateway stage."

  value = aws_api_gateway_stage.api.invoke_url
}


#output "base_url" {
#  value = [
#    for api in aws_api_gateway_stage.api : api.invoke_url
#  ]
#}