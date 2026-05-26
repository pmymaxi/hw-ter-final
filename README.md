# Итоговый проект модуля «Облачная инфраструктура. Terraform»
Задания итогового проекта охватывают полный цикл создания и настройки инфраструктуры, установку необходимых инструментов, сборку и развертывание приложения, а также хранение образов в реестре контейнеров.

## Структура и краткое описание его работы 
Проект состоит из следующей структуры:
- app
- container_registry
- mysql_module
- s3
- vault
- vm_module
- vpc

### App 
Работа текущего root module заключается в следующем: 
- в сборке готового проекта docker-compose file;
- создание bucket object для хранения собранного приложения;
- архивация и отправка в bucket;
- deploy VM с предустановкой необходимых пакетов и зависимостей включая скачивания собранного архива приложения с bucket;
- deploy Managed Service for MySQL через remote mysql_module.

Краткое описание работы app:
1. Модуль формирует docker-compose файл из шаблона tftpl, также формирует из шаблона файл cloud-init.yml для передачи его на VM через metadata.
2. После того как docker compose file сформирован, он помещается в директорию docker к остальным файлам проекта.
3. Provider archive_file выполняет архивацию содержимого директории docker в zip архив и помещает его в каталог tar.
4. Ресурс yandex_storage_object начинает формировать Object Storage в Yandex Cloud и передает zip собранное приложение в bucket.
5. Составной файл .env docker-compose с параметрами подключения приложения к MySql формируется отдельным шаблоном. Файл env не помещается в основную директорию приложения docker в том числе и в zip архив, он размещается рядом с архивом приложения в директории tar. Это сделано для того, чтобы не хранить чувствительную информацию в bucket, для которой далее будет назначены права storage.viewer.  
6. В cloud-init основными параметрами предустановки при первом запуске VM указывается:
   - Пользователь/группы/пароль
   - Создание домашней директории приложении
   - Передача в зашифрованном виде содержимого env файла с последующим помещением в домашнею директорию приложения
   - Установка полного пакета Docker/Docker-Compose
   - Установка awscli для последующего подключения к bucket
   - Скачивание zip архива приложения из bucket с использованием инструмента awscli, распаковка архива в домашнею директорию приложения
   - Запуск приложения с использованием docker compose
В файле data.tf присутствует логика выбора режима работы terraform_remote_state. Возможность получения outputs описано как для получения из remote s3 так и local.
Условие выбора определяется переменной use_remote_state в файле variables.tf
```tf
variable "use_remote_state" {
  type    = bool
  default = true
  description = "Переменная для определения вкл/выкл использования s3"
}
```
Если use_remote_state = true тогда outputs получаем из S3, если use_remote_state = false получаем из local
Также по мимо уловия работы terraform_remote_state есть условие применения Managed Service for MySQL через remote mysql_module. Данное условие управляется через переменную cluster_create в файле variables.tf
```tf
variable "cluster_create" {
  type        = bool
  default     = false
  description = "Переменная вкл/выкл создания cluster MySql"
}
```
Если cluster_create = true, Managed Service for MySQL применится в проекте и кластер развернется, если cluster_create = false Managed Service for MySQL применяться не будет. Это было сделано для временного отключения при debug проекта или при использовании отдельного instance с MySql.

### Container_registry
В данном модуле разворачивается сontainer_registry, создается отдельный сервисный account, назначаются права на его использование. В текущем режиме pull images применятся для allUsers

### Mysql_module
Remote module описан для поднятия Managed Service for MySQL, вызывается из root module app. Количество instance в кластере и настройки БД определяется в app в файле mysql.auto.tfvars.

### s3
Данный модуль состоит из следующие задачи:
   - Создание сервисного account с правами storage.admin, в том числе создание статистического ключа
   - Создание временного сервисного account с правами storage.viewer, в том числе создание статистического ключа. Применятся для авторизации на bucket, чтобы при выполнении awscli (при применении cloud-init) был доступ на архив приложения app
   - Создание алгоритма шифрования bucket, для того чтобы данные были на bucket зашифрованы.
   - Назначение сервисным account доступ ключу kms для расшифровки содержимого bucket
   - Создание самого bucket
   - Создание первоначальной структуры object, по умолчанию блок yandex_storage_object закомментирован.
   - Добавление прав storage.viewer на просмотр содержимого (yandex_storage_bucket_iam_binding)
В этом модуле как и в app присутствует логика работы s3 а именно:
   1. В resource yandex_kms_symmetric_key выполняется условие проверки соответствие на наличие данных о шифровании.
```tf
# Создание алгоритма шифрования bucket, если encrypt значения true
resource "yandex_kms_symmetric_key" "key-a" {
  for_each = local.encrypt_check ? var.bucket : {}

  name              = each.value.encrypt.name
  description       = each.value.encrypt.description
  default_algorithm = each.value.encrypt.default_algorithm
  rotation_period   = each.value.encrypt.rotation_period
}
```
 2. Условие проверяет наличие трех value в encrypt в переменной bucket. Условие проверки выполняется в locals.tf
```tf
# Проверка на наличие данных encrypt, нужно для определения использования сервиса yandex_kms_symmetric_key
locals {
  encrypt_check = alltrue([
    for k in var.bucket :
    k.encrypt.name != "" &&
    k.encrypt.default_algorithm != "" &&
    k.encrypt.rotation_period != ""
  ])
}
```
3. Если значения name, default_algorithm, default_algorithm = заполнены (alltrue), тогда ресурс применяет алгоритм шифрования
```tf
  encrypt = {
      name = "hw-ter"
      description =""
      default_algorithm = "AES_128"
      rotation_period   = "8760h"
      sse_algorithm     = "aws:kms"
   }
```
4. Когда yandex_kms_symmetric_key определенно как true, его конфигурацию шифрования (server_side_encryption_configuration) необходимо определить в ресурсе yandex_storage_bucket при добавлении bucket. Для динамического применения, согласно условию, реализуется динамическим блоком dynamic "server_side_encryption_configuration" и условие local.encrypt_check ? [1] : []. Если local.encrypt_check = true тогда Count = 1 и блок используется, если
local.encrypt_check = false тогда Count = 0 блок не создается.   
```tf
dynamic "server_side_encryption_configuration" {
  for_each = local.encrypt_check ? [1] : []
  content {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = yandex_kms_symmetric_key.key-a[each.key].id
        sse_algorithm     = each.value.encrypt.sse_algorithm
      }
    }
  }
}
```
### Vault
В модуле Vault выполняется deploy (через vm_module) VM с предварительной предустановкой (cloud-init) пакета Docker/Docker-compose, AWSCli. Сloud-init формируется через tftpl шаблон. При иницализации 
cloud-init, выполняются аналогичные шаги как и в основном модуле app (создание домашней директории для Vault, Docker, установка awscli, скачивание docker compose file и его поднятие)
Кроме VM в модуле выполняется создание двух storage object с содержимым файла Docker compose. 
   1. Storage object compose_demo, в нем находится docker-compose file для максимально быстрого и уже изначально сконфигурированного LockBox Vault.
   2. Storage object compose_full, это чистый Vault, при первом обращении необходимо его сконфигурировать (создание ключей, токенов итд).
Как описывалось выше, cloud-init скачивает необходимый docker compose file в домашнею директорию Vault и запускает, в проекте изначально выбран вариант compose_demo. Изменение вариантов compose осуществляется
в файле сloud-conf.tf в блоке локальных переменных locals cloud_init и управляется тремя переменными name_bucket, file_bucket и basename.
```tf
locals {
  cloud_init = templatefile("${path.module}/tpl/cloud-init.tftpl",
  {
      name                  = var.vm_module.vault.cloud_init.users.name
      groups                = var.vm_module.vault.cloud_init.users.groups
      passwd                = local.passhash
      ssh_public            = local.vms_ssh_public_root_key
      package_update        = var.vm_module.vault.cloud_init.package.package_update
      package_upgrade       = var.vm_module.vault.cloud_init.package.package_upgrade
      packages              = var.vm_module.vault.cloud_init.packages
      AWS_ACCESS_KEY_ID     = local.s3_pull_key.access_key
      AWS_SECRET_ACCESS_KEY = local.s3_pull_key.secret_key
      name_bucket           = var.stor_object_push.vault_demo.bucket
      file_bucket           = var.stor_object_push.vault_demo.key
      basename              = basename(var.stor_object_push.vault_demo.key) 
  }) 
}
```
Для изменения, например на compose_full меняем значение переменных на vault_full. Типы создаваемых storage object описаны в файле s3_remote.auto.tfvars переменная stor_object_push.
```tf
      name_bucket           = var.stor_object_push.vault_full.bucket
      file_bucket           = var.stor_object_push.vault_full.key
      basename              = basename(var.stor_object_push.vault_full.key)
```

### Vpc
В текущем модуле разворачивается сетевая инфраструктура в составе:
   - Создание nat gateway
   - Создание route table для network через gateway
   - Создание network
   - Создание subnet
   - Создание security group с динамическими правилами ingress/egress применяемой к network в целом

## Описание deploy проекта
В текущем проекте не используются надстроек orchestration модулей таких как Terragrunt, Terraform Stacks, Atmos. Например для простого deploy можно использовать Makefile, переходя по директориям модулей и выполняя их запуск, добавление переменных в переменное окружение итд. В текущем проекте orchestration будем производить in manual mode. Процедура deploy показана на схеме ниже

<img width="1033" height="670" alt="1" src="https://github.com/user-attachments/assets/2de1d330-8429-40e6-94e6-4beed1c21cfe" />


Перед началом если нет ssh ключа нужно сгенерировать для дальнейше передачи на VM
```bash
ssh-keygen -t ed25519
```

### S3
1. Выполняем deploy сервиса s3
```bash
terraform init
terraform apply
```
2. После выполнения получаем outputs s3 информацио о статистических ключях доступа.
```tf
❯ terraform output key-s3
{
  "admin" = {
    "access_key" = "Y......"
    "secret_key" = "YC......"
  }
  "pull" = {
    "access_key" = "YCA......"
    "secret_key" = "YCP......"
  }
}
```
- admin - ключ сервисного пользователя sa-admin-s3с с праввами storage.admin
- pull - ключ временного сервисного пользователя, как уже описыввалось в app и vault, нужен для доступа к bucket для загрузки инфрастуктуры приложения и LockBox.
  
3. Добавляем ключ admin, полученные access_key и secret_key добавляем в переменное окружение текущей ссесии
```
export TF_VAR_secret_key="YC........."
export TF_VAR_access_key="YC........."
```

**pull в переменное окружение добавлять не нужно, он подтягивается с помощью terraform_remote_state s3 или local**

4. После deploy state передаем для хранения в s3 bucket, для этого нужно раскоментировать блок backend s3 в файле provider.tf.
   Выполним инициализацию backend s3 с передачей access_key и secret_key
```
   terraform init -backend-config="access_key=$TF_VAR_access_key" -backend-config="secret_key=$TF_VAR_secret_key"
   ```
<img width="815" height="412" alt="изображение" src="https://github.com/user-attachments/assets/9a12e663-b28d-4744-9363-e802be87f847" />


### Vpc
```
   terraform init -backend-config="access_key=$TF_VAR_access_key" -backend-config="secret_key=$TF_VAR_secret_key"
   terraform apply
 ```
<img width="806" height="709" alt="изображение" src="https://github.com/user-attachments/assets/38cbf968-b1ae-4e1f-9069-92a6440e9b61" />

### Поднимаем container registry
1. Выполним инициализацию  backend s3 с передачей access_key и secret_key
```
   terraform init -backend-config="access_key=$TF_VAR_access_key" -backend-config="secret_key=$TF_VAR_secret_key"
   terraform apply
 ```
После выполнения, в outputs появится информация о том, как выполнить push в созданную registry с уже подставлеными значения id registry

<img width="1244" height="692" alt="изображение" src="https://github.com/user-attachments/assets/8e813990-ace0-49aa-a533-03db3714c884" />


2. Теперь необходимо собрать наше приложение. В каталогке app_docker root директории, расположены файлы для сборки образа. 
```
 docker build . -t cr.yandex/crpkbtv4vev9s5ha6gld/app:1.0.1 -f dockerfile
 docker push cr.yandex/crpkbtv4vev9s5ha6gld/app:1.0.1
```
<img width="1899" height="979" alt="изображение" src="https://github.com/user-attachments/assets/e4429734-ba35-4573-891a-93edb94a2655" />


### Поднимаем vault
1. Выполним инициализацию  backend s3 с передачей access_key и secret_key
```
   terraform init -backend-config="access_key=$TF_VAR_access_key" -backend-config="secret_key=$TF_VAR_secret_key"
```
2. Перед apply необходимо задать пароль создаваемого систменого пользователя для VM, для этого экспортируем переменную passuser в переменное окружение текущей ссесии
```
export TF_VAR_passuser="password"
```
> В дальнейшем переменная для app переменная passuser нужна будет, но вот только для app мы будем задавать ее уже в самом Vault.
> Если нужен доступ из внешней сети, то нужно проверить переменную public_ip = true, чтобы instance получил внешний IP.
```
terraform apply
```

Вывод Outputs
<img width="892" height="1427" alt="изображение" src="https://github.com/user-attachments/assets/8365dfd6-ff44-4483-88d3-735e7b8a6dae" />

В выводе есть описание "Добавте в перемнное окружение ключ доступа и секрет полученного статистического account" это один из примеров как использовать access_key и secret_key из окружения Vault.

3. Проверим доступность VM и наличе запущенного сервиса Vault в Docker 
```
ssh -i ~/.ssh/id_ed25519 user@<ext_ip or int_ip из outputs>
```
<img width="1416" height="851" alt="изображение" src="https://github.com/user-attachments/assets/ed4332db-74fe-4de9-a37f-56c8879aef7d" />


4. Для дальнейшего доступа к Vault в проекте нужен token. Так как в моем проекте я использую demo deploy Vault, в нем уже передана переменная token VAULT_DEV_ROOT_TOKEN_ID: "education".
Добавим в переменное окружение переменную VAULT_TOKEN. она нужна для авторизации когда будет выполняться terraform
```
export TF_VAR_VAULT_TOKEN="education"
```
5. Теперь нам нужно создать ключ = значение secret, можно выполнить 3 методами. 
   - Через web интерфейс, по адресу http://<extIp из outputs>:8200;
   - Подключиться напрямую к контенеру ``` docker exec -it container bash ``` и выполнить vault login;
   - Использовать vault cli, в outputs самая первая строка говорит нам как его установить.
Я буду использовать vault cli.
 - После установки выполню вход в Vault и добавлю ключ = secret.
Первое, что нужно, добавить адрес vault сервиса в переменное окружение
```
export VAULT_ADDR=http://<ext_ip or int_ip из outputs>:8200
vault login
```
- Добавляем значения passuser для системного пользователя VM, access_key и secret_key, значения для формирования MySql.
  <img width="718" height="567" alt="изображение" src="https://github.com/user-attachments/assets/4e68662b-6d4d-499a-9078-f231f0cc75da" />

- Теперь уберу из переменного окружения ``` unset TF_VAR_access_key && unset TF_VAR_secret_key``` и добавлю через получения в Vault
  ```
  export TF_VAR_access_key=$(vault kv get -field=access_key secret/my-app)
  export TF_VAR_secret_key=$(vault kv get -field=secret_key secret/my-app)
  ```

### Deploy App
1. Для начало проверим переменные:
   - ```variable "cluster_create"; default = true``` deploy Mysql сервиса включен;
   - Проверим переменную ```vm_module.app.public_ip = true``` получение внешнего Ip адреса.
   -  
2. Выполним инициализацию  backend s3 с передачей access_key и secret_key и apply
```
   terraform init -backend-config="access_key=$TF_VAR_access_key" -backend-config="secret_key=$TF_VAR_secret_key"
   terraform aplly
```
<img width="484" height="273" alt="изображение" src="https://github.com/user-attachments/assets/c84e63bd-723b-4e9b-b9c7-8f695028e854" />

3. Проверяем что доступ к VM имеется и docker развернул контенеры с stack приложений. 
<img width="1596" height="152" alt="изображение" src="https://github.com/user-attachments/assets/8afd55dc-4bbd-497e-9d60-844973a1867f" />

4. Проверяем работу приложения
<img width="1561" height="237" alt="изображение" src="https://github.com/user-attachments/assets/24964ba6-2c0f-4525-bdeb-9b7c9620885e" />
<img width="1903" height="221" alt="изображение" src="https://github.com/user-attachments/assets/e72e1abd-df0f-436e-8956-afcf3623e5da" />

Приложение работает инфраструктура равзвернута успешно. 



  
  








