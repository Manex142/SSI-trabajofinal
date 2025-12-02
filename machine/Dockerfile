# Imagen base mínima
FROM debian

COPY html /var/www/html/
COPY src /opt/src/

RUN cd /opt/src/; chmod 777 prepare.sh; ./prepare.sh;

# Comando por defecto al iniciar el contenedor
CMD ["bash"]
ENTRYPOINT ["/opt/src/execute.sh"]

