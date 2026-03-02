AWS Secure Infrastructure with Terraform
Este proyecto despliega una arquitectura en la nube siguiendo estándares de seguridad y mejores prácticas de Infrastructure as Code (IaC).

🚀 Características Técnicas
VPC Segura: Diseño de red con subredes públicas y privadas para aislamiento de recursos.

Almacenamiento Cifrado: S3 Bucket configurado con cifrado AES-256 y bloqueo total de acceso público.

Gestión de Identidad (IAM): Implementación de roles con políticas de Mínimo Privilegio para instancias EC2.

Automatización: Uso de proveedores dinámicos (Random ID) para garantizar la unicidad de recursos globales.

🛠️ Herramientas Utilizadas
Terraform: Orquestación y despliegue de infraestructura.

AWS: Proveedor de servicios cloud (EC2, S3, IAM, VPC).

📁 Estructura del Proyecto
s3.tf: Configuración de almacenamiento seguro.

iam.tf: Definición de roles y perfiles de seguridad.

compute.tf: Despliegue de la instancia EC2 en subred privada.
