variable "backend_config" {
  description = "Backend configuration for Terraform state"
  type        = map(string)
  default = {
    bucket = "remote-backends"
    key    = "state.tfstate"
    region = "us-east-1"
  }
  
}