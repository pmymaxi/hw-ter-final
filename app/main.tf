# Передаем external модулю параметры формирования VM, network и subnet из output модуля "vpc"
module "vm_module" {
  for_each = var.vm_module

  source             = "../vm_module" # В var не добавляем так как источник должен быть определен заранее, железно указываем версию модуля через commit или tag
  env_name           = each.value.env_name
  network_id         = local.network[each.value.vpc_network].network_id
  subnet_zones       = each.value.subnet_zones # tolist look at tfvars
  subnet_ids         = [local.network[each.value.vpc_network].subnet[each.value.vpc_subnet].subnet_id]
  instance_name      = each.value.instance_name
  instance_count     = each.value.instance_count
  image_family       = each.value.image_family
  public_ip          = each.value.public_ip
  security_group_ids = [local.security_group[each.value.vpc_network].sg_id]
    
  labels = {
    project = each.value.labels.project
  }
  

# metadata, объединяем key => value из tfvars c формированным template файлом
  metadata = merge(
    var.vm_module.app.metadata,
    {
      user-data = local_file.cloud_init_templatefile.content
    }
  )
}

# Создание кластера БД yandex
module "mdb_mysql_cluster" {
  count  = var.cluster_create ? 1 : 0 # Управление созданием кластера в variables.tf
  source = "../mysql_module"

   /* Добавим две переменные network_id и subnet_id к передаваемому основному объекту conf_cl. 
Значение переменных определяют принадлежность к облачной сети и подести. 
Передаем объектами, чтобы не плодить портянку передаваемых переменных, просто передадим целый объект из tfvars*/

  conf_cl = merge(
    var.conf_root_cl,
    {
      network_id         = local.network[var.conf_root_cl.vpc_network].network_id
      security_group_ids = [local.security_group[var.conf_root_cl.vpc_network].sg_id]

      # Добавляем условие создания HA если true создаем больше 1 VM, если нет указываем индекс первого блока host
      host = var.conf_root_cl.high_availability ? [

        for p in var.conf_root_cl.host : merge(p, {
          subnet_id = local.network[var.conf_root_cl.vpc_network].subnet[var.conf_root_cl.vpc_subnet].subnet_id
        })
        ] : [
        merge(var.conf_root_cl.host[0], {
          subnet_id = local.network[var.conf_root_cl.vpc_network].subnet[var.conf_root_cl.vpc_subnet].subnet_id
        })
      ]
    }
  )

  # Передаем аргументы для создания БД
  conf_db = var.conf_root_db

  # Передаем аргументы пользователя для созданой БД
  conf_user = merge(
    var.conf_root_user,
    {
      password = local.passdb
      name = local.userdb
    }
  )
}
