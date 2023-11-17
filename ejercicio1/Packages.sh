#!/bin/bash

# Colores para mensajes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # Sin color

# Función para verificar e instalar paquetes
check_and_install() {
    package_name=$1
    echo -e "${BLUE}Verificando si $package_name está instalado...${NC}"
    if ! dpkg -l | grep -q "$package_name"; then
        echo -e "${BLUE}Instalando $package_name...${NC}"
        sudo apt install -y "$package_name"
    else
        echo -e "${BLUE}$package_name ya está instalado.${NC}"
    fi
}

# Función para configurar Git
configure_git() {
    echo -e "${BLUE}Configurando Git...${NC}"
	git config --list
    git config --global user.name "YazmaniReyesH"
    git config --global user.email "yazmani.reyesh@gmail.com"
	git config --global --add safe.directory '*'
}

# Función para configurar Apache
configure_apache() {
    echo -e "${BLUE}Configurando Apache...${NC}"
	echo -e "${BLUE}Respaldando el index.html de Apache...${NC}"
    sudo mv /var/www/html/index.html /var/www/html/index.html.bkp
    cat << EOF > /etc/apache2/mods-enabled/dir.conf
	<IfModule mod_dir.c>
        DirectoryIndex index.php index.html index.cgi index.pl index.xhtml index.htm
	</IfModule>
EOF
    sudo systemctl reload apache2
    echo -e "${BLUE}Comprobando el estado de Apache...${NC}"
    sudo systemctl status apache2
}

# Función para configurar MariaDB
configure_mariadb() {
    echo -e "${BLUE}Configurando MariaDB...${NC}"
    # Verificar el estado de MariaDB y comenzar el servicio si no está en ejecución
    if sudo systemctl is-active --quiet mariadb; then
        echo -e "${BLUE}MariaDB ya está en ejecución.${NC}"
    else
        echo -e "${BLUE}Iniciando el servicio de MariaDB...${NC}"
        sudo systemctl start mariadb.service
		sudo systemctl enable mariadb
    fi

    # Comprobar el estado del servicio de MariaDB
    echo -e "${BLUE}Comprobando el estado del servicio de MariaDB...${NC}"
    sudo systemctl status mariadb
    
    # Crear la base de datos en MariaDB
    echo -e "${BLUE}Creando la base de datos en MariaDB...${NC}"
    sudo mysql -e "
    CREATE DATABASE IF NOT EXISTS devopstravel;
    CREATE USER IF NOT EXISTS 'codeuser'@'localhost' IDENTIFIED BY 'codepass';
    GRANT ALL PRIVILEGES ON *.* TO 'codeuser'@'localhost';
    FLUSH PRIVILEGES;
    SHOW DATABASES;
    "
}

# 1. Comprobar y actualizar el servidor
echo -e "${BLUE}Comprobando y actualizando el servidor...${NC}"
sudo apt update && sudo apt upgrade -y

# 2. Verificar e instalar Git
check_and_install "git"
configure_git

# 3. Verificar e instalar Apache
check_and_install "apache2"
configure_apache

# 4. Verificar e instalar MariaDB
check_and_install "mariadb-server"
configure_mariadb

# 5. Verificar e instalar PHP
check_and_install "php"

# Mensaje de finalización
echo -e "${GREEN}Instalación completada.${NC}"