/* Создаем переменную в которую пробрасываем public key ssh с использованием дополнительной 
функцией pathexpand для определениия полного пути по ~, будем указывать в metadata instance */
locals {
  vms_ssh_public_root_key = file(pathexpand("~/.ssh/id_ed25519.pub"))
}

# Переменная определения fqdn адреса mysql cluster
locals {
  mysql_host = try(
    var.cluster_create
      ? length(var.conf_root_host.db_host) > 0 ?
      var.conf_root_host.db_host
      :
      module.mdb_mysql_cluster[0].cluster.host[0].fqdn
      : ""
  )
}

# Переменная для получения параметров VM
locals {
  web   = module.vm_module
  #mysql = module.mdb_mysql_cluster
}