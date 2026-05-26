# Читаем secret path из VAULT
data "vault_generic_secret" "pass_db" {
  path = "secret/mysql"
}
data "vault_generic_secret" "user_db" {
  path = "secret/mysql"
}
data "vault_generic_secret" "passuser" {
  path = "secret/my-app"
}
# Создаем локальную переменную metadata vm и hash пароля
locals {
  passdb   = data.vault_generic_secret.pass_db.data["dbpassword"]
  userdb   = data.vault_generic_secret.user_db.data["dbuser"]
  passuser = data.vault_generic_secret.passuser.data["passuser"]
}