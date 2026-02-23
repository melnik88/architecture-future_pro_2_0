variable "vm_name" {
  description = "Имя виртуальной машины"
  type        = string
}

variable "cores" {
  description = "Количество ядер процессора"
  type        = number
  validation {
    condition     = var.cores > 0 && var.cores <= 64
    error_message = "Количество ядер должно быть от 1 до 64"
  }
}

variable "memory" {
  description = "Объём оперативной памяти в ГБ"
  type        = number
  validation {
    condition     = var.memory > 0
    error_message = "Объём памяти должен быть больше 0"
  }
}

variable "disk_size" {
  description = "Размер подключаемого диска в ГБ"
  type        = number
  validation {
    condition     = var.disk_size > 0
    error_message = "Размер диска должен быть больше 0"
  }
}

variable "disk_type" {
  description = "Тип диска (network-hdd, network-ssd, network-ssd-nonreplicated)"
  type        = string
  default     = "network-hdd"
}

variable "subnet_id" {
  description = "ID подсети для размещения ВМ"
  type        = string
}

variable "zone" {
  description = "Зона доступности"
  type        = string
  default     = "ru-central1-a"
}

variable "ssh_key" {
  description = "SSH публичный ключ для доступа к ВМ"
  type        = string
}

variable "image_family" {
  description = "Семейство образа операционной системы"
  type        = string
  default     = "ubuntu-2004-lts"
}

variable "platform_id" {
  description = "Платформа для ВМ"
  type        = string
  default     = "standard-v2"
}

variable "preemptible" {
  description = "Использовать прерываемую ВМ"
  type        = bool
  default     = false
}

variable "nat" {
  description = "Включить NAT для публичного IP"
  type        = bool
  default     = true
}

variable "labels" {
  description = "Метки для ресурсов"
  type        = map(string)
  default     = {}
}
