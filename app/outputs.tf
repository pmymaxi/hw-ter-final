output "web" {
  value = <<EOF
  
    Проверка web:
    curl ${local.web[keys(local.web)[0]].external_ip_address[0]}:8090

    Параметры:
    ExIP: ${local.web[keys(local.web)[0]].external_ip_address[0]}
    InIP: ${local.web[keys(local.web)[0]].internal_ip_address[0]}
    HostName: ${local.web[keys(local.web)[0]].all[0].hostname}
    FqdnMysql: ${local.mysql_host} 
        
  EOF
}
output "archive" {
  value = data.archive_file.app
}
