# Создание шлюза
resource "yandex_vpc_gateway" "gw-hw" {
  labels = {
    gw = var.gateway.gw.labels.gw
  }
  name = var.gateway.gw.name
  shared_egress_gateway {
  }
}

# Создание таблицы маршрутизации
resource "yandex_vpc_route_table" "route-table" {
  for_each = local.route_table

  name       = each.key
  network_id = yandex_vpc_network.develop[each.value.network].id
  labels = {
    rt = each.value.labels.rt
  }
  
  dynamic "static_route" {
    for_each = [each.value.static_route]
    content {
    destination_prefix = static_route.value.destination_prefix
    gateway_id         = yandex_vpc_gateway.gw-hw.id
    }
  }
}

# Ресурс создания облачной сети
resource "yandex_vpc_network" "develop" {
  for_each = local.net

  name = each.key      
  #description = each.value.description             
  labels = {
    network = each.value.labels.network
  }
}

# Ресурс создания подсети в облочной сети
resource "yandex_vpc_subnet" "develop" {
  for_each = local.subnet

  name           = each.key
  network_id     = yandex_vpc_network.develop[each.value.network].id
  zone           = each.value.zone
  v4_cidr_blocks = [each.value.v4_cidr_blocks]
  route_table_id = yandex_vpc_route_table.route-table[each.value.route_table].id
}

# Ресурс создания группы безопасности
resource "yandex_vpc_security_group" "vpc" {
  for_each = local.net
  name       = var.security_group.name
  network_id = yandex_vpc_network.develop[each.key].id

  dynamic "ingress" {
    for_each = flatten([
      for group in var.security_group_ingress : group
    ])
    content {
      protocol       = lookup(ingress.value, "protocol", null)
      description    = lookup(ingress.value, "description", null)
      port           = lookup(ingress.value, "port", null)
      from_port      = lookup(ingress.value, "from_port", null)
      to_port        = lookup(ingress.value, "to_port", null)
      v4_cidr_blocks = lookup(ingress.value, "v4_cidr_blocks", null)
    }
  }

  dynamic "egress" {
    for_each = flatten([
      for group in var.security_group_egress : group
    ])
    content {
      protocol       = lookup(egress.value, "protocol", null)
      description    = lookup(egress.value, "description", null)
      port           = lookup(egress.value, "port", null)
      from_port      = lookup(egress.value, "from_port", null)
      to_port        = lookup(egress.value, "to_port", null)
      v4_cidr_blocks = lookup(egress.value, "v4_cidr_blocks", null)
    }
  }
}
