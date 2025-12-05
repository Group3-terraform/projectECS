variable "project" {}
variable "environment" {}
variable "region" {}

variable "service_a_image" {}
variable "service_b_image" {}
variable "service_c_image" {}

variable "private_subnets" {
  type = list(string)
}

variable "security_groups" {
  type = list(string)
}

variable "tg_service_a" {}
variable "tg_service_b" {}
variable "tg_service_c" {}

variable "alb_listener" {}

variable "ecs_task_role" {}
variable "ecs_task_execution_role" {}

variable "common_env" {
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}
