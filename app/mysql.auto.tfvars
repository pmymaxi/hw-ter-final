conf_root_cl = {
  name                = "mysql-hw-ter-final"
  environment         = "PRESTABLE"
  vpc_network         = "develop-network-hw-ter"
  vpc_subnet          = "manager-net-01" 
  high_availability   = false
  version             = "8.0"
  deletion_protection = false
  resources = {
    resource_preset_id = "c3-c2-m4"
    disk_type_id       = "network-hdd"
    disk_size          = 10
  }
  host = [
    {
      zone             = "ru-central1-a"
      assign_public_ip = false
      backup_priority  = 0
      priority         = 0
    },
    {
      zone             = "ru-central1-a"
      assign_public_ip = false
      backup_priority  = 0
      priority         = 0
    }
  ]

}
# Переменная название БД
conf_root_db = {
  name = "test"
}
# Переменная ролей пользователю БД
conf_root_user = {
  roles = ["ALL"]
}
# Параметры подключения к БД
conf_root_host = {
  db_host = ""
}