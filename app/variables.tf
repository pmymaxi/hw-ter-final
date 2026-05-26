variable "VAULT_TOKEN" {
  type      = string
  sensitive = true
}

variable "access_key" {
  type = string
  default = null
  sensitive = true
  description = "env переменная access_key для статистического ключа сервисного аккаунта"
}
variable "secret_key" {
  type = string
  default = null
  sensitive = true
  description = "env переменная secret_key для статистического ключа сервисного аккаунта"
}

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


variable "conf_root_cl" {
  type = object({
    name                = string
    environment         = string
    vpc_network         = string
    vpc_subnet          = string
    high_availability   = bool
    version             = string
    deletion_protection = bool
    resources = object({
      resource_preset_id = string
      disk_type_id       = string
      disk_size          = number
    })
    host = list(object({
      zone             = string
      subnet_id        = optional(string)
      assign_public_ip = bool
      backup_priority  = number
      priority         = number
    }))
  })
  description = "Блок конфигурации cluster MySql"
}

variable "conf_root_db" {
  type = map(string)
  description = "Блок конфигурации базы данных"
}

variable "conf_root_user" {
  type = object({
    #name  = string
    roles = list(string)
  })
  sensitive = true
  description = "Блок конфигурации пользователя базы данных"
}

variable "conf_root_host" {
  type = map(string)
  description = "Переменная адреса MySql сервиса"
}

variable "cluster_create" {
  type        = bool
  default     = true
  description = "Переменная вкл/выкл создания cluster MySql"
}

variable "vm_module" {
  type = map(object({
    env_name           = string
    vpc_network        = string
    vpc_subnet         = string
    subnet_zones       = list(string)
    instance_name      = string
    instance_count     = number
    image_family       = string
    public_ip          = bool
    labels             = map(string)
    metadata           = map(string)
    cloud_init = object({
      users    = map(string)
      package  = map(bool)
      packages = list(string)
    })
  }))
  description = "Блок конфигурации VM для передачи в module"
}

variable "s3_remote_state" {
  type = map(object({
    bucket                      = string
    key                         = string
    region                      = string
    use_lockfile                = bool
    endpoints                   = map(string)
    skip_region_validation      = bool
    skip_credentials_validation = bool
    skip_requesting_account_id  = bool
    skip_s3_checksum            = bool
  }))
  description = "Блок конфигурации s3 для подключения к bucket"
}

variable "use_remote_state" {
  type    = bool
  default = true
  description = "Переменная для определения вкл/выкл использования s3"
}

variable "stor_object_push" {
  type = map(object({
    bucket = string
    key    = string
    source = string
    tags   = map(string)
  }))
  description = "Блок конфигурации отправки артифактов в storage bucket"
}