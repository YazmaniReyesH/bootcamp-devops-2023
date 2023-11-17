#!/bin/bash

# Colores para mensajes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # Sin color

# Función para instalar y configurar Git
install_git() {
    echo -e "${BLUE}Instalando y Configurando Git...${NC}"
	apt install -y git
	git config --list
    git config --global user.name "YazmaniReyesH"
    git config --global user.email "yazmani.reyesh@gmail.com"
	git config --global --add safe.directory '*'
}

# Función para instalar y configurar Apache
install_apache() {
    echo -e "${BLUE}Instalando y Configurando Apache...${NC}"
	apt install apache2 -y
	systemctl start apache2
    systemctl enable apache2
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

# Función para instalar y configurar MariaDB
install_mariadb() {
    echo -e "${BLUE}Instalando y Configurando MariaDB...${NC}"
	apt install -y mariadb-server
	systemctl start mariadb
    systemctl enable mariadb
    # Verificar el estado de MariaDB y comenzar el servicio si no está en ejecución
    if sudo systemctl is-active --quiet mariadb; then
        echo -e "${BLUE}MariaDB ya está en ejecución.${NC}"
    else
        echo -e "${BLUE}Iniciando el servicio de MariaDB...${NC}"
        sudo systemctl start mariadb
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

# Función para instalar y configurar php
install_php() {
    echo -e "${BLUE}Instalando y Configurando php...${NC}"
    apt install -y php libapache2-mod-php php-mysql php-mbstring php-zip php-gd php-json php-curl 
    php -v
}

# 1. Comprobar y actualizar el servidor
echo -e "${BLUE}Comprobando y actualizando el servidor...${NC}"
sudo apt-get update

# 2. Verificar e instalar Git
if dpkg -s git > /dev/null 2>&1; then
    echo -e "\n${YELLOW}Git ya está instalado en tu sistema.${NC}"
    git --version
else
    install_git
fi

# 3. Verificar e instalar Apache
if dpkg -s apache2 > /dev/null 2>&1; then
    echo -e "\n${YELLOW}Apache ya está instalado en tu sistema.${NC}"
else
    install_apache
fi

# 4. Verificar e instalar MariaDB
if dpkg -s mariadb-server > /dev/null 2>&1; then
    echo -e "\n${YELLOW}mariadb-server se encuentra instalado ...${NC}"
else
    install_mariadb
fi

# 5. Verificar e instalar PHP
if dpkg -s php > /dev/null 2>&1; then
    echo -e "\n${YELLOW}php ya está instalado en tu sistema.${NC}"
    php -v
else
    install_php
fi

# Mensaje de finalización
echo -e "${GREEN}Instalación completada.${NC}"