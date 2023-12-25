# Establecemos la imagen base para el contenedor
# Utiliza la imagen base de Go 1.18 con Alpine Linux. Esta es una imagen eficiente y liviana para construir aplicaciones Go.
FROM golang:1.18-alpine AS builder
# Cambiamos el directorio de trabajo dentro del contenedor a /app
WORKDIR /app
# Establecemos metadatos en la imagen. En este caso, se establece una descripción y el autor de la imagen
LABEL org.opencontainers.image.description="Web-295words-docker"\
      org.opencontainers.image.authors="Yazmani_Reyes_Hernandez"
# Copiamos el archivo dispatcher.go desde el directorio de construcción local al directorio /app dentro del contenedor
COPY dispatcher.go /app
# Copiamos todos los archivos restantes del directorio de construcción local al directorio /app dentro del contenedor
# Esto incluirá los archivos fuente y cualquier otro archivo necesario para la aplicación
COPY . /app
# Indicamos que se ejecute el comando go build para compilar el código fuente de Go en el archivo ejecutable main. 
# El archivo fuente principal es dispatcher.go.
RUN go build -o main dispatcher.go
# Exponemos el puerto
EXPOSE 80
# Definimos el comando predeterminado que se ejecutará cuando el contenedor se inicie. 
# En este caso, ejecutará el comando ./main, esto quiere decir que se está ejecutando el archivo ejecutable main que fue construido anteriormente
CMD ["./main"]