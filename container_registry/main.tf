# Создание Сontainer Registry
resource "yandex_container_registry" "my-registry" {
  name = var.registry.name_registry
}
# Создание repository
resource "yandex_container_repository" "app" {
  name = "${yandex_container_registry.my-registry.id}/${var.registry.name_repository}"
}

# Создание сервисного аккаунта
resource "yandex_iam_service_account" "registry-sa" {
  name      = var.registry.name_sa
  folder_id = var.folder_id
}

# Назначение роли сервисному аккаунту
resource "yandex_resourcemanager_folder_iam_member" "registry-sa-role-images-puller" {
  folder_id = var.folder_id
  role      = var.registry.role_sa
  member    = "serviceAccount:${yandex_iam_service_account.registry-sa.id}"
}

# Назначение прав на all pull repo app
resource "yandex_container_repository_iam_binding" "app_pull" {
  repository_id = yandex_container_repository.app.id

  role = "container-registry.images.puller"

   members = [
    "system:allUsers"
  ]
}