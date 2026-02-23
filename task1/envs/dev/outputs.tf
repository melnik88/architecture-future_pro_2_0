output "vm_id" {
  description = "ID виртуальной машины"
  value       = module.vm.vm_id
}

output "vm_name" {
  description = "Имя виртуальной машины"
  value       = module.vm.vm_name
}

output "internal_ip" {
  description = "Внутренний IP-адрес"
  value       = module.vm.internal_ip
}

output "external_ip" {
  description = "Внешний IP-адрес"
  value       = module.vm.external_ip
}

output "disk_id" {
  description = "ID дополнительного диска"
  value       = module.vm.disk_id
}

output "disk_name" {
  description = "Имя дополнительного диска"
  value       = module.vm.disk_name
}
