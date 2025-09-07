# role info (team, env, purpose)
# assume principals (identities or services)
# actions
# resources
# conditions

variable "role_info" {
  type = object({
    team = string
    environment = optional("dev", "staging", "prod")
    purpose = string 
  })

  description = "role info, from this info it will be generated the role name"
}

variable "assume_principals" {
  type = map(list(string))

  description = "list of principals that can assume the role"
}

variable "allowed_actions" {
  type = list(string)

  description = "list of allowed actions the role can perform on resources"
}

variable "resource_arns" {
  type = list(string)

  description = "list of resources the role can perform actions on"
  
}

variable "conditions" {
  type = map(object({
    key = string
    value = list(string)
  }))

  default = {}

  description = "map of conditions to apply to the role policy"

}