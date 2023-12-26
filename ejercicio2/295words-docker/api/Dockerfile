# Establecemos la imagen base para el contenedor
# Utiliza la imagen base de Amazon Corretto con Alpine Linux. Amazon Corretto es una distribución de OpenJDK mantenido por Amazon, 
# y Alpine Linux es una distribución de Linux ligera.
FROM amazoncorretto:21-alpine
# Instalamos Instala Maven en la imagen. --no-cache evita que se almacene la caché del índice del paquete en el sistema, reduciendo el tamaño de la imagen.
RUN apk add --no-cache maven
# Actualiza la variable de entorno PATH para incluir el directorio de los binarios de Maven. 
# Esto asegura que los comandos de Maven estén disponibles globalmente.
ENV PATH $PATH:/usr/share/maven/bin
# Cambiamos el directorio de trabajo dentro del contenedor a /app
WORKDIR /app
# Establecemos metadatos en la imagen. En este caso, se establece una descripción y el autor de la imagen
LABEL org.opencontainers.image.description="Api-295words-docker"\
      org.opencontainers.image.authors="Yazmani_Reyes_Hernandez"
# Copiamos el archivo pom.xml desde el directorio de construcción local al directorio /app dentro del contenedor
COPY pom.xml /app
# Copiamos todos los archivos restantes del directorio de construcción local al directorio /app dentro del contenedor
# Esto incluirá los archivos fuente y cualquier otro archivo necesario para la aplicación
COPY . /app
# Ejecutamos el comando Maven para compilar y empaquetar la aplicacion. 
# Esto utilizará el archivo pom.xml y los archivos fuente copiados anteriormente.
RUN mvn clean install
# Exponemos el puerto
EXPOSE 8080
# Definimos el comando predeterminado que se ejecutará cuando el contenedor se inicie. 
# En este caso, se está ejecutando el comando java para ejecutar un archivo JAR (-jar) llamado words.jar que se encuentra en la ruta /api/target/ dentro del contenedor
CMD ["java", "-jar", "/app/target/words.jar"]