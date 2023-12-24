#!/bin/bash

LGREEN='\033[1;32m'
NC='\033[0m'

# Definimos las variables para la conexión a la cuenta de Docker Hub
#DOCKER_USERNAME="Coloca aqui tu usuario de Docker Hub"
#DOCKER_PASSWORD="Coloca aqui tu password de Docker Hub"
DOCKER_USERNAME="yazmanireyesh"
DOCKER_PASSWORD="Yazmani1988@"
# Definimos los nombres de las imagenes que se van a subir a Docker Hub
DOCKER_IMAGE_NAME_FRONTEND="295topics-fullstack-frontend"
DOCKER_IMAGE_NAME_BACKEND="295topics-fullstack-backend"
# Definimos las variables para la conexión a las imagenes subidas a Docker Hub
DOCKER_REPO_FRONTEND="docker.io/${DOCKER_USERNAME}/${DOCKER_IMAGE_NAME_FRONTEND}"
DOCKER_REPO_BACKEND="docker.io/${DOCKER_USERNAME}/${DOCKER_IMAGE_NAME_BACKEND}"
# Definimos las variables para la conexión al repositorio y directorio del proyecto en Github
REPO="bootcamp-devops-2023"

# Validamos si el repositorio ya existe y si no lo clonamos
echo -e "\n${LGREEN}Validando y clonando el repositorio...${NC}"
if [ -d "bootcamp-devops-2023" ]; then
    echo -e "\n${LGREEN}El repositorio 'bootcamp-devops-2023' ya existe. Eliminándolo...${NC}"
    rm -rf bootcamp-devops-2023
fi

# Clonar el repositorio desde GitHub
echo -e "\n${LGREEN}El repositorio 'bootcamp-devops-2023' no se encuentra en el sistema. Clonando el repositorio...${NC}"
git clone https://github.com/yazmanireyesh/$REPO.git

# Construimos las imagenes de Docker
echo -e "\n${LGREEN}Construyendo las imagenes de Docker ...${NC}"
# Obtenemos la ultima etiqueta (tag) en el repositorio git y asiganmos ese valor a una variables
# La opcion --tags indica que se deben incluir las etiquetas en la descripcion y --abbrev=0 significa que se utilizará la versión completa de la etiqueta
echo -e "\n${LGREEN}Obteniendo etiqueta y version ...${NC}"
VERSION=$(git describe --tags --abbrev=0)
echo -e "\n${LGREEN}Desplazandose al directorio del proyecto ...${NC}"
cd bootcamp-devops-2023
cd ejercicio2
cd 295topics-fullstack
docker build -t ${DOCKER_IMAGE_NAME_FRONTEND} ./frontend
docker build -t ${DOCKER_IMAGE_NAME_BACKEND} ./backend
echo -e "\n${LGREEN}Imagenes construidas correctamente...${NC}"

# Etiquetamos las imagenes con la versión correspondiente
echo -e "\n${LGREEN}Etiquetando las imagenes con la versión correspondiente ...${NC}"
docker tag ${DOCKER_IMAGE_NAME_FRONTEND} ${DOCKER_REPO_FRONTEND}:${VERSION}
docker tag ${DOCKER_IMAGE_NAME_BACKEND} ${DOCKER_REPO_BACKEND}:${VERSION}
echo -e "\n${LGREEN}Imagenes etiquetadas correctamente ...${NC}"

# Iniciamos sesión en la cuenta de Docker Hub del usuario
echo -e "\n${LGREEN}Iniciando sesión en la cuenta de Docker Hub del usuario...${NC}" 
echo "${DOCKER_PASSWORD}" | docker login --username "${DOCKER_USERNAME}" --password-stdin

# Subimos las imagenes a la cuenta de Docker Hub del usuario
echo -e "\n${LGREEN}Subiendo las imagenes a la cuenta de Docker Hub del usuario ...${NC}"
docker push ${DOCKER_REPO_FRONTEND}:${VERSION}
docker push ${DOCKER_REPO_BACKEND}:${VERSION}
echo -e "\n${LGREEN}Imagenes subidas a Docker Hub ...${NC}"

# Detenemos y eliminamos los contenedores existentes en el sistema...${NC}"
docker-compose down
echo -e "\n${LGREEN}Deteniendo y eliminando los contenedores existentes en el sistema...${NC}"
docker-compose down

# Exportar la versión de la imagen como variable de entorno
# Esto establece la variable de entorno IMAGE_VERSION con el valor de la versión obtenida desde Git.
export IMAGE_VERSION=${VERSION}

# Iniciamos contenedores con la nueva versión
# La versión de la imagen Docker a utilizar se establece a través de la variable de entorno IMAGE_VERSION.
echo -e "\n${LGREEN}Iniciando contenedores con la nueva versión ...${NC}"
docker-compose up