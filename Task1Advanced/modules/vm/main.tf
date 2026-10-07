data "yandex_vpc_subnet" "selected" {
  subnet_id = var.subnet_id
}

resource "yandex_vpc_security_group" "vm" {
  name       = "${var.name}-sg"
  folder_id  = var.folder_id
  network_id = data.yandex_vpc_subnet.selected.network_id
  labels     = var.labels

  ingress {
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = var.ssh_cidrs
    description    = "SSH from the administration network"
  }
  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_compute_disk" "data" {
  name      = "${var.name}-data"
  folder_id = var.folder_id
  zone      = data.yandex_vpc_subnet.selected.zone
  type      = var.data_disk.type
  size      = var.data_disk.size_gb
  labels    = var.labels
}

resource "yandex_compute_instance" "vm" {
  name                      = var.name
  folder_id                 = var.folder_id
  zone                      = data.yandex_vpc_subnet.selected.zone
  platform_id               = var.platform_id
  allow_stopping_for_update = true
  labels                    = var.labels

  resources {
    cores         = var.cores
    memory        = var.memory_gb
    core_fraction = var.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = var.image_id
      size     = var.boot_disk_size_gb
      type     = var.boot_disk_type
    }
  }
  secondary_disk {
    disk_id     = yandex_compute_disk.data.id
    device_name = "data"
    auto_delete = false
  }
  network_interface {
    subnet_id          = var.subnet_id
    nat                = var.enable_nat
    security_group_ids = [yandex_vpc_security_group.vm.id]
  }
  metadata = {
    ssh-keys = "${var.ssh_user}:${trimspace(var.ssh_public_key)}"
  }
  scheduling_policy {
    preemptible = var.preemptible
  }
}
