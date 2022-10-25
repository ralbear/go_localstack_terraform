module "endpoint" {
  for_each = var.functions
  source = "./modules/endpoint"
  function_name = each.key
}