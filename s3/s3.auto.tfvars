# Service account
sa_name = {
    admin ={
        name     = "sa-admin-s3"
        role     = "storage.admin"
        role_kms = "kms.keys.encrypterDecrypter"
        desc_key = "static access key for object storage"
    }
    pull ={
        name     = "sa-pull-s3"
        role     = "storage.viewer"
        desc_key = "static access key for object storage"
    }
}
# Bucket
bucket = {
    dev-stor-hw-ter = {
        max_size     = 1073741824
        vers_enabled = true
        encrypt = {
            name = "hw-ter"
            description =""
            default_algorithm = "AES_128"
            rotation_period   = "8760h"
            sse_algorithm     = "aws:kms"
        }
        stor_object = {
            vault_demo = {
                key     = "docker/vault/compose_demo/docker-compose.yml"
                content = "s3 bucket"
                source = "/vault/compose_demo/docker-compose.yml"
                tags    = { bucket = "compose.yml" }
            },
            vault_full = {
                key     = "docker/vault/compose_full/docker-compose.yml"
                content = "s3 bucket"
                source = "/vault/compose_full/docker-compose.yml"
                tags    = { bucket = "compose.yml" }
            }     
        }
    }
}

