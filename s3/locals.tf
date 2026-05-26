# Проверка на наличие данных encrypt, нужно для определения использования севриса yandex_kms_symmetric_key
locals {
  encrypt_check = alltrue([
    for k in var.bucket :
    k.encrypt.name != "" &&
    k.encrypt.default_algorithm != "" &&
    k.encrypt.rotation_period != ""
  ])
}

# Создаем структуру для формирования объектов
 locals {
  storage_object = merge([
    for bucket_name, bucket_val in var.bucket : {
      for stor_object_key, stor_object_val in bucket_val.stor_object :
      stor_object_key => merge(stor_object_val, {
      bucket = bucket_name
      })
    }
  ]...)
  }