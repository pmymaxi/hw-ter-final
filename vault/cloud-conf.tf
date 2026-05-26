# Формирование шаблона cloud-init
locals {
  cloud_init = templatefile("${path.module}/tpl/cloud-init.tftpl",
  {
      name                  = var.vm_module.vault.cloud_init.users.name
      groups                = var.vm_module.vault.cloud_init.users.groups
      passwd                = local.passhash
      ssh_public            = local.vms_ssh_public_root_key
      package_update        = var.vm_module.vault.cloud_init.package.package_update
      package_upgrade       = var.vm_module.vault.cloud_init.package.package_upgrade
      packages              = var.vm_module.vault.cloud_init.packages
      AWS_ACCESS_KEY_ID     = local.s3_pull_key.access_key
      AWS_SECRET_ACCESS_KEY = local.s3_pull_key.secret_key
      name_bucket           = var.stor_object_push.vault_demo.bucket
      file_bucket           = var.stor_object_push.vault_demo.key
      basename              = basename(var.stor_object_push.vault_demo.key) 
  }) 
}

# Формируем результат шаблона cloud-init
resource "local_file" "cloud_init_templatefile" {
  depends_on = [local_file.cloud_init_templatefile]
  content  = local.cloud_init
  filename = "${path.module}/cloud-init.yml"
  file_permission = "0644"
}

# Создаем локальную переменную hash пароля
locals {
  passhash = data.external.passwd_hash.result.passhash
}

/* Формируем hash полученного пароля из env, обязательно возвращать в Json,
external data source в Terraform строго требует JSON-формат на выходе
*/
data "external" "passwd_hash" {
  program = ["bash", "-c", <<EOT
  passhash=$(openssl passwd -6 "${var.passuser}")
  echo "{\"passhash\":\"$passhash\"}"
EOT
  ]
}

# Загружаем файлы в storage 
resource "yandex_storage_object" "add_object" {
  for_each = var.stor_object_push

  bucket  = each.value.bucket
  key     = each.value.key
  source = "${path.module}${each.value.source}"
  tags = {
    bucket = each.value.tags.bucket
  }
}