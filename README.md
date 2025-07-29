# Script de Conexión Segura a GCP
Este script facilita la conexión a máquinas virtuales (VMs) en Google Cloud Platform (GCP) de una manera segura y eficiente. Automatiza la selección de proyectos e instancias y gestiona reglas de firewall temporales para permitir el acceso SSH únicamente desde tu dirección IP actual.

## Prerrequisitos 📝
Antes de poder utilizar este script, asegúrate de tener todo lo siguiente configurado correctamente.

1. Google Cloud CLI (gcloud)
El script depende de la herramienta de línea de comandos de gcloud.

Instalación: Si no la tienes, sigue la guía de instalación oficial de Google Cloud.

Inicialización: Una vez instalada, inicialízala con el siguiente comando y sigue los pasos:

Bash
´´´
gcloud init
´´´

2. Autenticación y Permisos de IAM
Tu cuenta de Google debe estar autenticada y tener los permisos necesarios en GCP.

Autenticación: Inicia sesión con tu cuenta de Google. Esto abrirá una ventana del navegador para que te autentiques.

Bash

gcloud auth login
Permisos necesarios: Tu usuario de IAM necesita, como mínimo, los siguientes roles o permisos en los proyectos a los que deseas acceder:

roles/browser o resourcemanager.projects.list: Para poder listar los proyectos.

roles/compute.viewer: Para listar redes e instancias de Compute Engine.

roles/compute.securityAdmin: Para crear y eliminar reglas de firewall.

roles/compute.osAdminLogin (si usas OS Login) o roles/compute.instanceAdmin.v1 (para gestionar metadatos): Para poder conectarte por SSH.

Un administrador de tu organización de GCP debe asignarte estos roles.

3. peco (Herramienta de filtrado interactivo)
El script utiliza peco para mostrar menús interactivos que te permiten seleccionar proyectos e instancias.

macOS (usando Homebrew):

Bash

brew install peco
Linux (descargando el binario):
Puedes descargar la última versión desde la página de lanzamientos de peco en GitHub y colocar el binario en tu PATH.

4. curl
El script usa curl para obtener tu dirección IP pública. La mayoría de los sistemas operativos Linux y macOS lo incluyen por defecto. Puedes verificar si está instalado con curl --version.

## Instalación del Script 🚀
Crear el archivo: Guarda el contenido del script en un archivo. Por ejemplo, llámalo gcp-connect.sh.

Hacerlo ejecutable: Abre tu terminal y otorga permisos de ejecución al archivo con el siguiente comando:

Bash

chmod +x gcp-connect.sh
## Modo de Uso 🏃‍♂️
Puedes ejecutar el script de dos maneras:

Uso Interactivo (Recomendado)
Simplemente ejecuta el script sin argumentos. Aparecerán menús interactivos para que selecciones el proyecto y la instancia.

Bash

./gcp-connect.sh
Se listarán tus proyectos. Escribe para filtrar y presiona Enter para seleccionar uno.

A continuación, se listarán las redes para crear la regla de firewall. Selecciona la red correcta.

Finalmente, se listarán las instancias de la VM. Filtra y selecciona a la que deseas conectarte.

Uso con Argumentos (Avanzado)
Si ya conoces el ID del proyecto y el nombre de la instancia, puedes pasarlos como argumentos para saltarte los menús.

Bash

./gcp-connect.sh [ID_DEL_PROYECTO] [NOMBRE_DE_LA_RED]
[ID_DEL_PROYECTO]: El ID del proyecto de GCP.

[NOMBRE_DE_LA_RED]: El nombre de la red donde se creará la regla de firewall.

## Funcionamiento Detallado ⚙️
El script sigue estos pasos para garantizar una conexión segura:

Selección de Proyecto: Si no se proporciona un proyecto, lista todos a los que tienes acceso (excluyendo los del sistema sys-) y te permite elegir uno.

Gestión de Firewall:

Elimina reglas antiguas: Intenta borrar cualquier regla de firewall antigua creada por el script para evitar conflictos.

Crea una regla nueva: Crea una regla de firewall de INGRESO que permite el tráfico en puertos comunes (22, 443, 3389, etc.) únicamente desde tu dirección IP pública actual.

Selección de Instancia: Lista las VMs del proyecto seleccionado para que elijas a cuál conectarte.

Conexión SSH: Utiliza gcloud compute ssh para establecer la conexión, gestionando la autenticación automáticamente a través de OS Login o llaves SSH de metadatos.

Limpieza Automática: Una vez
