terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.100.0"
    }
  }
}

provider "yandex" {
  # Конфигурация провайдера через переменные окружения:
  # YC_TOKEN, YC_CLOUD_ID, YC_FOLDER_ID
  zone = var.zone
}

module "vm" {
  source = "../../modules/vm"

  vm_name      = var.vm_name
  cores        = var.cores
  memory       = var.memory
  disk_size    = var.disk_size
  disk_type    = var.disk_type
  subnet_id    = var.subnet_id
  zone         = var.zone
  ssh_key      = var.ssh_key
  image_family = var.image_family
  platform_id  = var.platform_id
  preemptible  = var.preemptible
  nat          = var.nat
  labels       = var.labels
}
