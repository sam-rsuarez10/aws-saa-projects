module "iam_roles" {
  source = "../modules/role-factory"

  for_each = var.roles

  role_info = each.value.role_info
  assume_principals = each.value.assume_principals
  policy_statements = each.value.policy_statements
}
