vm_module = {
  vault = {
    env_name       = "dev"
    vpc_network    = "develop-network-hw-ter"
    vpc_subnet     = "manager-net-01"
    subnet_zones   = ["ru-central1-a"]
    instance_name  = "vault-vm"
    instance_count = 1
    image_family   = "ubuntu-2004-lts"
    public_ip      = true
    labels         = { project = "hw-ter-final" }
    metadata       = { serial-port-enable = "1" }
    cloud_init = {
      users = {
        name   = "dops"
        groups = "sudo,docker"
      }
      package = {
        package_update  = true
        package_upgrade = true
      }
      packages = [
        "ca-certificates",
        "curl",
        "gnupg"
      ]
    }
  }
}
