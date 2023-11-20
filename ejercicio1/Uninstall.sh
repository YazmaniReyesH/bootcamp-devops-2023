#!/bin/bash
RED='\033[1;31m'
GREEN='\033[1;32m'
NC='\033[0m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'

function delete_files {
    echo -e "\n${GREEN}Limpiando el directorio de archivos estaticos\n${NC}"
    rm -rf /var/www/html/*
}

#function uninstall_git {
#    echo -e "\n${GREEN}Desinstalando git\n${NC}"
#    apt remove git -y
#    apt purge git -y
#}

function uninstall_apache {
    echo -e "\n${GREEN}Desinstalando apache\n${NC}"
    apt remove apache2 -y
    apt purge apache2 -y
}

function uninstall_mariadb {
    echo -e "\n${GREEN}Desinstalando mariadb\n${NC}"
    rm -rf /var/lib/mysql
    apt remove --purge mariadb-* -y
}

function uninstall_php {
    echo -e "\n${GREEN}Desinstalando php\n${NC}"
    apt remove php libapache2-mod-php php-mysql php-mbstring php-zip php-gd php-json php-curl -y
    apt purge php libapache2-mod-php php-mysql php-mbstring php-zip php-gd php-json php-curl -y
}

delete_files
#uninstall_git
uninstall_apache
uninstall_mariadb
uninstall_php
echo -e "\n${YELLOW}Desinstalacion completada!!!\n${NC}"