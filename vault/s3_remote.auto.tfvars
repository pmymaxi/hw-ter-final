s3_remote_state = {
    vpc= {
      bucket = "dev-stor-hw-ter"
      key    = "vpc/terraform.tfstate"
      region = "ru-central1"
      use_lockfile = true

      endpoints = {
        s3 = "https://storage.yandexcloud.net"
      }

      skip_region_validation      = true
      skip_credentials_validation = true
      skip_requesting_account_id  = true
      skip_s3_checksum            = true
  }
  s3 = {
      bucket = "dev-stor-hw-ter"
      key    = "s3/terraform.tfstate"
      region = "ru-central1"
      use_lockfile = true

      endpoints = {
        s3 = "https://storage.yandexcloud.net"
      }

      skip_region_validation      = true
      skip_credentials_validation = true
      skip_requesting_account_id  = true
      skip_s3_checksum            = true
  }
}

stor_object_push = {
    vault_demo = {
      bucket  = "dev-stor-hw-ter"
      key     = "docker/vault/compose_demo/docker-compose.yml"
      source = "/tar/compose_demo/docker-compose.yml"
      tags    = { bucket = "compose.yml" }
    },
    vault_full = {
      bucket  = "dev-stor-hw-ter"
      key     = "docker/vault/compose_full/docker-compose.yml"
      source = "/tar/compose_full/docker-compose.yml"
      tags    = { bucket = "compose.yml" }
      }    
}