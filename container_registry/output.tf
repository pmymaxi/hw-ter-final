output "push_docker" {
  value = <<EOF
    
    Авторизация в registry yandex cloud:
    echo "Key" | docker login --username oauth --password-stdin cr.yandex

    Build docker образа:
    docker build . -t cr.yandex/${yandex_container_registry.my-registry.id}/${var.registry.name_repository}:1.0.1 -f dockerfile
    
    Формат строки path registry: cr.yandex/<REGISTRY_ID>/<NAME_REPO>:<VERSION>

    Push образа в registry:
    docker push cr.yandex/${yandex_container_registry.my-registry.id}/${var.registry.name_repository}:1.0.1
  EOF
}
output "registry" {
  value = {
    name = yandex_container_registry.my-registry.id
  }
}