# Informacion sobre el docker compose

Para utilizar la maquina deberemos situarnos en el directorio donde está leyedo este documento.

Scripts de maquinas:
* Para iniciar la maquina de prueba ejecutar start.sh y conectarse al puerto 8080 de localhost.
* Para parar la maquina de prueba ejecutar stop.sh
* Para borrar del sistema la maquina de prueba ejecutar remove.sh

# archivo dockercompose.yml

* En el archivo docker-compose.yml hay una definicion de un sistema compuesto por una maquina. Si el sistema que se está haciendo necesita de mas de una maquina, deberán añadirse maquinas. Todas ellas derivadas de la maquina base llamada machine. 

* Todas las máquinas se incorporarán en la misma red, el sistema predefinido está preparado para compartir el puerto 80 de la máquina en el 8080 de la máquina host. Si se va a realizar un sistema que necesite de mas puertos abiertos deberá incorporar una máquina adicional que haga de pivote y compartir el puerto 22 de esa maquina en lugar del 80.

## Preparación de cada maquina particular (machine)

Existe un directorio machine/src con dos archivos:
* execute.sh: Es el script que se va a ejecutar cuando se ponga en marcha la máquina. Deberá iniciar los servidores y quedarse en un bucle infinito.
* prepare.sh: Es el script que instala todos los programas necesarios en la máquina y prepara el sistema. Ahi estan acciones como apt install o cambios en los archivos de configuracion necesarios para crear la máquina.

## Flags

Por defecto el sistema está puesto para que se comparta la flag del directorio **./flag/** llamada **flag.txt**

## Documentacion

En el directorio **./docs** se pondrán los documentos para entregar, el write up y la documentación adicional necesaria.
