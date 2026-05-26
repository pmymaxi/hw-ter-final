terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "= 0.202.0"
    }
    template = {
      source = "hashicorp/template"
      version = "~> 2.2.0"
    }
    external ={
      source = "hashicorp/external"
      version = "~> 2.3.5"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 5.9.0"      # узнать версию провайдера через cat .terraform.lock.hcl
    }
    
  }
  required_version = "~>1.12.0"

  backend "s3" {
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
}

provider "yandex" {
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.default_zone
  service_account_key_file = file("~/.ssh/sa_key_yc.json")
}