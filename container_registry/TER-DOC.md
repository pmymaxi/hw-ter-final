<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~>1.12.0 |
| <a name="requirement_external"></a> [external](#requirement\_external) | ~> 2.3.5 |
| <a name="requirement_template"></a> [template](#requirement\_template) | ~> 2.2.0 |
| <a name="requirement_vault"></a> [vault](#requirement\_vault) | ~> 5.9.0 |
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
| [yandex_container_registry.my-registry](https://registry.terraform.io/providers/yandex-cloud/yandex/0.202.0/docs/resources/container_registry) | resource |
| [yandex_container_repository.app](https://registry.terraform.io/providers/yandex-cloud/yandex/0.202.0/docs/resources/container_repository) | resource |
| [yandex_container_repository_iam_binding.app_pull](https://registry.terraform.io/providers/yandex-cloud/yandex/0.202.0/docs/resources/container_repository_iam_binding) | resource |
| [yandex_iam_service_account.registry-sa](https://registry.terraform.io/providers/yandex-cloud/yandex/0.202.0/docs/resources/iam_service_account) | resource |
| [yandex_resourcemanager_folder_iam_member.registry-sa-role-images-puller](https://registry.terraform.io/providers/yandex-cloud/yandex/0.202.0/docs/resources/resourcemanager_folder_iam_member) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_cloud_id"></a> [cloud\_id](#input\_cloud\_id) | ID облака размещения | `string` | n/a | yes |
| <a name="input_default_zone"></a> [default\_zone](#input\_default\_zone) | Регион размещения | `string` | `"ru-central1-a"` | no |
| <a name="input_folder_id"></a> [folder\_id](#input\_folder\_id) | ID каталога размещения | `string` | `"ru-central1-a"` | no |
| <a name="input_registry"></a> [registry](#input\_registry) | Блок конфигурации registry / repository / role / service account | <pre>object({<br/>      name_registry   = string<br/>      name_sa         = string<br/>      role_sa         = string<br/>      name_repository = string<br/>})</pre> | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_push_docker"></a> [push\_docker](#output\_push\_docker) | n/a |
| <a name="output_registry"></a> [registry](#output\_registry) | n/a |
<!-- END_TF_DOCS -->