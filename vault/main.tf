# Передаем external модулю параметры формирования VM, network и subnet из output модуля "vpc"
module "vm_module_external" {
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
    var.vm_module.vault.metadata,
    {
      user-data = local_file.cloud_init_templatefile.content
    }
  )
}