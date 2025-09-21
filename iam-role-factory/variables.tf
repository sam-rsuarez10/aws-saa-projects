variable "roles" {
  type = map(object({
    role_info = object({
      team        = string
      environment = optional(string, "dev")
      purpose     = string
    })
    assume_principals = map(list(string))
    policy_statements = map(object({
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
  }))

  description = "map of roles to be created"

}
