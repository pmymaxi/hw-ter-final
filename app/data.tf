# data подключения к bucket s3
data "terraform_remote_state" "vpc_s3" {
  count = var.use_remote_state ? 1 : 0

  backend = "s3"

  config = {
    bucket = var.s3_remote_state.vpc.bucket
    key    = var.s3_remote_state.vpc.key
    region = var.s3_remote_state.vpc.region
    use_lockfile = var.s3_remote_state.vpc.use_lockfile

    access_key = var.access_key
    secret_key = var.secret_key

    endpoints = {
      s3 = var.s3_remote_state.vpc.endpoints.s3
    }

    skip_region_validation      = var.s3_remote_state.vpc.skip_region_validation
    skip_credentials_validation = var.s3_remote_state.vpc.skip_credentials_validation
    skip_requesting_account_id  = var.s3_remote_state.vpc.skip_requesting_account_id
    skip_s3_checksum            = var.s3_remote_state.vpc.skip_s3_checksum
  }
}
data "terraform_remote_state" "vault_s3" {
  count = var.use_remote_state ? 1 : 0

  backend = "s3"

  config = {
    bucket = var.s3_remote_state.vault.bucket
    key    = var.s3_remote_state.vault.key
    region = var.s3_remote_state.vault.region
    use_lockfile = var.s3_remote_state.vault.use_lockfile

    access_key = var.access_key
    secret_key = var.secret_key

    endpoints = {
      s3 = var.s3_remote_state.vault.endpoints.s3
    }

    skip_region_validation      = var.s3_remote_state.vault.skip_region_validation
    skip_credentials_validation = var.s3_remote_state.vault.skip_credentials_validation
    skip_requesting_account_id  = var.s3_remote_state.vault.skip_requesting_account_id
    skip_s3_checksum            = var.s3_remote_state.vault.skip_s3_checksum
  }
}
data "terraform_remote_state" "container_registry_s3" {
  count = var.use_remote_state ? 1 : 0

  backend = "s3"

  config = {
    bucket = var.s3_remote_state.registry.bucket
    key    = var.s3_remote_state.registry.key
    region = var.s3_remote_state.registry.region
    use_lockfile = var.s3_remote_state.registry.use_lockfile

    access_key = var.access_key
    secret_key = var.secret_key

    endpoints = {
      s3 = var.s3_remote_state.registry.endpoints.s3
    }

    skip_region_validation      = var.s3_remote_state.registry.skip_region_validation
    skip_credentials_validation = var.s3_remote_state.registry.skip_credentials_validation
    skip_requesting_account_id  = var.s3_remote_state.registry.skip_requesting_account_id
    skip_s3_checksum            = var.s3_remote_state.registry.skip_s3_checksum
  }
}

data "terraform_remote_state" "s3" {
  count = var.use_remote_state ? 1 : 0

  backend = "s3"

  config = {
    bucket = var.s3_remote_state.s3.bucket
    key    = var.s3_remote_state.s3.key
    region = var.s3_remote_state.s3.region
    use_lockfile = var.s3_remote_state.s3.use_lockfile

    access_key = var.access_key
    secret_key = var.secret_key

    endpoints = {
      s3 = var.s3_remote_state.s3.endpoints.s3
    }

    skip_region_validation      = var.s3_remote_state.s3.skip_region_validation
    skip_credentials_validation = var.s3_remote_state.s3.skip_credentials_validation
    skip_requesting_account_id  = var.s3_remote_state.s3.skip_requesting_account_id
    skip_s3_checksum            = var.s3_remote_state.s3.skip_s3_checksum
  }
}

# Подключение к локальному tf state 
data "terraform_remote_state" "vpc_local" {
  count = !var.use_remote_state ? 1 : 0
  backend = "local"
  config = {
    path = "../vpc/terraform.tfstate"
  }
}
data "terraform_remote_state" "vault_local" {
  count = !var.use_remote_state ? 1 : 0
  backend = "local"
  config = {
    path = "../vault/terraform.tfstate"
  }
  }

data "terraform_remote_state" "container_registry_local" {
  count = !var.use_remote_state ? 1 : 0
  backend = "local"
  config = {
    path = "../container_registry/terraform.tfstate"
  }
}

data "terraform_remote_state" "s3_local" {
  count = !var.use_remote_state ? 1 : 0
  backend = "local"
  config = {
    path = "../s3/terraform.tfstate"
  }
}

locals {
  network = ( 
    var.use_remote_state
    ? data.terraform_remote_state.vpc_s3[0].outputs.network
    : data.terraform_remote_state.vpc_local[0].outputs.network
  )
  security_group = ( 
    var.use_remote_state
    ? data.terraform_remote_state.vpc_s3[0].outputs.security_group
    : data.terraform_remote_state.vpc_local[0].outputs.security_group
  )
  vault_ip = ( 
    var.use_remote_state
    ? data.terraform_remote_state.vault_s3[0].outputs.vault_ip
    : data.terraform_remote_state.vault_local[0].outputs.vault_ip
  )
  container_registry_s3 = ( 
    var.use_remote_state
    ? data.terraform_remote_state.container_registry_s3[0].outputs.registry.name
    : data.terraform_remote_state.container_registry_local[0].outputs.registry.name
  )
  s3_pull_key = ( 
    var.use_remote_state
    ? data.terraform_remote_state.s3[0].outputs.key-s3.pull
    : data.terraform_remote_state.s3_local[0].outputs.key-s3.pull
  )   
}
