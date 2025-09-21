data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    dynamic "principals" {
      for_each = var.assume_principals
      iterator = principal_config

      content {
        type        = principal_config.key
        identifiers = principal_config.value
      }
    }
  }
}


resource "aws_iam_role" "this" {
  name               = "${var.role_info.team}-${var.role_info.environment}-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json

  tags = {
    Team        = var.role_info.team
    Environment = var.role_info.environment
    Purpose     = var.role_info.purpose
  }
}

data "aws_iam_policy_document" "this" {

  dynamic "statement" {
    for_each = var.policy_statements
    iterator = statement_config

    content {
      sid       = statement_config.key
      actions   = statement_config.value.allowed_actions
      resources = statement_config.value.resource_arns
      effect    = "Allow"

      dynamic "condition" {
        for_each = flatten([
          for condition_test, condition_list in statement_config.value.conditions : [
            for condition in condition_list : {
              test                = condition_test
              variable          = condition.variable
              values = condition.variable_condition
            }
          ]
        ])

        content {
          test = condition.value.test
          variable = condition.value.variable
          values   = condition.value.values
        }
      }
    }
  }

}

resource "aws_iam_policy" "this" {
  name        = replace("${var.role_info.team}-${var.role_info.environment}-policy", "_", "-")
  description = "Managed policy for ${var.role_info.team} in ${var.role_info.environment}"
  policy      = data.aws_iam_policy_document.this.json
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}