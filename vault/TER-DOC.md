<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~>1.12.0 |
| <a name="requirement_external"></a> [external](#requirement\_external) | ~> 2.3.5 |
| <a name="requirement_local"></a> [local](#requirement\_local) | 2.9.0 |
| <a name="requirement_template"></a> [template](#requirement\_template) | ~> 2.2.0 |
| <a name="requirement_vault"></a> [vault](#requirement\_vault) | ~> 5.9.0 |
| <a name="requirement_yandex"></a> [yandex](#requirement\_yandex) | = 0.202.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_external"></a> [external](#provider\_external) | 2.3.5 |
| <a name="provider_local"></a> [local](#provider\_local) | 2.9.0 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |
| <a name="provider_yandex"></a> [yandex](#provider\_yandex) | 0.202.0 |

## Modules

| Name | Source | Version |
| ---- | ------ | ------- |
| <a name="module_vm_module_external"></a> [vm\_module\_external](#module\_vm\_module\_external) | ../vm_module | n/a |

## Resources

| Name | Type |
| ---- | ---- |
| [local_file.cloud_init_templatefile](https://registry.terraform.io/providers/hashicorp/local/2.9.0/docs/resources/file) | resource |
| [yandex_storage_object.add_object](https://registry.terraform.io/providers/yandex-cloud/yandex/0.202.0/docs/resources/storage_object) | resource |
| [external_external.passwd_hash](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external) | data source |
| [terraform_remote_state.s3](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.s3_local](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.vpc_local](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.vpc_s3](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_access_key"></a> [access\_key](#input\_access\_key) | env переменная access\_key для статистического ключа сервисного аккаунта | `string` | `null` | no |
| <a name="input_cloud_id"></a> [cloud\_id](#input\_cloud\_id) | ID облака размещения | `string` | n/a | yes |
| <a name="input_default_zone"></a> [default\_zone](#input\_default\_zone) | Регион размещения | `string` | `"ru-central1-a"` | no |
| <a name="input_folder_id"></a> [folder\_id](#input\_folder\_id) | ID каталога размещения | `string` | `"ru-central1-a"` | no |
| <a name="input_passuser"></a> [passuser](#input\_passuser) | env переменная пароля пользователя для передачи в VM | `string` | n/a | yes |
| <a name="input_s3_remote_state"></a> [s3\_remote\_state](#input\_s3\_remote\_state) | Блок конфигурации s3 для подключения к bucket | <pre>map(object({<br/>    bucket                      = string<br/>    key                         = string<br/>    region                      = string<br/>    use_lockfile                = bool<br/>    endpoints                   = map(string)<br/>    skip_region_validation      = bool<br/>    skip_credentials_validation = bool<br/>    skip_requesting_account_id  = bool<br/>    skip_s3_checksum            = bool<br/>  }))</pre> | n/a | yes |
| <a name="input_secret_key"></a> [secret\_key](#input\_secret\_key) | env переменная secret\_key для статистического ключа сервисного аккаунта | `string` | `null` | no |
| <a name="input_stor_object_push"></a> [stor\_object\_push](#input\_stor\_object\_push) | Блок конфигурации отправки артифактов в storage bucket | <pre>map(object({<br/>    bucket = string<br/>    key    = string<br/>    source = string<br/>    tags   = map(string)<br/>  }))</pre> | n/a | yes |
| <a name="input_use_remote_state"></a> [use\_remote\_state](#input\_use\_remote\_state) | Переменная для определения вкл/выкл использования s3 | `bool` | `true` | no |
| <a name="input_vm_module"></a> [vm\_module](#input\_vm\_module) | Блок конфигурации VM для передачи в module | <pre>map(object({<br/>    env_name           = string<br/>    vpc_network        = string<br/>    vpc_subnet         = string<br/>    subnet_zones       = list(string)<br/>    instance_name      = string<br/>    instance_count     = number<br/>    image_family       = string<br/>    public_ip          = bool<br/>    labels             = map(string)<br/>    metadata           = map(string)<br/>    cloud_init = object({<br/>      users    = map(string)<br/>      package  = map(bool)<br/>      packages = list(string)<br/>    })<br/>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_vault"></a> [vault](#output\_vault) | n/a |
| <a name="output_vault_ip"></a> [vault\_ip](#output\_vault\_ip) | n/a |
<!-- END_TF_DOCS -->