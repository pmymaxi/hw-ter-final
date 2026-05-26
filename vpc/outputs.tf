# Вывод информации облачной сети
output "network" {
  value = {
  for k, v in yandex_vpc_network.develop :
  k => {
    network_id = v.id
    subnet = {
      for sub, val in yandex_vpc_subnet.develop : 
      sub => {
      subnet_id = val.id 
      zone = val.zone
      v4_cidr_blocks = val.v4_cidr_blocks
      }
    }
  }
  }
}

# Вывод информации подсети в облачной сети
output "security_group" {
  value = {
    for name_sg, val in yandex_vpc_security_group.vpc : 
    name_sg => {
      sg_id            = val.id
      sg_name          = val.name
      apply_network_id = val.network_id
    }
  }
  
}
