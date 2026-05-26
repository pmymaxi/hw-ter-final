locals {
  net = {
    for net_key, net in var.vpc_network :
    net.name => net
  }
  subnet = merge([
    for network_name, network in var.vpc_subnet : {
      for subnet_name, subnet in network :
      subnet_name => merge(subnet, {
      network = network_name
      })
    }
  ]...)
  # tflint-ignore: terraform_unused_declarations
  gateway = {
    for gt_key, gt in var.gateway :
    gt.name => gt
  }

  route_table = merge([
    for route_name, route_v in var.route_table : {
      for table_name, table_v in route_v :
      table_name => merge(table_v, {
      network = route_name
      })
    }
  ]...)  
}