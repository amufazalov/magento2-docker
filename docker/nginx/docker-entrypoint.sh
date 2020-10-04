#!/bin/bash

[ "$DEBUG" = "true" ] && set -x

VHOST_FILE="/etc/nginx/conf.d/default.conf"

[ ! -z "${SERVER_NAME}" ] && sed -i "s#!SERVER_NAME!#${SERVER_NAME}#" $VHOST_FILE
[ ! -z "${MAGENTO_ROOT}" ] && sed -i "s#!MAGENTO_ROOT!#${MAGENTO_ROOT}#" $VHOST_FILE
[ ! -z "${MAGENTO_RUN_MODE}" ] && sed -i "s/!MAGENTO_RUN_MODE!/${MAGENTO_RUN_MODE}/" $VHOST_FILE
[ ! -z "${UPLOAD_MAX_FILESIZE}" ] && sed -i "s/!UPLOAD_MAX_FILESIZE!/${UPLOAD_MAX_FILESIZE}/" $VHOST_FILE

[ ! -z "${SERVER_SSL}" ] && sed -i "s#!SERVER_SSL!#${SERVER_SSL}#" $VHOST_FILE
[ ! -z "${VIRTUAL_PORT}" ] && sed -i "s#!VIRTUAL_PORT!#${VIRTUAL_PORT}#" $VHOST_FILE

SERVER_LISTEN="80";
if [ ! -z "${SERVER_SSL}" ] && [ "${SERVER_SSL}" == "on" ]
then
    if [ ! -z "${VIRTUAL_PORT}" ]
    then
        SERVER_LISTEN="${VIRTUAL_PORT} ssl";
    fi
fi
sed -i "s#!SERVER_LISTEN!#${SERVER_LISTEN}#" $VHOST_FILE

# Check if the nginx syntax is fine, then launch.
nginx -t

exec "$@"
