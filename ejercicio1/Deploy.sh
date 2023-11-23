#!/bin/bash

# Colores para mensajes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # Sin color

# Función para imprimir mensajes
print_message() {
    message=$1
    color=$2
    echo -e "${color}${message}${NC}"
}

# 1. Verificar el usuario root
if [ "$(id -u)" -ne 0 ]; then
    print_message "Error: Este script debe ejecutarse como root." "$RED"
    exit 1
fi

# 2. Mostrar mensaje inicial
print_message "Ejercicio-1 Linux y Automatización" "$BLUE"

# 3. Etapa 1 - Init: Invocar Packages.sh
print_message "Etapa 1 - Init: Invocando Packages.sh..." "$BLUE"
./Packages.sh

# Verificar el resultado de Packages.sh
if [ $? -ne 0 ]; then
    print_message "Error en la etapa 1. ¡Deteniendo el despliegue!" "$RED"
    exit 1
fi

# 4. Etapa 2 - Build: Invocar Repositorio.sh
print_message "Etapa 2 - Build: Invocando Repositorio.sh y Configuracion.sh..." "$BLUE"
./Repositorio.sh
./Configuracion.sh

# Verificar el resultado de Repositorio.sh
if [ $? -ne 0 ]; then
    print_message "Error en la etapa 2. ¡Deteniendo el despliegue!" "$RED"
    exit 1
fi

# 5. Etapa 3 - Deploy: Invocar Deploy.sh
print_message "Etapa 3 - Deploy: Invocando Deploy.sh..." "$BLUE"
./Deploy.sh

# Verificar el resultado de Deploy.sh
if [ $? -ne 0 ]; then
    print_message "Error en la etapa 3. ¡Deteniendo el despliegue!" "$RED"
    exit 1
fi

# 6. Etapa 4 - Notify: Invocar Notify.sh
print_message "Etapa 4 - Notify: Invocando Notify.sh..." "$BLUE"
./Notify.sh ./../../bootcamp-devops-2023/

# Verificar el resultado de Notify.sh
if [ $? -ne 0 ]; then
    print_message "Error en la etapa 4. ¡Deteniendo el despliegue!" "$RED"
    exit 1
fi

# 7. Mostrar mensaje final
print_message "¡¡¡Aplicación desplegada correctamente!!!" "$GREEN"
