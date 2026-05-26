

       _               _
   ___| |__   ___  ___| | _______   __
  / __| '_ \ / _ \/ __| |/ / _ \ \ / /
 | (__| | | |  __/ (__|   < (_) \ V /
  \___|_| |_|\___|\___|_|\_\___/ \_/

By Prisma Cloud | version: 3.2.527 
Update available 3.2.527 -> 3.2.529
Run pip3 install -U checkov to update 


terraform scan results:

Passed checks: 16, Failed checks: 0, Skipped checks: 2

Check: CKV_YC_23: "Ensure folder member does not have elevated access."
	PASSED for resource: yandex_resourcemanager_folder_iam_member.registry-sa-role-images-puller
	File: /container_registry/main.tf:17-21
Check: CKV_YC_24: "Ensure passport account is not used for assignment. Use service accounts and federated accounts where possible."
	PASSED for resource: yandex_resourcemanager_folder_iam_member.registry-sa-role-images-puller
	File: /container_registry/main.tf:17-21
Check: CKV_YC_1: "Ensure security group is assigned to database cluster."
	PASSED for resource: module.mdb_mysql_cluster.yandex_mdb_mysql_cluster.clust-mysql-hw-04
	File: /mysql_module/main.tf:13-43
	Calling File: /app/main.tf:31-70
Check: CKV_YC_12: "Ensure public IP is not assigned to database cluster."
	PASSED for resource: module.mdb_mysql_cluster.yandex_mdb_mysql_cluster.clust-mysql-hw-04
	File: /mysql_module/main.tf:13-43
	Calling File: /app/main.tf:31-70
Check: CKV_YC_23: "Ensure folder member does not have elevated access."
	PASSED for resource: yandex_resourcemanager_folder_iam_member.sa-admin["admin"]
	File: /s3/main.tf:10-16
Check: CKV_YC_24: "Ensure passport account is not used for assignment. Use service accounts and federated accounts where possible."
	PASSED for resource: yandex_resourcemanager_folder_iam_member.sa-admin["admin"]
	File: /s3/main.tf:10-16
Check: CKV_YC_9: "Ensure KMS symmetric key is rotated."
	PASSED for resource: yandex_kms_symmetric_key.key-a
	File: /s3/main.tf:28-35
Check: CKV_YC_3: "Ensure storage bucket is encrypted."
	PASSED for resource: yandex_storage_bucket.add_bucket["dev-stor-hw-ter"]
	File: /s3/main.tf:51-76
Check: CKV_YC_17: "Ensure storage bucket does not have public access permissions."
	PASSED for resource: yandex_storage_bucket.add_bucket["dev-stor-hw-ter"]
	File: /s3/main.tf:51-76
Check: CKV_YC_23: "Ensure folder member does not have elevated access."
	PASSED for resource: yandex_resourcemanager_folder_iam_member.sa-admin["pull"]
	File: /s3/main.tf:10-16
Check: CKV_YC_24: "Ensure passport account is not used for assignment. Use service accounts and federated accounts where possible."
	PASSED for resource: yandex_resourcemanager_folder_iam_member.sa-admin["pull"]
	File: /s3/main.tf:10-16
Check: CKV_YC_11: "Ensure security group is assigned to network interface."
	PASSED for resource: module.vm_module["app"].yandex_compute_instance.vm[0]
	File: /vm_module/main.tf:5-55
	Calling File: /app/main.tf:2-28
Check: CKV_YC_4: "Ensure compute instance does not have serial console enabled."
	PASSED for resource: module.vm_module["app"].yandex_compute_instance.vm[0]
	File: /vm_module/main.tf:5-55
	Calling File: /app/main.tf:2-28
Check: CKV_YC_11: "Ensure security group is assigned to network interface."
	PASSED for resource: module.vm_module_external["vault"].yandex_compute_instance.vm[0]
	File: /vm_module/main.tf:5-55
	Calling File: /vault/main.tf:2-27
Check: CKV_YC_4: "Ensure compute instance does not have serial console enabled."
	PASSED for resource: module.vm_module_external["vault"].yandex_compute_instance.vm[0]
	File: /vm_module/main.tf:5-55
	Calling File: /vault/main.tf:2-27
Check: CKV_YC_19: "Ensure security group does not contain allow-all rules."
	PASSED for resource: yandex_vpc_security_group.vpc
	File: /vpc/main.tf:53-85
Check: CKV_YC_2: "Ensure compute instance does not have public IP."
	SKIPPED for resource: module.vm_module["app"].yandex_compute_instance.vm[0]
	Suppress comment:  public access required for vault/web
	File: /vm_module/main.tf:5-55
	Calling File: /app/main.tf:2-28
Check: CKV_YC_2: "Ensure compute instance does not have public IP."
	SKIPPED for resource: module.vm_module_external["vault"].yandex_compute_instance.vm[0]
	Suppress comment:  public access required for vault/web
	File: /vm_module/main.tf:5-55
	Calling File: /vault/main.tf:2-27

