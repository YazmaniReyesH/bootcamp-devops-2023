# Establecemos la imagen base para el contenedor
FROM node:20.10.0-alpine
# Cambiamos el directorio de trabajo dentro del contenedor a /app
WORKDIR /app
# Establecemos metadatos en la imagen. En este caso, se establece una descripción y el autor de la imagen
LABEL org.opencontainers.image.description="Backend-295topics-fullstack"\
      org.opencontainers.image.authors="Yazmani_Reyes_Hernandez"
# Copiamos el archivo package.json desde el directorio de construcción local al directorio /app dentro del contenedor
COPY package.json /app
# Instalamos las dependencias del proyecto utilizando el gestor de paquetes npm
RUN npm install
# Copiamos todos los archivos restantes del directorio de construcción local al directorio /app dentro del contenedor
# Esto incluirá los archivos fuente y cualquier otro archivo necesario para la aplicación
COPY . /app
# Exponemos el puerto especificado en la variable de entorno PORT
EXPOSE ${PORT}
# Definimos el comando predeterminado que se ejecutará cuando el contenedor se inicie. 
# En este caso, ejecutará el comando npm start, que esta configurado en el script del archivo package.json
CMD ["npm", "start"]