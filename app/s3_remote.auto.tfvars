s3_remote_state = {
    vpc = {
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
  vault = {
      bucket = "dev-stor-hw-ter"
      key    = "vault/terraform.tfstate"
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
  registry = {
      bucket = "dev-stor-hw-ter"
      key    = "container_registry/terraform.tfstate"
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
  app = {
    bucket  = "dev-stor-hw-ter"
    key     = "docker/app/app.zip"
    source  = "/tar/app.zip"
    tags    = { bucket = "app.zip" }
    }
}