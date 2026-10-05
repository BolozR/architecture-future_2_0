# Модуль ВМ

создаём ВМ, отдельный диск данных и группу безопасности в Yandex Cloud. Модуль `vm_module` подключается к существующей подсети, её сеть и зону получает по `subnet_id`.

Для dev, stage и prod используем один модуль и отдельные `.tfvars`:

| среда | vCPU / RAM | диск данных | прерываемая |
|---|---|---|---|
| dev | 2 / 2 ГБ | 20 ГБ HDD | да |
| stage | 2 / 4 ГБ | 50 ГБ SSD | нет |
| prod | 4 / 8 ГБ | 100 ГБ SSD | нет |

## Параметры

| параметр | значение |
|---|---|
| `data_disk` | `{ size_gb, type }`, тип network-hdd или network-ssd |
| `ssh_public_key` | содержимое публичного ключа, не путь к файлу |
| `ssh_cidrs` | список IPv4-сетей для SSH; `0.0.0.0/0` запрещён |

Выходы модуля: `vm_id`, `name`, `private_ip`, `public_ip`, `disk_id`, `security_group_id`. В окружениях собраны в output `vm`; без NAT публичный IP равен `null`.

## Запуск

Нужны Terraform 1.15.8, каталог и подсеть для каждой среды, Ubuntu-образ с cloud-init. Сервисному аккаунту нужны права на ВМ, диски, группы безопасности и чтение подсети.

Из корня проекта задаём параметры dev:

```bash
export TF_CLI_CONFIG_FILE="$PWD/Task2Advanced/terraform.rc"
export YC_SERVICE_ACCOUNT_KEY_FILE="/absolute/path/service-account.json"
export TF_VAR_folder_id="<ID каталога dev>"
export TF_VAR_subnet_id="<ID подсети dev>"
export TF_VAR_image_id="<ID Ubuntu-образа>"
export TF_VAR_ssh_public_key="$(cat ~/.ssh/id_ed25519.pub)"
export TF_VAR_ssh_cidrs='["10.10.0.0/24"]'

terraform -chdir=Task1Advanced/envs/dev init
terraform -chdir=Task1Advanced/envs/dev plan -var-file=dev.tfvars
terraform -chdir=Task1Advanced/envs/dev apply -var-file=dev.tfvars
```

Сеть SSH заменяем своей. Публичный IP выключен, подключаемся через VPN или bastion. Диск подключён как `data`, разметку и монтирование выполняем в ОС.

Перед запуском stage или prod меняем каталог, подсеть и сеть SSH на значения нужной среды:

```bash
terraform -chdir=Task1Advanced/envs/stage init
terraform -chdir=Task1Advanced/envs/stage apply -var-file=stage.tfvars

terraform -chdir=Task1Advanced/envs/prod init
terraform -chdir=Task1Advanced/envs/prod apply -var-file=prod.tfvars
```

После apply получаем ВМ, диск, группу безопасности и output `vm`. Состояние здесь локальное и отдельное для каждой среды. Удаление через `terraform destroy -var-file=dev.tfvars` из каталога dev удалит и диск данных.

