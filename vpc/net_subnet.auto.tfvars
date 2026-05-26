vpc_network = {
    dev = {
        name = "develop-network-hw-ter"
        #description = "Облачная сеть разработки"
        labels = { network = "develop-network-hw-ter" }
    }
}

vpc_subnet = {
  develop-network-hw-ter = {
      manager-net-01 = {
        labels         = { subnet = "manager-net-01" }
        description    = "Подсеть кластера 01"
        route_table    = "route-table-01"

        zone           = "ru-central1-a"
        v4_cidr_blocks = "10.0.1.0/24"
      }
  }
}

gateway = {
  gw = {
    name   = "gw-hw-01"
    labels = { gw = "gateway-01" }
}
}

route_table = {
  develop-network-hw-ter = {
      route-table-01 = {
        labels = { rt = "develop-network-hw-ter" }
        static_route = {
          destination_prefix = "0.0.0.0/0"
        }
      }
  }
}