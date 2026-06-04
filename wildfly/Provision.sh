#!/bin/bash
#   Interface
#       |
#       v
#   Socket-Binding
#       |
#       v
#   Profiles
#       |
#       v
#   Server-group
#       |
#       v
#   Server

## Configurar o módulo JDBC
/profile=full/subsystem=datasources/jdbc-driver=SQLServer:add(driver-module-name=com.microsoft.sqlserver)

## Configurar o módulo database
data-source --profile=full add \
            --name=MyDS \
            --jndi-name=java:/jdbc/MyDS \
            --driver-name=SQLServer \
            --connection-url=jdbc:sqlserver://localhost:1433;databaseName=master;encrypt=true;trustServerCertificate=true \
            --enabled=true

## Configurar o módulo connection pool
data-source --profile=full \
            --name=MyDS \
            --idle-timeout-minutes=1 \
            --max-pool-size=10 \
            --min-pool-size=3 \
            --pool-prefill=true \
            --pool-use-strict-min=true \
            --use-ccm=true \
            --background-validation=true \
            --flush-strategy=FailingConnectionOnly \
            --user-name=sa \
            --password=SenhaForte@123 \


## Configurar o módulo teste de conectividade
 /host=primary/server=teste/subsystem=datasources/data-source=MyDS:test-connection-in-pool