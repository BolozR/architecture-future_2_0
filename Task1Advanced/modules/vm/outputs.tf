output "vm_id" {
  description = "ID виртуальной машины."
  value       = yandex_compute_instance.vm.id
}
output "name" {
  description = "Имя виртуальной машины."
  value       = yandex_compute_instance.vm.name
}
output "private_ip" {
  description = "Внутренний IPv4."
  value       = yandex_compute_instance.vm.network_interface[0].ip_address
}
output "public_ip" {
  description = "Публичный IPv4 или null, если NAT выключен."
  value       = var.enable_nat ? yandex_compute_instance.vm.network_interface[0].nat_ip_address : null
}
output "disk_id" {
  description = "ID отдельного диска данных."
  value       = yandex_compute_disk.data.id
}
output "security_group_id" {
  description = "ID группы безопасности."
  value       = yandex_vpc_security_group.vm.id
}
