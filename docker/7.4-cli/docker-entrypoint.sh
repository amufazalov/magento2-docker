#!/bin/bash

[ "$DEBUG" = "true" ] && set -x

# Ensure our Magento directory exists
mkdir -p $MAGENTO_ROOT

# Start cron if required
if [ "$ENABLE_CRON" == "true" ]; then
    CRON_LOG=/var/log/cron.log

    # Setup Magento cron
    echo "* * * * * docker /usr/local/bin/php ${MAGENTO_ROOT}/bin/magento cron:run | grep -v \"Ran jobs by schedule\" >> ${MAGENTO_ROOT}/var/log/magento.cron.log" | sudo tee /etc/cron.d/magento

    # Get rsyslog running for cron output
    sudo touch $CRON_LOG
    echo "cron.* $CRON_LOG" | sudo tee /etc/rsyslog.d/cron.conf
    sudo service rsyslog start
fi

# Configure Sendmail if required
if [ "$ENABLE_SENDMAIL" == "true" ]; then
    sudo /etc/init.d/sendmail start
fi

# Configure mailhog if required
if [ "$ENABLE_MAILHOG" == "true" ]; then
    echo "sendmail_path = \"/usr/local/bin/mhsendmail --smtp-addr='mailhog:1025'\"" | sudo tee /usr/local/etc/php/conf.d/zz-mail.ini
fi

# Configure xdebug if required
[ "$PHP_ENABLE_XDEBUG" = "true" ] && \
    sudo docker-php-ext-enable xdebug && \
    echo "Xdebug is enabled"

# Configure composer
[ ! -z "${COMPOSER_GITHUB_TOKEN}" ] && \
    composer config --global github-oauth.github.com $COMPOSER_GITHUB_TOKEN

[ ! -z "${COMPOSER_MAGENTO_USERNAME}" ] && \
    composer config --global http-basic.repo.magento.com \
        $COMPOSER_MAGENTO_USERNAME $COMPOSER_MAGENTO_PASSWORD

# UID/GID map to unknown user/group, $HOME=/ (the default when no home directory is defined)
eval $( fixuid )
# UID/GID now match user/group, $HOME has been set to user's home directory

exec "$@"
