# Модуль Terraform для управления виртуальными машинами

Универсальный модуль Terraform для создания и управления виртуальными машинами в Yandex Cloud с поддержкой различных окружений (dev, stage, prod).

## Описание

Модуль предоставляет гибкий и переиспользуемый способ развертывания виртуальных машин с дополнительными дисками в облачной инфраструктуре Yandex Cloud. Модуль полностью параметризован и не содержит захардкоженных значений, что позволяет использовать его для различных окружений с разными конфигурациями.

## Структура проекта

```
task1/
├── modules/
│   └── vm/
│       ├── main.tf          # Основные ресурсы (ВМ, диск, сеть)
│       ├── variables.tf     # Входные параметры модуля
│       └── outputs.tf       # Выходные данные модуля
└── envs/
    ├── dev/
    │   ├── main.tf          # Конфигурация для dev окружения
    │   ├── variables.tf     # Переменные для dev
    │   ├── outputs.tf       # Выходы для dev
    │   └── dev.tfvars       # Значения переменных для dev
    ├── stage/
    │   ├── main.tf          # Конфигурация для stage окружения
    │   ├── variables.tf     # Переменные для stage
    │   ├── outputs.tf       # Выходы для stage
    │   └── stage.tfvars     # Значения переменных для stage
    └── prod/
        ├── main.tf          # Конфигурация для prod окружения
        ├── variables.tf     # Переменные для prod
        ├── outputs.tf       # Выходы для prod
        └── prod.tfvars      # Значения переменных для prod
```

## Возможности модуля

- Создание виртуальной машины с настраиваемыми ресурсами (CPU, RAM)
- Подключение дополнительного диска с настраиваемым размером и типом
- Настройка сетевых параметров (subnet, NAT)
- Поддержка SSH-ключей для доступа
- Гибкая конфигурация через переменные
- Поддержка меток (labels) для организации ресурсов
- Валидация входных параметров
- Полная переиспользуемость для разных окружений

## Параметры модуля

### Обязательные параметры

| Параметр | Тип | Описание |
|----------|-----|----------|
| `vm_name` | string | Имя виртуальной машины |
| `cores` | number | Количество ядер процессора (1-64) |
| `memory` | number | Объём оперативной памяти в ГБ |
| `disk_size` | number | Размер дополнительного диска в ГБ |
| `subnet_id` | string | ID подсети для размещения ВМ |
| `ssh_key` | string | SSH публичный ключ для доступа |

### Опциональные параметры

| Параметр | Тип | Значение по умолчанию | Описание |
|----------|-----|-----------------------|----------|
| `disk_type` | string | `"network-hdd"` | Тип диска (network-hdd, network-ssd, network-ssd-nonreplicated) |
| `zone` | string | `"ru-central1-a"` | Зона доступности |
| `image_family` | string | `"ubuntu-2004-lts"` | Семейство образа ОС |
| `platform_id` | string | `"standard-v2"` | Платформа для ВМ |
| `preemptible` | bool | `false` | Использовать прерываемую ВМ |
| `nat` | bool | `true` | Включить NAT для публичного IP |
| `labels` | map(string) | `{}` | Метки для ресурсов |

## Выходные данные модуля

| Выход | Описание |
|-------|----------|
| `vm_id` | ID виртуальной машины |
| `vm_name` | Имя виртуальной машины |
| `vm_fqdn` | FQDN виртуальной машины |
| `internal_ip` | Внутренний IP-адрес |
| `external_ip` | Внешний IP-адрес (если NAT включен) |
| `disk_id` | ID дополнительного диска |
| `disk_name` | Имя дополнительного диска |
| `disk_size` | Размер дополнительного диска в ГБ |
| `zone` | Зона размещения ресурсов |
| `platform_id` | Платформа виртуальной машины |
| `cores` | Количество ядер процессора |
| `memory` | Объём оперативной памяти в ГБ |

## Конфигурация окружений

### DEV окружение
- **Ресурсы**: 2 ядра, 4 ГБ RAM
- **Диск**: 50 ГБ, network-hdd
- **Особенности**: Прерываемая ВМ для экономии средств

### STAGE окружение
- **Ресурсы**: 4 ядра, 8 ГБ RAM
- **Диск**: 100 ГБ, network-ssd
- **Особенности**: Обычная ВМ, SSD диск для лучшей производительности

### PROD окружение
- **Ресурсы**: 8 ядер, 16 ГБ RAM
- **Диск**: 200 ГБ, network-ssd-nonreplicated
- **Особенности**: Высокопроизводительная платформа (standard-v3), максимальная производительность

## Предварительные требования

1. Установленный Terraform (версия >= 1.0)
2. Аккаунт в Yandex Cloud
3. Настроенные переменные окружения:
   - `YC_TOKEN` - OAuth токен или IAM токен
   - `YC_CLOUD_ID` - ID облака
   - `YC_FOLDER_ID` - ID каталога
4. Созданная подсеть в Yandex Cloud
5. SSH ключ для доступа к ВМ

## Установка и настройка

### 1. Установка Yandex Cloud CLI (опционально)

```bash
curl -sSL https://storage.yandexcloud.net/yandexcloud-yc/install.sh | bash
yc init
```

### 2. Настройка переменных окружения

```bash
export YC_TOKEN="your-token-here"
export YC_CLOUD_ID="your-cloud-id"
export YC_FOLDER_ID="your-folder-id"
```

### 3. Редактирование конфигурации

Перед применением необходимо отредактировать файлы `.tfvars` для каждого окружения и указать:
- Реальный `subnet_id` вашей подсети
- Ваш публичный SSH ключ в параметре `ssh_key`

## Использование

### Развертывание DEV окружения

```bash
# Переход в директорию dev окружения
cd envs/dev

# Инициализация Terraform
terraform init

# Просмотр плана изменений
terraform plan -var-file=dev.tfvars

# Применение конфигурации
terraform apply -var-file=dev.tfvars

# Просмотр выходных данных
terraform output
```

### Развертывание STAGE окружения

```bash
# Переход в директорию stage окружения
cd envs/stage

# Инициализация Terraform
terraform init

# Просмотр плана изменений
terraform plan -var-file=stage.tfvars

# Применение конфигурации
terraform apply -var-file=stage.tfvars

# Просмотр выходных данных
terraform output
```

### Развертывание PROD окружения

```bash
# Переход в директорию prod окружения
cd envs/prod

# Инициализация Terraform
terraform init

# Просмотр плана изменений
terraform plan -var-file=prod.tfvars

# Применение конфигурации
terraform apply -var-file=prod.tfvars

# Просмотр выходных данных
terraform output
```

### Удаление ресурсов

```bash
# Для любого окружения
terraform destroy -var-file=<env>.tfvars
```

## Примеры использования

### Пример 1: Создание кастомной конфигурации

Создайте свой файл `custom.tfvars`:

```hcl
vm_name   = "custom-vm"
cores     = 6
memory    = 12
disk_size = 150
disk_type = "network-ssd"
subnet_id = "your-subnet-id"
ssh_key   = "your-ssh-key"

labels = {
  environment = "testing"
  team        = "devops"
}
```

Примените конфигурацию:

```bash
terraform apply -var-file=custom.tfvars
```

### Пример 2: Использование модуля в другом проекте

```hcl
module "my_vm" {
  source = "../../modules/vm"

  vm_name   = "my-application-vm"
  cores     = 4
  memory    = 8
  disk_size = 100
  subnet_id = "e9b12345678901234"
  ssh_key   = file("~/.ssh/id_rsa.pub")

  labels = {
    application = "my-app"
    environment = "production"
  }
}

output "vm_ip" {
  value = module.my_vm.external_ip
}
```

## Подключение к созданной ВМ

После успешного развертывания подключитесь к ВМ по SSH:

```bash
# Получите внешний IP из outputs
terraform output external_ip

# Подключитесь к ВМ
ssh ubuntu@<external_ip>
```

## Мониторинг и управление

### Просмотр состояния ресурсов

```bash
terraform show
```

### Обновление конфигурации

1. Измените параметры в `.tfvars` файле
2. Выполните `terraform plan -var-file=<env>.tfvars` для просмотра изменений
3. Примените изменения: `terraform apply -var-file=<env>.tfvars`

### Импорт существующих ресурсов

```bash
terraform import module.vm.yandex_compute_instance.vm <vm-id>
terraform import module.vm.yandex_compute_disk.additional_disk <disk-id>
```

## Рекомендации по безопасности

1. **Не храните чувствительные данные в репозитории**
   - Используйте `.gitignore` для исключения файлов с секретами
   - Храните SSH ключи и токены в безопасном месте

2. **Используйте Terraform Backend**
   - Настройте удаленное хранилище состояния (S3, Terraform Cloud)
   - Включите блокировку состояния

3. **Ограничьте доступ к ВМ**
   - Используйте security groups для ограничения входящего трафика
   - Регулярно обновляйте SSH ключи

4. **Используйте переменные окружения**
   - Не храните токены в коде
   - Используйте `YC_TOKEN` и другие переменные окружения

## Устранение неполадок

### Ошибка: "subnet not found"
Убедитесь, что указан корректный `subnet_id` в `.tfvars` файле.

### Ошибка: "quota exceeded"
Проверьте квоты в вашем облаке Yandex Cloud и при необходимости увеличьте их.

### Ошибка: "invalid ssh key"
Убедитесь, что SSH ключ указан в правильном формате (публичный ключ, начинающийся с `ssh-rsa`).

## Дополнительные возможности

### Добавление нескольких ВМ

Используйте `count` или `for_each` для создания нескольких экземпляров:

```hcl
module "vm" {
  source = "../../modules/vm"
  count  = 3

  vm_name   = "vm-${count.index + 1}"
  cores     = var.cores
  memory    = var.memory
  disk_size = var.disk_size
  subnet_id = var.subnet_id
  ssh_key   = var.ssh_key
}
```

## Лицензия

Этот модуль создан для учебных целей в рамках проекта "Будущее 2.0".

## Контакты и поддержка

При возникновении вопросов или проблем создайте issue в репозитории проекта.
