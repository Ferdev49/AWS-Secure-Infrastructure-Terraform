variable "region" { 
  description = "La región de AWS donde se desplegarán los recursos"
  type        = string
  default     = "us-east-1" 
}

variable "project_name" {
  description = "Nombre del proyecto"
  type        = string
  default     = "Proyecto-Seguro-Fernando"
}

variable "vpc_cidr" {
    description = "CIDR block para la VPC"
    type        = string
    default     = "10.0.0.0/16"
}