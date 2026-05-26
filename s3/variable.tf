variable "cloud_id" {
  type        = string
  description = "ID облака размещения"
}
variable "folder_id" {
    type = string
    default = "ru-central1-a"
    description = "ID каталога размещения"
}
variable "default_zone" {
    type = string
    default = "ru-central1-a"
    description = "Регион размещения"
}

variable "sa_name" {
    type = map(object({
      name     = string
      role     = string 
      desc_key = string
      role_kms = optional(string)
    }))
  description = "Блок конфигурации сервисного пользователя права/права kms"
}
variable "bucket" {
    type = map(object({
      max_size     = number
      vers_enabled = bool
      encrypt      = map(string)
      stor_object  = optional(map(object({
      key     = string
      content = optional(string)
      source  = optional(string)
      tags    = map(string)
      })))
    }))
    description = "Блок конфигурации bucket storage"
}