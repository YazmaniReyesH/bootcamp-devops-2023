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

# Ruta al archivo config.php
config_file="/var/www/html/config.php"

# Validar la existencia del archivo config.php
if [ ! -f "$config_file" ]; then
    print_message "Error: El archivo 'config.php' no existe en /var/www/html."
    exit 1
fi

# Reemplazar el espacio vacío con "codepass" en config.php
print_message "Reemplazando password en config.php..."
sudo sed -i 's/""/"codepass"/g' "$config_file"
print_message "Servicio apache reiniciado..."
sudo systemctl reload apache2
sudo cat /var/www/html/config.php

print_message "${GREEN}Configuración completada.${NC}"