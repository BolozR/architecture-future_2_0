provider "yandex" {
  folder_id = var.folder_id
}
module "vm_module" {
  source         = "../../modules/vm"
  name           = var.name
  folder_id      = var.folder_id
  subnet_id      = var.subnet_id
  image_id       = var.image_id
  cores          = var.cores
  memory_gb      = var.memory_gb
  data_disk      = var.data_disk
  ssh_public_key = var.ssh_public_key
  ssh_cidrs      = var.ssh_cidrs
  enable_nat     = var.enable_nat
  preemptible    = var.preemptible
  labels         = { environment = "stage", project = "future-2-0" }
}
