#!/bin/bash

echo "Iniciando Wildfly"
echo "ROLE=${ROLE}"

if [ "ROLE"= "controller" ]; then
    echo "Inicializando a instância controller"

    exec /opt/wildfly/bin/domain.sh \
            -b 0.0.0.0 \ 
            -bmanagement 0.0.0.0 \
            --host-config=host-master.xml

elif [ "ROLE" = "slave" ]; then

    echo "Inicializando a instância slave"

    exec /opt/wildfly/bin/domain.sh \
            -b 0.0.0.0 \ 
            -bmanagement 0.0.0.0 \
            --host-config=host-slave.xml
else
    echo "ROLE inválida"

    exit 1
fi