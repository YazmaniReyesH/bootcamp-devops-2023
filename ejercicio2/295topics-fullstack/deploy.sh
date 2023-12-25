#!/bin/bash

LGREEN='\033[1;32m'
NC='\033[0m'

# Definimos las variables para la conexión a la cuenta de Docker Hub
DOCKER_USERNAME="Coloca aqui tu usuario de Docker Hub"
DOCKER_PASSWORD="Coloca aqui tu password de Docker Hub"
# Definimos los nombres de las imagenes que se van a subir a Docker Hub
DOCKER_IMAGE_NAME_FRONTEND="295topics-fullstack-frontend"
DOCKER_IMAGE_NAME_BACKEND="295topics-fullstack-backend"
# Definimos las variables para la conexión al repositorio y directorio del proyecto en Github
REPO="bootcamp-devops-2023"

# Función para instalar y configurar Git
install_git() {
    echo -e "${BLUE}Instalando y Configurando Git...${NC}"
	apt install -y git
	git config --list
    git config --global user.name "YazmaniReyesH"
    git config --global user.email "yazmani.reyesh@gmail.com"
	git config --global --add safe.directory '*'
}

# Validamos si el repositorio ya existe y si no lo clonamos
echo -e "\n${LGREEN}Validando y clonando el repositorio...${NC}"
if [ -d "bootcamp-devops-2023" ]; then
    echo -e "\n${LGREEN}El repositorio 'bootcamp-devops-2023' ya existe. Eliminándolo...${NC}"
    rm -rf bootcamp-devops-2023
fi

# Clonar el repositorio desde GitHub
echo -e "\n${LGREEN}El repositorio 'bootcamp-devops-2023' no se encuentra en el sistema. Clonando el repositorio...${NC}"
git clone https://github.com/yazmanireyesh/$REPO.git

# Iniciamos sesión en la cuenta de Docker Hub del usuario
echo -e "\n${LGREEN}Iniciando sesión en la cuenta de Docker Hub del usuario...${NC}" 
echo -n "${DOCKER_PASSWORD}" | docker login --username "${DOCKER_USERNAME}" --password-stdin

# Construimos las imagenes de Docker
echo -e "\n${LGREEN}Desplazandose al directorio del proyecto ...${NC}"
cd bootcamp-devops-2023
chmod -R +x ./ejercicio2
cd ejercicio2
cd 295topics-fullstack

echo -e "\n${LGREEN}Construyendo y etiquetando las imagenes de Docker ...${NC}"
docker build -t ${DOCKER_USERNAME}/${DOCKER_IMAGE_NAME_FRONTEND}:v1.0 ./frontend
docker build -t ${DOCKER_USERNAME}/${DOCKER_IMAGE_NAME_BACKEND}:v1.0 ./backend
echo -e "\n${LGREEN}Imagenes construidas correctamente...${NC}"

# Subimos las imagenes a la cuenta de Docker Hub del usuario
echo -e "\n${LGREEN}Subiendo las imagenes a la cuenta de Docker Hub del usuario ...${NC}"
docker push ${DOCKER_USERNAME}/${DOCKER_IMAGE_NAME_FRONTEND}:v1.0
docker push ${DOCKER_USERNAME}/${DOCKER_IMAGE_NAME_BACKEND}:v1.0
echo -e "\n${LGREEN}Imagenes subidas a Docker Hub ...${NC}"

# Detenemos y eliminamos los contenedores e imagenes existentes en el sistema...${NC}"
echo -e "\n${LGREEN}Deteniendo y eliminando los contenedores e imagenes existentes en el sistema...${NC}"
docker rmi $(docker images -q) --force
docker rm $(docker ps -aq) --force

# Iniciamos los contenedores con la versión correspondiente
echo -e "\n${LGREEN}Iniciando los contenedores con la version correspondiente ...${NC}"
docker-compose up