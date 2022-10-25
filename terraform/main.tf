module "endpoint" {
  for_each = var.functions.api_gateway
  source = "./modules/endpoint"
  function_name = each.key
  method = each.value.method
  path = each.value.path
}