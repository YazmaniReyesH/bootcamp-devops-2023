#!/bin/bash

# Colores para mensajes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # Sin color

# Función para imprimir mensajes
print_message() {
    message=$1
    echo -e "${BLUE}${message}${NC}"
}

# 1. Validar y clonar el repositorio
print_message "Validando y clonando el repositorio..."
if [ -d "bootcamp-devops-2023" ]; then
    print_message "El repositorio 'bootcamp-devops-2023' ya existe. Eliminándolo..."
    rm -rf bootcamp-devops-2023
fi

# Clonar el repositorio desde GitHub
git clone https://github.com/roxsross/bootcamp-devops-2023.git

# 2. Desplazarse al repositorio y cambiar a la rama 'clase2-linux-bash'
cd bootcamp-devops-2023
print_message "Cambiando a la rama 'clase2-linux-bash'..."
git checkout clase2-linux-bash

# 3. Copiar contenido de 'app-295devops-travel' a '/var/www/html'
print_message "Copiando contenido a /var/www/html..."
cp -r app-295devops-travel/* /var/www/html
sudo systemctl reload apache2

# 4. Ejecutar el script SQL
print_message "Ejecutando el script SQL 'devopstravel.sql'..."
sudo mysql < /var/www/html/database/devopstravel.sql
sudo mysql -e "
    USE devopstravel;
    SHOW TABLES;
    "

# 5. Validar el funcionamiento del sitio
print_message "Validando el funcionamiento del sitio http://localhost/info.php..."
print_message "Servicio apache reiniciado..."
sudo systemctl reload apache2
# Realiza una solicitud HTTP GET a la URL
HTTP_STATUS=$(curl -Is "http://localhost/info.php" | head -n 1)
if [[ "$HTTP_STATUS" == *"200 OK"* ]]; then
    print_message "${GREEN}El sitio funciona correctamente.${NC}"
else
    print_message "Error: El sitio no funciona como se esperaba."
fi