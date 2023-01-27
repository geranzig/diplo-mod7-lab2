# GRUPO 5
## Taller 2, Módulo 7
###### Integrantes
###### Virginia Pino
###### Paulo Lagos
###### Alvaro Seisdedos
###### Eduardo Leiva
###### Gerardo Cornejo

## En el archivo variables.tf deben dejar las credenciales de azure y el secret de la app registrada en AD


Terraform
```bash
terraform init
terraform plan
terraform apply
```

obtener key ssh
```bash
terraform output -raw tls_private_key > id_rsa
```

obtener ip pública
```bash
terraform output public_ip_address
```

Conectarse a la máquia virtual e instalar java 
```bash
ssh -i id_rsa azureuser@{ip pública}
```

Para instalar jenkins (Mejora: agregar la instalación de java antes que jenkins para n o instalar java manualmente), en la reglas de entrada agregar puerto 8080 para visualizar jenkins desde un browser
```bash
sudo ansible-playbook ansible_jenkins.yml 
```

