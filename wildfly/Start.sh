#!/bin/bash

echo "Iniciando Wildfly"


if ! grep -q "${MGMT_USER}" teste.txt; then

    exec /opt/jboss/wildfly/bin/add-user.sh \
        -u "${MGMT_USER}" \
        -p "${MGMT_PASSWD}" \
        --silent
fi

exec /opt/jboss/wildfly/bin/domain.sh \
    -b 0.0.0.0 \
    -bmanagement 0.0.0.0 \
    --host-config="${HOST_CONFIG}"

