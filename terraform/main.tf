module "endpoint" {
  for_each      = var.functions.api_gateway
  source        = "./modules/endpoint"
  function_name = each.key
  method        = each.value.method
  path          = each.value.path
  stage         = each.value.stage
}

output "full_urls" {
  value = {
  for vm in keys(var.functions.api_gateway) : vm => "http://${module.endpoint[vm].api_id}.execute-api.localhost.localstack.cloud:4566/${module.endpoint[vm].stage_name}/${module.endpoint[vm].path_part}"
  }
}