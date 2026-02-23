output "vm_id" {
  description = "ID виртуальной машины"
  value       = yandex_compute_instance.vm.id
}

output "vm_name" {
  description = "Имя виртуальной машины"
  value       = yandex_compute_instance.vm.name
}

output "vm_fqdn" {
  description = "FQDN виртуальной машины"
  value       = yandex_compute_instance.vm.fqdn
}

output "internal_ip" {
  description = "Внутренний IP-адрес виртуальной машины"
  value       = yandex_compute_instance.vm.network_interface[0].ip_address
}

output "external_ip" {
  description = "Внешний IP-адрес виртуальной машины (если NAT включен)"
  value       = var.nat ? yandex_compute_instance.vm.network_interface[0].nat_ip_address : null
}

output "disk_id" {
  description = "ID дополнительного диска"
  value       = yandex_compute_disk.additional_disk.id
}

output "disk_name" {
  description = "Имя дополнительного диска"
  value       = yandex_compute_disk.additional_disk.name
}

output "disk_size" {
  description = "Размер дополнительного диска в ГБ"
  value       = yandex_compute_disk.additional_disk.size
}

output "zone" {
  description = "Зона размещения ресурсов"
  value       = var.zone
}

output "platform_id" {
  description = "Платформа виртуальной машины"
  value       = yandex_compute_instance.vm.platform_id
}

output "cores" {
  description = "Количество ядер процессора"
  value       = var.cores
}

output "memory" {
  description = "Объём оперативной памяти в ГБ"
  value       = var.memory
}
