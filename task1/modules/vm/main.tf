terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.100.0"
    }
  }
}

# Получение образа ОС
data "yandex_compute_image" "os_image" {
  family = var.image_family
}

# Создание виртуальной машины
resource "yandex_compute_instance" "vm" {
  name        = var.vm_name
  platform_id = var.platform_id
  zone        = var.zone
  labels      = var.labels

  resources {
    cores  = var.cores
    memory = var.memory
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.os_image.id
      size     = 20
      type     = "network-hdd"
    }
  }

  # Подключаемый дополнительный диск
  secondary_disk {
    disk_id     = yandex_compute_disk.additional_disk.id
    auto_delete = false
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = var.nat
  }

  metadata = {
    ssh-keys = "ubuntu:${var.ssh_key}"
  }

  scheduling_policy {
    preemptible = var.preemptible
  }
}

# Создание дополнительного диска
resource "yandex_compute_disk" "additional_disk" {
  name = "${var.vm_name}-disk"
  type = var.disk_type
  zone = var.zone
  size = var.disk_size

  labels = merge(
    var.labels,
    {
      attached_to = var.vm_name
    }
  )
}
