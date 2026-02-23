# Инструкция по проверке работы модуля Terraform

## Предварительная подготовка

### 1. Установка необходимых инструментов

```bash
# Проверка установки Terraform
terraform version

# Если Terraform не установлен, установите его:
# macOS
brew install terraform

# Linux
wget https://releases.hashicorp.com/terraform/1.6.0/terraform_1.6.0_linux_amd64.zip
unzip terraform_1.6.0_linux_amd64.zip
sudo mv terraform /usr/local/bin/
```

### 2. Настройка Yandex Cloud

```bash
# Установка Yandex Cloud CLI (если еще не установлен)
curl -sSL https://storage.yandexcloud.net/yandexcloud-yc/install.sh | bash

# Перезапустите терминал или выполните:
exec -l $SHELL

# Инициализация YC CLI
yc init

# Получение OAuth токена (откроется браузер)
yc config list
```

### 3. Создание необходимых ресурсов в Yandex Cloud

```bash
# Создание сети (если еще нет)
yc vpc network create --name test-network --description "Test network for Terraform"

# Создание подсети
yc vpc subnet create \
  --name test-subnet \
  --network-name test-network \
  --zone ru-central1-a \
  --range 10.128.0.0/24

# Сохраните ID подсети - он понадобится для конфигурации
yc vpc subnet list
```

### 4. Подготовка SSH ключа

```bash
# Генерация SSH ключа (если еще нет)
ssh-keygen -t rsa -b 4096 -C "your_email@example.com" -f ~/.ssh/yc_terraform

# Просмотр публичного ключа
cat ~/.ssh/yc_terraform.pub
```

### 5. Настройка переменных окружения

```bash
# Получение необходимых ID
yc config list

# Установка переменных окружения
export YC_TOKEN=$(yc iam create-token)
export YC_CLOUD_ID=$(yc config get cloud-id)
export YC_FOLDER_ID=$(yc config get folder-id)

# Проверка
echo $YC_TOKEN
echo $YC_CLOUD_ID
echo $YC_FOLDER_ID
```

## Проверка синтаксиса и валидации

### 1. Проверка форматирования кода

```bash
# Переход в корневую директорию проекта
cd task1

# Проверка форматирования всех файлов
terraform fmt -check -recursive

# Автоматическое форматирование (если нужно)
terraform fmt -recursive
```

### 2. Валидация модуля

```bash
# Валидация модуля vm
cd modules/vm
terraform init
terraform validate

# Должно вывести: Success! The configuration is valid.
```

## Тестирование DEV окружения

### 1. Редактирование конфигурации

```bash
cd ../../envs/dev

# Откройте dev.tfvars и замените:
# - subnet_id на реальный ID вашей подсети
# - ssh_key на ваш публичный SSH ключ
nano dev.tfvars
```

Пример правильного [`dev.tfvars`](task1/envs/dev/dev.tfvars:1):
```hcl
vm_name   = "dev-vm-01"
cores     = 2
memory    = 4
disk_size = 50
disk_type = "network-hdd"

subnet_id = "e9b1a2b3c4d5e6f7g8h9"  # Ваш реальный ID
ssh_key   = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC..."  # Ваш реальный ключ

zone         = "ru-central1-a"
image_family = "ubuntu-2004-lts"
platform_id  = "standard-v2"
preemptible  = true
nat          = true

labels = {
  environment = "dev"
  project     = "future-pro-2-0"
  managed_by  = "terraform"
}
```

### 2. Инициализация Terraform

```bash
# Инициализация (загрузка провайдеров)
terraform init

# Вывод должен содержать:
# Terraform has been successfully initialized!
```

### 3. Проверка плана

```bash
# Создание плана выполнения
terraform plan -var-file=dev.tfvars

# Проверьте вывод:
# - Должно быть создано 2 ресурса (VM + Disk)
# - Проверьте параметры ресурсов
# - Убедитесь, что нет ошибок
```

### 4. Применение конфигурации (опционально)

⚠️ **ВНИМАНИЕ**: Это создаст реальные ресурсы в облаке, за которые будет взиматься плата!

```bash
# Применение конфигурации
terraform apply -var-file=dev.tfvars

# Введите 'yes' для подтверждения

# После успешного создания вы увидите outputs:
# Outputs:
# disk_id = "fhm1a2b3c4d5e6f7g8h9"
# disk_name = "dev-vm-01-disk"
# external_ip = "51.250.X.X"
# internal_ip = "10.128.0.X"
# vm_id = "fhm9i8j7k6l5m4n3o2p1"
# vm_name = "dev-vm-01"
```

### 5. Проверка созданных ресурсов

```bash
# Просмотр созданных ВМ
yc compute instance list

# Просмотр дисков
yc compute disk list

# Подключение к ВМ по SSH
ssh -i ~/.ssh/yc_terraform ubuntu@<external_ip>

# Проверка подключенного диска
lsblk
```

### 6. Удаление ресурсов

```bash
# Удаление всех созданных ресурсов
terraform destroy -var-file=dev.tfvars

# Введите 'yes' для подтверждения
```

## Тестирование STAGE окружения

```bash
cd ../stage

# 1. Редактирование stage.tfvars
nano stage.tfvars

# 2. Инициализация
terraform init

# 3. Проверка плана
terraform plan -var-file=stage.tfvars

# 4. Применение (опционально)
terraform apply -var-file=stage.tfvars

# 5. Удаление
terraform destroy -var-file=stage.tfvars
```

## Тестирование PROD окружения

```bash
cd ../prod

# 1. Редактирование prod.tfvars
nano prod.tfvars

# 2. Инициализация
terraform init

# 3. Проверка плана
terraform plan -var-file=prod.tfvars

# 4. Применение (опционально)
terraform apply -var-file=prod.tfvars

# 5. Удаление
terraform destroy -var-file=prod.tfvars
```

## Проверка переиспользуемости модуля

### Тест 1: Создание кастомной конфигурации

```bash
cd ../dev

# Создайте новый файл custom.tfvars
cat > custom.tfvars << 'EOF'
vm_name   = "custom-test-vm"
cores     = 3
memory    = 6
disk_size = 75
disk_type = "network-ssd"
subnet_id = "YOUR_SUBNET_ID"
ssh_key   = "YOUR_SSH_KEY"
zone      = "ru-central1-a"

labels = {
  environment = "testing"
  purpose     = "validation"
}
EOF

# Проверка с кастомной конфигурацией
terraform plan -var-file=custom.tfvars
```

### Тест 2: Проверка валидации

```bash
# Создайте файл с некорректными значениями
cat > invalid.tfvars << 'EOF'
vm_name   = "test-vm"
cores     = 0  # Некорректное значение
memory    = -5  # Некорректное значение
disk_size = 50
subnet_id = "test"
ssh_key   = "test"
EOF

# Попытка применить - должна выдать ошибку валидации
terraform plan -var-file=invalid.tfvars

# Ожидаемый результат: ошибки валидации
```

## Проверка outputs

```bash
# После применения конфигурации
terraform output

# Проверка конкретного output
terraform output external_ip
terraform output vm_id

# Вывод в JSON формате
terraform output -json
```

## Автоматизированная проверка

Создайте скрипт для автоматической проверки всех окружений:

```bash
cat > test_all_envs.sh << 'EOF'
#!/bin/bash

ENVS=("dev" "stage" "prod")

for env in "${ENVS[@]}"; do
    echo "========================================="
    echo "Testing $env environment"
    echo "========================================="

    cd "envs/$env"

    # Инициализация
    echo "Initializing..."
    terraform init -upgrade

    # Валидация
    echo "Validating..."
    terraform validate

    # Форматирование
    echo "Checking format..."
    terraform fmt -check

    # План
    echo "Creating plan..."
    terraform plan -var-file="${env}.tfvars" -out="${env}.tfplan"

    echo "$env environment: OK"
    echo ""

    cd ../..
done

echo "All environments tested successfully!"
EOF

chmod +x test_all_envs.sh
./test_all_envs.sh
```

## Чек-лист проверки

- [ ] Terraform установлен и работает
- [ ] Yandex Cloud CLI настроен
- [ ] Переменные окружения установлены
- [ ] Подсеть создана в Yandex Cloud
- [ ] SSH ключ сгенерирован
- [ ] Файлы .tfvars отредактированы с реальными значениями
- [ ] `terraform init` выполнен успешно для всех окружений
- [ ] `terraform validate` проходит без ошибок
- [ ] `terraform plan` создает корректный план
- [ ] Различия между окружениями видны в планах
- [ ] Outputs определены и доступны
- [ ] Валидация параметров работает корректно

## Ожидаемые результаты

### DEV окружение
- 2 ядра, 4 ГБ RAM
- Диск 50 ГБ, тип network-hdd
- Прерываемая ВМ (preemptible = true)
- Платформа standard-v2

### STAGE окружение
- 4 ядра, 8 ГБ RAM
- Диск 100 ГБ, тип network-ssd
- Обычная ВМ (preemptible = false)
- Платформа standard-v2

### PROD окружение
- 8 ядер, 16 ГБ RAM
- Диск 200 ГБ, тип network-ssd-nonreplicated
- Обычная ВМ (preemptible = false)
- Платформа standard-v3

## Устранение проблем

### Ошибка: "Error: Failed to query available provider packages"
```bash
# Очистка кэша и повторная инициализация
rm -rf .terraform .terraform.lock.hcl
terraform init
```

### Ошибка: "Error: subnet not found"
```bash
# Проверьте ID подсети
yc vpc subnet list

# Обновите subnet_id в .tfvars файле
```

### Ошибка: "Error: Unauthorized"
```bash
# Обновите токен
export YC_TOKEN=$(yc iam create-token)
```

### Ошибка: "Error: quota exceeded"
```bash
# Проверьте квоты
yc resource-manager quota list

# Запросите увеличение квот или удалите неиспользуемые ресурсы
```

## Дополнительные проверки

### Проверка state файла
```bash
# Просмотр состояния
terraform show

# Список ресурсов в state
terraform state list

# Детали конкретного ресурса
terraform state show module.vm.yandex_compute_instance.vm
```

### Проверка графа зависимостей
```bash
# Генерация графа
terraform graph | dot -Tpng > graph.png

# Просмотр graph.png
```

## Заключение

После успешного прохождения всех проверок модуль готов к использованию в production и может быть включен в пул-реквест.
