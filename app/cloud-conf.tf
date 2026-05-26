//-----------------Блок формирования cloud-init.yaml-----------------------//
# Формирование шаблона cloud-init
locals {
  cloud_init = templatefile("${path.module}/tpl/cloud-init.tftpl", 
  {
      name                  = var.vm_module.app.cloud_init.users.name
      groups                = var.vm_module.app.cloud_init.users.groups
      passwd                = local.passhash
      ssh_public            = local.vms_ssh_public_root_key
      package_update        = var.vm_module.app.cloud_init.package.package_update
      package_upgrade       = var.vm_module.app.cloud_init.package.package_upgrade
      packages              = var.vm_module.app.cloud_init.packages
      app_env               = local.app_env
      AWS_ACCESS_KEY_ID     = local.s3_pull_key.access_key
      AWS_SECRET_ACCESS_KEY = local.s3_pull_key.secret_key
      name_bucket           = var.stor_object_push.app.bucket
      file_bucket           = var.stor_object_push.app.key
      basename              = basename(var.stor_object_push.app.key)
  })
}
# Формируем результат шаблона cloud-init
resource "local_file" "cloud_init_templatefile" {
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
  passhash=$(openssl passwd -6 "${local.passuser}")
  echo "{\"passhash\":\"$passhash\"}"
EOT
  ]
}

//-----------------Блок формирования docker compose пакета-----------------------//
# Формирование шаблона env
resource "local_file" "env_templatefile" {
  content = templatefile("${path.module}/tpl/env.tftpl",
    {
      DB_HOST     = local.mysql_host
      DB_NAME     = var.conf_root_db.name
      DB_USER     = local.userdb
      DB_PASSWORD = local.passdb
  })
  filename = "${abspath(path.module)}/tar/.env"
  file_permission = "0644"
}

# Читаем env
data "local_file" "app_env" {
  depends_on = [local_file.env_templatefile]
  filename   = "${path.module}/tar/.env"

}
# Формируем  данные env в base64 для передачи в cloud-init
locals {
  app_env = base64encode(data.local_file.app_env.content)
} 

# Формируем шаблон docker compose 
locals {
  docker_compose = templatefile("${path.module}/tpl/docker-compose.tftpl", {
    registry_id = local.container_registry_s3
  })
}
# Читаем и формируем файл в директории root docker compose
resource "local_file" "docker_compose" {
  content  = local.docker_compose
  filename = "${path.module}/docker/docker-compose.yml"
  file_permission = "0644"
}

# Отправляем в архив наше приложение 
data "archive_file" "app" {
  depends_on = [
    resource.local_file.docker_compose,
    local.docker_compose
  ]

  type        = "zip"
  source_dir  = "${path.module}/docker"
  output_path = "${path.module}/tar/app.zip"
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