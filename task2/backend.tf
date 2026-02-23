terraform {
  backend "s3" {
    # Yandex Object Storage для хранения состояния Terraform
    bucket   = "terraform-state-bucket"
    key      = "infrastructure/terraform.tfstate"
    region   = "ru-central1"
    endpoint = "https://storage.yandexcloud.net"

    # Пропускаем проверки AWS-специфичных функций
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true

    # Шифрование состояния на стороне сервера
    encrypt = true

    # Credentials передаются через переменные окружения:
    # AWS_ACCESS_KEY_ID - статический ключ доступа Yandex Object Storage
    # AWS_SECRET_ACCESS_KEY - секретный ключ Yandex Object Storage
  }

  required_version = ">= 1.0"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.100.0"
    }
  }
}
