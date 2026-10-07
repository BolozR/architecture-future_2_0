variable "name" {
  description = "Имя ВМ и префикс связанных ресурсов."
  type        = string
}
variable "folder_id" {
  description = "Каталог Yandex Cloud для ресурсов."
  type        = string
}
variable "subnet_id" {
  description = "Существующая подсеть; из неё берём сеть и зону."
  type        = string
}
variable "image_id" {
  description = "ID Linux-образа с cloud-init."
  type        = string
}
variable "cores" {
  description = "Число vCPU. Допустимые сочетания зависят от platform_id."
  type        = number
  validation {
    condition     = var.cores >= 2 && floor(var.cores) == var.cores
    error_message = "Нужно целое число vCPU, не меньше 2."
  }
}
variable "memory_gb" {
  description = "RAM в ГБ."
  type        = number
  validation {
    condition     = var.memory_gb > 0
    error_message = "RAM должна быть больше нуля."
  }
}
variable "data_disk" {
  description = "Отдельный диск: размер в ГБ и тип. Подключение без форматирования."
  type = object({
    size_gb = number
    type    = string
  })
  validation {
    condition = (var.data_disk.size_gb > 0 && floor(var.data_disk.size_gb) == var.data_disk.size_gb
    && contains(["network-hdd", "network-ssd"], var.data_disk.type))
    error_message = "Размер — положительное целое число; тип — network-hdd или network-ssd."
  }
}
variable "ssh_public_key" {
  description = "Содержимое публичного SSH-ключа, не путь и не приватный ключ."
  type        = string
  validation {
    condition     = can(regex("^ssh-(ed25519|rsa) [A-Za-z0-9+/=]+", trimspace(var.ssh_public_key)))
    error_message = "Передайте публичный ключ ssh-ed25519 или ssh-rsa."
  }
}
variable "ssh_cidrs" {
  description = "Сети администрирования с доступом к TCP/22."
  type        = list(string)
  validation {
    condition     = length(var.ssh_cidrs) > 0 && alltrue([for cidr in var.ssh_cidrs : can(cidrnetmask(cidr)) && cidr != "0.0.0.0/0"])
    error_message = "Нужны IPv4 CIDR; SSH на весь интернет не открываем."
  }
}
variable "ssh_user" {
  description = "Существующий пользователь Linux-образа."
  type        = string
  default     = "ubuntu"
}
variable "platform_id" {
  description = "Платформа Compute Cloud."
  type        = string
  default     = "standard-v3"
}
variable "core_fraction" {
  description = "Гарантированная доля vCPU в процентах."
  type        = number
  default     = 100
}
variable "boot_disk_size_gb" {
  description = "Размер загрузочного диска в ГБ."
  type        = number
  default     = 20
}
variable "boot_disk_type" {
  description = "Тип загрузочного диска."
  type        = string
  default     = "network-ssd"
}
variable "enable_nat" {
  description = "Выдать публичный IP. При false SSH нужен через VPN/bastion."
  type        = bool
  default     = false
}
variable "preemptible" {
  description = "Разрешить прерываемую ВМ."
  type        = bool
  default     = false
}
variable "labels" {
  description = "Метки ресурсов."
  type        = map(string)
  default     = {}
}
