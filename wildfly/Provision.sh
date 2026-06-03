#!/bin/bash

## Configurar o módulo JDBC
/profile=full/subsystem=datasources/jdbc-driver=SQLServer:add(driver-module-name=com.microsoft.sqlserver)

## Configurar o módulo database
data-source --profile=full add --name=MyDS --jndi-name=java:/jdbc/MyDS --driver-name=SQLServer --connection-url=jdbc:sqlserver://localhost:1433;databaseName=master;encrypt=true;trustServerCertificate=true --user-name=sa --password=SenhaForte@123 --use-ccm=false --max-pool-size=10 --enabled=true

## Configurar o módulo connection pool


## Configurar o módulo teste de conectividade
