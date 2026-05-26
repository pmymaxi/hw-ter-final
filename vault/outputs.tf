output "vault" {
    value = <<EOT

    Установите vault cli:
        wget https://releases.hashicorp.com/vault/1.16.3/vault_1.16.3_linux_amd64.zip \
        unzip vault_1.16.3_linux_amd64.zip \
        sudo mv vault /usr/local/bin/

    //-----------------------------------//

    Добавте в переменное окружение сеанса параметр подключения к vault:

        export VAULT_ADDR=http://${local.vm_param[keys(local.vm_param)[0]].external_ip_address[0]}:8200
            ИЛИ
        export VAULT_ADDR=http://${local.vm_param[keys(local.vm_param)[0]].internal_ip_address[0]}:8200

    В manual mode:

        vault login -address http://${local.vm_param[keys(local.vm_param)[0]].external_ip_address[0]}:8200
            ИЛИ
        vault login -address http://${local.vm_param[keys(local.vm_param)[0]].internal_ip_address[0]}:8200

     //-----------------------------------//

    После подключения к Vault добавьте ключ = значение secret

        vault kv put secret/my-app \
        access_key="статический ключ доступа, формируется в s3 ресурсе output key-s3" \
        passuser="пароль пользователя системы при deploy VM" \
        secret_key="статический ключ доступа, формируется в s3 ресурсе output key-s3"

        vault kv put secret/mysql \
        dbpassword="пароль для БД в сервисе Managed Service for MySQL" \
        dbuser="имя пользователя БД в сервисе Managed Service for MySQL"

    //-----------------------------------//

    Добавте в перемнное окружение ключ доступа и секрет полученного статистического account.

        Для применения не в terraform:

            export access_key=$(vault kv get -field=access_key secret/my-app)
            export secret_key=$(vault kv get -field=secret_key secret/my-app)

        Для приминения в terraform (в проекте используется remote_state_s3):

            export TF_VAR_access_key=$(vault kv get -field=access_key secret/my-app)
            export TF_VAR_secret_key=$(vault kv get -field=secret_key secret/my-app)

        Добавте в переменное окружение TOKEN ключа доступа Vault или указывайте при каждом запросе в момент вызова plan/apply

            export TF_VAR_VAULT_TOKEN
        
    //-----------------------------------//

    Для init проекта в s3 в среде Yandex Cloud может потребоваться изначальное определение state командой:

        terraform init -backend-config="access_key=$access_key" -backend-config="secret_key=$secret_key"

    EOT
}

output "vault_ip" {
  value = {
      ext_ip = local.vm_param[keys(local.vm_param)[0]].external_ip_address[0]
      int_ip = local.vm_param[keys(local.vm_param)[0]].internal_ip_address[0]
      protocol = "http"
      port = "8200"
  }
}