variable "folder_id" {
  description = "Каталог среды; передаётся через TF_VAR_folder_id."
  type        = string
}
variable "subnet_id" {
  description = "Существующая подсеть среды; TF_VAR_subnet_id."
  type        = string
}
variable "image_id" {
  description = "ID Ubuntu-образа с пользователем ubuntu; TF_VAR_image_id."
  type        = string
}
variable "ssh_public_key" {
  description = "Публичный SSH-ключ; TF_VAR_ssh_public_key."
  type        = string
}
variable "ssh_cidrs" {
  description = "Сети VPN/bastion для SSH; TF_VAR_ssh_cidrs в формате JSON."
  type        = list(string)
}
variable "name" { type = string }
variable "cores" { type = number }
variable "memory_gb" { type = number }
variable "data_disk" {
  type = object({
    size_gb = number
    type    = string
  })
}
variable "enable_nat" { type = bool }
variable "preemptible" { type = bool }
