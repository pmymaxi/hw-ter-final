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

variable "registry" {
    type = object({
      name_registry   = string
      name_sa         = string
      role_sa         = string
      name_repository = string
})
description = "Блок конфигурации registry / repository / role / service account "
}