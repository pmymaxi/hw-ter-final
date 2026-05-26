variable "conf_cl" {
    type = object({
      name                = string
      environment         = string
      network_id          = string
      version             = string
      security_group_ids  = list(string)
      deletion_protection = bool
      resources = object({
        resource_preset_id = string
        disk_type_id       = string
        disk_size          = number
      })
      host = list(object({
        zone             = string
        subnet_id        = string
        assign_public_ip = bool
        backup_priority  = number
        priority         = number
      }))
    })
}

variable "conf_db" {
    type = map(string)
}

variable "conf_user" {
    type = object({
      name     = string
      password = string
      roles    = list(string)
    })
}