variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "westus"
}

variable "prefix" {
  description = "Prefix for all resource names"
  type        = string
  default     = "integrator"
}