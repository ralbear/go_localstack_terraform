output "api_id" {
  value = aws_api_gateway_rest_api.api.id
}

output "stage_name" {
  value = aws_api_gateway_stage.api.stage_name
}

output "path_part" {
  value = aws_api_gateway_resource.endpoint.path_part
}