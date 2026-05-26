<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
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
| [yandex_iam_service_account.sa](https://registry.terraform.io/providers/yandex-cloud/yandex/0.202.0/docs/resources/iam_service_account) | resource |
| [yandex_iam_service_account_static_access_key.sa-static-key](https://registry.terraform.io/providers/yandex-cloud/yandex/0.202.0/docs/resources/iam_service_account_static_access_key) | resource |
| [yandex_kms_symmetric_key.key-a](https://registry.terraform.io/providers/yandex-cloud/yandex/0.202.0/docs/resources/kms_symmetric_key) | resource |
| [yandex_kms_symmetric_key_iam_binding.kms_access](https://registry.terraform.io/providers/yandex-cloud/yandex/0.202.0/docs/resources/kms_symmetric_key_iam_binding) | resource |
| [yandex_resourcemanager_folder_iam_member.sa-admin](https://registry.terraform.io/providers/yandex-cloud/yandex/0.202.0/docs/resources/resourcemanager_folder_iam_member) | resource |
| [yandex_storage_bucket.add_bucket](https://registry.terraform.io/providers/yandex-cloud/yandex/0.202.0/docs/resources/storage_bucket) | resource |
| [yandex_storage_bucket_iam_binding.bucket_reader](https://registry.terraform.io/providers/yandex-cloud/yandex/0.202.0/docs/resources/storage_bucket_iam_binding) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_bucket"></a> [bucket](#input\_bucket) | Блок конфигурации bucket storage | <pre>map(object({<br/>      max_size     = number<br/>      vers_enabled = bool<br/>      encrypt      = map(string)<br/>      stor_object  = optional(map(object({<br/>      key     = string<br/>      content = optional(string)<br/>      source  = optional(string)<br/>      tags    = map(string)<br/>      })))<br/>    }))</pre> | n/a | yes |
| <a name="input_cloud_id"></a> [cloud\_id](#input\_cloud\_id) | ID облака размещения | `string` | n/a | yes |
| <a name="input_default_zone"></a> [default\_zone](#input\_default\_zone) | Регион размещения | `string` | `"ru-central1-a"` | no |
| <a name="input_folder_id"></a> [folder\_id](#input\_folder\_id) | ID каталога размещения | `string` | `"ru-central1-a"` | no |
| <a name="input_sa_name"></a> [sa\_name](#input\_sa\_name) | Блок конфигурации сервисного пользователя права/права kms | <pre>map(object({<br/>      name     = string<br/>      role     = string <br/>      desc_key = string<br/>      role_kms = optional(string)<br/>    }))</pre> | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_bucket"></a> [bucket](#output\_bucket) | n/a |
| <a name="output_bucket_list"></a> [bucket\_list](#output\_bucket\_list) | Вывод информации о перечне bucket |
| <a name="output_example_bucket"></a> [example\_bucket](#output\_example\_bucket) | Вывод информации примера блока использовании s3 |
| <a name="output_information"></a> [information](#output\_information) | Вывод информации о конфигурировании |
| <a name="output_key-s3"></a> [key-s3](#output\_key-s3) | Вывод ключа |
<!-- END_TF_DOCS -->