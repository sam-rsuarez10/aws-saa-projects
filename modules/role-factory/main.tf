data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    dynamic "principals" {
      for_each = var.assume_principals
      content {
        type        = each.key
        identifiers = each.value
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
