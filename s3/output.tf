# Вывод ключа
output "key-s3" {
    value = {
      for k, v in yandex_iam_service_account_static_access_key.sa-static-key :
        k => {
          access_key = v.access_key
          secret_key = v.secret_key
        }
    }
    sensitive = true
}

# Вывод информации о конфигурировании
output "information" {
  value = <<EOF
    Output key:
    terraform output key-s3

    Add env key:
    export TF_VAR_access_key='access_key'
    export TF_VAR_secret_key='secret_key'
    Or in use vault

    Add variable in project for access bucket:
    variable "access_key" {
      type      = string
      sensitive = true
    }

    variable "secret_key" {
      type      = string
      sensitive = true
    }

    Apply init command:
    terraform init \
      -backend-config="access_key=$TF_VAR_access_key" \
      -backend-config="secret_key=$TF_VAR_secret_key"
  EOF
}

# Вывод информации о перечне bucket
output "bucket_list" {
  value = local.storage_object
}
output "bucket" {
  value = {
    for k, v in yandex_storage_bucket.add_bucket : 
      k => {
        bucket = v.bucket
        bucket_domain_name = v.bucket_domain_name   
/*     bucket = yandex_storage_bucket.add_bucket.bucket
    bucket_domain_name = yandex_storage_bucket.add_bucket.bucket_domain_name */
  }
}
}

# Вывод информации примера блока использовании s3
 output "example_bucket" {
  value = <<EOF

  terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "= 0.202.0"
    }
  }
  required_version = "~>1.12.0"

  backend "s3" {
    bucket = "name bucket"
    key    = "terraform.tfstate"
    region = "ru-central1a"
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
EOF
}