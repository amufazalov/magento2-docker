FROM php:7.0-cli

# Install dependencies
RUN apt-get update \
  && apt-get install -y \
    libfreetype6-dev \
    libicu-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng-dev \
    libxslt1-dev \
    sendmail-bin \
    sendmail \
    sudo \
    cron \
    rsyslog \
    mysql-client \
    git \
    redis-tools \
    zip \
  && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
  && docker-php-ext-install \
    dom \
    gd \
    intl \
    mbstring \
    mcrypt \
    pcntl \
    pdo_mysql \
    xsl \
    zip \
    bcmath \
    soap \
    sockets \
  && pecl install -o -f xdebug \
  && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Get composer installed to /usr/local/bin/composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Create privilege user
RUN addgroup --gid 1000 docker && \
    adduser --uid 1000 --ingroup docker --home /var/www/magento --shell /bin/bash --disabled-password --gecos "" docker

RUN printf "docker ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/90-docker

# See https://github.com/boxboat/fixuid
RUN USER=docker && \
    GROUP=docker && \
    curl -SsL https://github.com/boxboat/fixuid/releases/download/v0.4/fixuid-0.4-linux-amd64.tar.gz | tar -C /usr/local/bin -xzf - && \
    chown root:root /usr/local/bin/fixuid && \
    chmod 4755 /usr/local/bin/fixuid && \
    mkdir -p /etc/fixuid && \
    printf "user: $USER\ngroup: $GROUP\npaths:\n - /var/www/magento\n" > /etc/fixuid/config.yml

# Install Mhsendmail

RUN curl --location --output /usr/local/bin/mhsendmail https://github.com/mailhog/mhsendmail/releases/download/v0.2.0/mhsendmail_linux_amd64 \
  && chmod +x /usr/local/bin/mhsendmail

ENV MAGENTO_ROOT /var/www/magento/src

ADD etc/php-xdebug.ini /usr/local/etc/php/conf.d/zz-xdebug-settings.ini
ADD etc/mail.ini /usr/local/etc/php/conf.d/zz-mail.ini
ADD etc/php-cli.ini /usr/local/etc/php/conf.d/zz-magento.ini
ADD docker-entrypoint.sh /docker-entrypoint.sh
ADD bin/* /usr/local/bin/

RUN ["chmod", "+x", "/docker-entrypoint.sh"]
RUN ["chmod", "+x", "/usr/local/bin/run-cron"]

ENTRYPOINT ["/docker-entrypoint.sh"]

VOLUME /var/www/magento
WORKDIR /var/www/magento

USER docker:docker

CMD ["bash"]
