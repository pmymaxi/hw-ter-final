terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "= 0.202.0"
    }
    archive = {
      source = "hashicorp/archive"
      version = "2.8.0"
    }
    external = {
      source = "hashicorp/external"
      version = "2.4.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.8.0"      # узнать версию провайдера через cat .terraform.lock.hcl
    }
    null = {
      source = "hashicorp/null"
      version = "~> 3.2.4"         #узнать версию провайдера через cat .terraform.lock.hcl
    }
    template = {
      source = "hashicorp/template"
      version = "2.2.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 5.9.0"      # узнать версию провайдера через cat .terraform.lock.hcl
    }
  }
  required_version = "~>1.12.0"

  backend "s3" {
    bucket = "dev-stor-hw-ter"
    key    = "app/terraform.tfstate"
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

provider "vault" {
 address = "${local.vault_ip.protocol}://${local.vault_ip.ext_ip}:${local.vault_ip.port}"
 skip_tls_verify = true
 token = var.VAULT_TOKEN
}