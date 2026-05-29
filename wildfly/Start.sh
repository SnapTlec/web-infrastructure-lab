#!/bin/bash

echo "Iniciando Wildfly"

export JAVA_HOME=/opt/java/jdk17
export PATH=$JAVA_HOME/bin:$PATH

exec /etc/wildfly/bin/domain.sh -b 0.0.0.0 -bmanagement 0.0.0.0
