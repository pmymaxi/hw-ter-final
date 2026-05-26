<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~>1.12.0 |
| <a name="requirement_yandex"></a> [yandex](#requirement\_yandex) | = 0.202.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_yandex"></a> [yandex](#provider\_yandex) | 0.202.0 |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [yandex_vpc_gateway.gw-hw](https://registry.terraform.io/providers/yandex-cloud/yandex/0.202.0/docs/resources/vpc_gateway) | resource |
| [yandex_vpc_network.develop](https://registry.terraform.io/providers/yandex-cloud/yandex/0.202.0/docs/resources/vpc_network) | resource |
| [yandex_vpc_route_table.route-table](https://registry.terraform.io/providers/yandex-cloud/yandex/0.202.0/docs/resources/vpc_route_table) | resource |
| [yandex_vpc_security_group.vpc](https://registry.terraform.io/providers/yandex-cloud/yandex/0.202.0/docs/resources/vpc_security_group) | resource |
| [yandex_vpc_subnet.develop](https://registry.terraform.io/providers/yandex-cloud/yandex/0.202.0/docs/resources/vpc_subnet) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_cloud_id"></a> [cloud\_id](#input\_cloud\_id) | ID облака размещения | `string` | n/a | yes |
| <a name="input_default_zone"></a> [default\_zone](#input\_default\_zone) | Регион размещения | `string` | `"ru-central1-a"` | no |
| <a name="input_folder_id"></a> [folder\_id](#input\_folder\_id) | ID каталога размещения | `string` | `"ru-central1-a"` | no |
| <a name="input_gateway"></a> [gateway](#input\_gateway) | Блок конфигурации создания шлюза по умолчанию | <pre>map(object({<br/>    labels = optional(map(string))<br/>    name   = string<br/>    }))</pre> | n/a | yes |
| <a name="input_route_table"></a> [route\_table](#input\_route\_table) | Блок конфигурации таблицы маршрутизации (DNAT (1:1)) | <pre>map(map(object({<br/>    labels         = optional(map(string))<br/>    static_route   = map(string)<br/>  })))</pre> | n/a | yes |
| <a name="input_security_group"></a> [security\_group](#input\_security\_group) | Блок конфигурации создания группы безопасности в облачной сети | `map(string)` | n/a | yes |
| <a name="input_security_group_egress"></a> [security\_group\_egress](#input\_security\_group\_egress) | Блок конфигурации правил исходящих соединений в группе безопасности | <pre>map(list(object(<br/>    {<br/>      protocol       = string<br/>      description    = string<br/>      v4_cidr_blocks = list(string)<br/>      port           = optional(number)<br/>      from_port      = optional(number)<br/>      to_port        = optional(number)<br/>  })))</pre> | `{}` | no |
| <a name="input_security_group_ingress"></a> [security\_group\_ingress](#input\_security\_group\_ingress) | Блок конфигурации правил входящих соединений в группе безопасности | <pre>map(list(object(<br/>    {<br/>      protocol       = string<br/>      description    = string<br/>      v4_cidr_blocks = list(string)<br/>      port           = optional(number)<br/>      from_port      = optional(number)<br/>      to_port        = optional(number)<br/>  })))</pre> | `{}` | no |
| <a name="input_vpc_network"></a> [vpc\_network](#input\_vpc\_network) | Блок конфигурации создания облачной сети | <pre>map(object({<br/>    name                      = string<br/>    #description               = optional(string)<br/>    labels                    = map(string)<br/>    }))</pre> | n/a | yes |
| <a name="input_vpc_subnet"></a> [vpc\_subnet](#input\_vpc\_subnet) | Блок конфигурации создания подсети в облачной сети | <pre>map(map(object({<br/>    labels         = optional(map(string))<br/>    description    = optional(string)<br/>    zone           = string<br/>    v4_cidr_blocks = string<br/>    route_table    = string<br/>    })))</pre> | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_network"></a> [network](#output\_network) | Вывод информации облачной сети |
| <a name="output_security_group"></a> [security\_group](#output\_security\_group) | Вывод информации подсети в облачной сети |
<!-- END_TF_DOCS -->