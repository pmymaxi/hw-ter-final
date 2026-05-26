# Создаем сервисный account
resource "yandex_iam_service_account" "sa" {
  for_each = var.sa_name

  name = each.value.name
  folder_id = var.folder_id
}

# Назначение роли сервисному аккаунту
resource "yandex_resourcemanager_folder_iam_member" "sa-admin" {
  for_each = var.sa_name

  folder_id = var.folder_id
  role      = each.value.role
  member    = "serviceAccount:${yandex_iam_service_account.sa[each.key].id}"
}

# Создание статического ключа доступа
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  for_each = var.sa_name

  service_account_id = sensitive(yandex_iam_service_account.sa[each.key].id)
  description        = each.value.desc_key
}


# Создание алгоритма шифрования bucket, если encrypt значения true
resource "yandex_kms_symmetric_key" "key-a" {
  for_each = local.encrypt_check ? var.bucket : {}

  name              = each.value.encrypt.name
  description       = each.value.encrypt.description
  default_algorithm = each.value.encrypt.default_algorithm
  rotation_period   = each.value.encrypt.rotation_period
}

# Назначем сервисному аккаунту доступ kms 
resource "yandex_kms_symmetric_key_iam_binding" "kms_access" {
  for_each = yandex_kms_symmetric_key.key-a

  symmetric_key_id = each.value.id
  role = var.sa_name.admin.role_kms

  members = [
    for name, sa in yandex_iam_service_account.sa :
    "serviceAccount:${sa.id}"
  ]
}

# Добавляяем bucket
resource "yandex_storage_bucket" "add_bucket" {
  for_each = var.bucket

  bucket = each.key
  max_size = each.value.max_size
  access_key = sensitive(yandex_iam_service_account_static_access_key.sa-static-key["admin"].access_key)
  secret_key = sensitive(yandex_iam_service_account_static_access_key.sa-static-key["admin"].secret_key)

  versioning {
    enabled = each.value.vers_enabled
  }
  

// Добавляем условие если encrypt значения true то подставляем через dynamic блок, блок шифрования
dynamic "server_side_encryption_configuration" {
  for_each = local.encrypt_check ? [1] : []
  content {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = yandex_kms_symmetric_key.key-a[each.key].id
        sse_algorithm     = each.value.encrypt.sse_algorithm
      }
    }
  }
}
}

/* # Загружаем файлы
resource "yandex_storage_object" "add_object" {
  depends_on = [ yandex_storage_bucket.add_bucket ]
  for_each = local.storage_object

  bucket  = each.value.bucket
  key     = each.value.key
  #content = each.value.content
  source = "${path.module}${each.value.source}"
  tags = {
    bucket = each.value.tags.bucket
  }
}
 */
# Настраиваем права доступа к бакету Yandex Object Storage с помощью Identity and Access Management
resource "yandex_storage_bucket_iam_binding" "bucket_reader" {
  for_each = yandex_storage_bucket.add_bucket

  bucket = yandex_storage_bucket.add_bucket[each.key].bucket

  role = "storage.viewer"

  members = [
    "serviceAccount:${yandex_iam_service_account.sa["pull"].id}"
  ]
}