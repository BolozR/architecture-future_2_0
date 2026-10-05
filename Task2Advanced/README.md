# CI/CD и состояние

Используем модуль из Task1 и backend в Yandex Object Storage. У каждой среды свои bucket, сервисный аккаунт и каталог. Корневой `.gitlab-ci.yml` подключает [pipeline.yml](pipeline.yml).

## Настройка

Создаём приватный bucket для каждой среды, включаем versioning и шифрование. Аккаунту даём доступ к своему bucket: чтение списка объектов, чтение/запись state и чтение/запись/удаление `.tflock`. При KMS нужны права на ключ. Права провайдера ограничиваем каталогом среды.

В GitLab добавляем переменные со scope `dev`, `stage` или `prod`:

- `TF_STATE_BUCKET`;
- `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` — ключ Object Storage;
- `YC_SERVICE_ACCOUNT_KEY_FILE` — JSON-ключ провайдера, переменная типа File;
- `TF_VAR_folder_id`, `TF_VAR_subnet_id`, `TF_VAR_image_id`, `TF_VAR_ssh_public_key`, `TF_VAR_ssh_cidrs` — как в [Task1](../Task1Advanced/README.md#запуск).

Секреты отмечаем Protected и Masked/Hidden, JSON-ключ храним как Protected File variable. Защищаем ветку, runner и prod environment. Ключи в репозиторий не добавляем.

## Запуск

В GitLab открываем Run pipeline на защищённой ветке и выбираем `DEPLOY_ENV`: dev, stage или prod. После просмотра плана запускаем ручной job `apply`.

[terraform.sh](scripts/terraform.sh) принимает действие и среду:

| действие | что выполняет |
|---|---|
| `init` | подключает backend из `backend.hcl`, bucket берёт из `TF_STATE_BUCKET` |
| `plan` | init, fmt, validate, plan с `.tfvars`; сохраняет план и его текст |
| `apply` | init и применение сохранённого плана из того же pipeline; только в защищённом CI-запуске |

`resource_group` разделяет запуски по средам, `.tflock` блокирует параллельные операции со state. Артефакты доступны Maintainer и хранятся час; в настройках GitLab отключаем сохранение артефактов последнего успешного pipeline.

Локальный plan из корня проекта, после задания переменных:

```bash
export TF_CLI_CONFIG_FILE="$PWD/Task2Advanced/terraform.rc"
sh Task2Advanced/scripts/terraform.sh plan dev
```

`terraform.rc` задаёт зеркало провайдера. Для stage/prod меняем среду и её переменные. Рабочий state хранится в Object Storage.

Если Task1 уже применяли, сначала сохраняем копию state и переносим его через `terraform init -migrate-state` с S3 backend и настройками нужной среды. После нулевого plan управляем ресурсами только из Task2.
