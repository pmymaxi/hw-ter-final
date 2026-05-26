terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "= 0.202.0"
    }

  }

  required_version = "~>1.12.0"
  
/*    backend "s3" {
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
  } */
}

provider "yandex" {
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.default_zone
  service_account_key_file = file("~/.ssh/sa_key_yc.json")
}

/*provider "vault" {
  address         = "http://127.0.0.1:8200"
  skip_tls_verify = true
  token           = var.VAULT_TOKEN
}*/