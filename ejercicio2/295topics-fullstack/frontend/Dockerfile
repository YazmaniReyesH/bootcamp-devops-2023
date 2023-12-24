# Indicamos que debe utilizar la imagen base oficial de Node.js con la etiqueta 20.10.0-alpine
FROM node:20.10.0-alpine
# Establecemos el directorio de trabajo en /app dentro del contenedor
WORKDIR /app
# Establecemos metadatos en la imagen. En este caso, se establece una descripción y el autor de la imagen
LABEL org.opencontainers.image.description="frontend-295topics-fullstack"\
      org.opencontainers.image.authors="Yazmani_Reyes_Hernandez"
# Copiamos el archivo package.json desde el directorio de construcción local al directorio /app dentro del contenedor
COPY package.json /app
# Ejecutamos el comando npm install para instalar las dependencias del proyecto
RUN npm install
# Copiamos todos los archivos restantes del directorio de construcción local al directorio /app dentro del contenedor
# Esto incluirá los archivos fuente y cualquier otro archivo necesario para la aplicación
COPY . /app
# Documentamos que la aplicación dentro del contenedor escuchará en el puerto 3000
EXPOSE 3000
# Definimos el comando predeterminado que se ejecutará cuando el contenedor se inicie
# En este caso, ejecutará el comando npm start, que esta configurado en el script del archivo package.json y con esto arrancará la aplicación frontend
CMD [ "npm", "start" ]