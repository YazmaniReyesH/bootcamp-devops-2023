#!/bin/bash

LGREEN='\033[1;32m'
NC='\033[0m'

# Definimos las variables para la conexión a la cuenta de Docker Hub
#DOCKER_USERNAME="Coloca aqui tu usuario de Docker Hub"
#DOCKER_PASSWORD="Coloca aqui tu password de Docker Hub"
DOCKER_USERNAME="yazmanireyesh"
DOCKER_PASSWORD="Yazmani1988@"
# Definimos los nombres de las imagenes que se van a subir a Docker Hub
DOCKER_IMAGE_NAME_WEB="295words-docker-web"
DOCKER_IMAGE_NAME_API="295words-docker-api"
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
cd 295words-docker

# Declaramos una variable que contendrá el nombre de la última etiqueta en nuestro repositorio de Git.
# Esto obtendrá la descripción de la última etiqueta (tag) disponible en el historial de Git.
# Esto es util para incorporar información de versiónes en los scripts o procesos de construcción.
TAG_VERSION=$(git describe --tags --abbrev=0)

echo -e "\n${LGREEN}Construyendo y etiquetando las imagenes de Docker ...${NC}"
docker build -t ${DOCKER_USERNAME}/${DOCKER_IMAGE_NAME_WEB}:${TAG_VERSION} ./web
docker build -t ${DOCKER_USERNAME}/${DOCKER_IMAGE_NAME_API}:${TAG_VERSION} ./api
echo -e "\n${LGREEN}Imagenes construidas correctamente...${NC}"

# Subimos las imagenes a la cuenta de Docker Hub del usuario
echo -e "\n${LGREEN}Subiendo las imagenes a la cuenta de Docker Hub del usuario ...${NC}"
docker push ${DOCKER_USERNAME}/${DOCKER_IMAGE_NAME_WEB}:${TAG_VERSION}
docker push ${DOCKER_USERNAME}/${DOCKER_IMAGE_NAME_API}:${TAG_VERSION}
echo -e "\n${LGREEN}Imagenes subidas a Docker Hub ...${NC}"

# Detenemos y eliminamos los contenedores e imagenes existentes en el sistema
echo -e "\n${LGREEN}Deteniendo y eliminando los contenedores e imagenes existentes en el sistema...${NC}"
docker rmi $(docker images -q) --force
docker rm $(docker ps -aq) --force

# Creamos una variable de entorno a la cual le asignaremos el valor de la variable TAG_VERSION que contiene la ultima etiqueta del historial de Git.
# Este tipo de construcción de variables de entorno es común en scripts de construcción de Docker o en scripts de automatización de despliegues, 
# donde la versión del software es una información importante y se utiliza para etiquetar imágenes Docker, versionar artefactos, etc
export IMAGE_VERSION=${TAG_VERSION}

# Iniciamos contenedores con la versión correspondiente
echo -e "\n${LGREEN}Iniciando los contenedores con la versión correspondiente...${NC}"
docker-compose up