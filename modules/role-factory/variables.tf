# role info (team, env, purpose)
# assume principals (identities or services)
# actions
# resources
# conditions

variable "role_info" {
  type = object({
    team        = string
    environment = string
    purpose     = string
  })

  description = "role info, from this info it will be generated the role name"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.role_info.environment)
    error_message = <<-EOT
    Invalid environment. Must be one of "dev", "staging", or "prod".
    EOT
  }
}

variable "assume_principals" {
  type = map(list(string))

  description = "list of principals that can assume the role"
}

variable "policy_statements" {
  type = map(object({
    allowed_actions = list(string)
    resource_arns   = list(string)
    conditions = optional(
      map(list(object({
        variable           = string
        variable_condition = list(string)
      }))),
      {}
    )
  }))

  description = "statements config for the managed role policy to be created"

    validation {
    condition = alltrue ([
      for statement in values(var.policy_statements) : 
        can([for action in statement.allowed_actions : regex("^[\\w\\-:*]+$", action)])
    ])
    error_message = "All actions must be valid IAM action patterns."
  }
}
