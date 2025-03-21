variable "db_username" {
  description = "The username for the WordPress MySQL database"
  type        = string
}

variable "db_password" {
  description = "The password for the WordPress MySQL database"
  type        = string
  sensitive   = true  
}

variable "region" {
  description = "The AWS region to deploy infrastructure"
  type        = string
}

variable "wp_admin_user" {
  description = "The WordPress admin username"
  type        = string
}

variable "wp_admin_email" {
  description = "The WordPress admin email address"
  type        = string
}
