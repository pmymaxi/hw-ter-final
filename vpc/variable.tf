variable "cloud_id" {
  type        = string
  description = "ID облака размещения"
}
variable "folder_id" {
    type        = string
    default     = "ru-central1-a"
    description = "ID каталога размещения"
}
variable "default_zone" {
    type        = string
    default     = "ru-central1-a"
    description = "Регион размещения"
}

variable "vpc_network" {
    type = map(object({
    name                      = string
    #description               = optional(string)
    labels                    = map(string)
    }))
    description = "Блок конфигурации создания облачной сети"
}

variable "vpc_subnet" {
  type = map(map(object({
    labels         = optional(map(string))
    description    = optional(string)
    zone           = string
    v4_cidr_blocks = string
    route_table    = string
    })))
    description = "Блок конфигурации создания подсети в облачной сети"
  }

  variable "security_group" {
    type = map(string)
    description = "Блок конфигурации создания группы безопасности в облачной сети"
  }
    
variable "security_group_ingress" {
  type = map(list(object(
    {
      protocol       = string
      description    = string
      v4_cidr_blocks = list(string)
      port           = optional(number)
      from_port      = optional(number)
      to_port        = optional(number)
  })))
  default = {}
  description = "Блок конфигурации правил входящих соединений в группе безопасности"
}

variable "security_group_egress" {
  type = map(list(object(
    {
      protocol       = string
      description    = string
      v4_cidr_blocks = list(string)
      port           = optional(number)
      from_port      = optional(number)
      to_port        = optional(number)
  })))
  default = {}
  description = "Блок конфигурации правил исходящих соединений в группе безопасности"
}

variable "gateway" {
  type = map(object({
    labels = optional(map(string))
    name   = string
    }))
    description = "Блок конфигурации создания шлюза по умолчанию"
  }

 variable "route_table" {
  type = map(map(object({
    labels         = optional(map(string))
    static_route   = map(string)
  })))
    description = "Блок конфигурации таблицы маршрутизации (DNAT (1:1))"
  } 