# MAGENTO 2 Docker

## Magento 2.4.0 + Nginx + PHP 7.3 + Mysql 5.7 + Elasticsearch 7.6.0 + XDebug

### Перед тем как начать

Обратите внимание, что для **Elasticsearch** вам понадобится как минимум **262144** памяти.

Сделать проверку: `more /proc/sys/vm/max_map_count`

Параметр `vm.max_map_count` должен быть постоянно установлен в /etc/sysctl.conf  - `vm.max_map_count=262144`

Откройте данный файл и введите данное значение, если необходимо, а затем выолните команду `sudo sysctl -p`

### Локальная разработка
1. Склонировать ваш проект в `./src`
2. Переименовать `cp .env.example .env`. Установить нужные переменные окружения
3. Запустить `bin/start`
4. Запустить `bin/composer install`
5. Запустить `bin/setup`

Если нужна чистая установка, то `rm -rf src/* ` и запустить `bin/install`.
После этого `bin/setup`

Source проекта будет располагаться в папке src.

#### Кастомный .gitignore для Magento 2
При желании можно заменить дефлотный _.gitignore_, который идет вместе с **Magento 2**.
В репозитории будут храниться `composer.json`, `composer.lock`, папка `app/code` c вашими модулями и `app/design` с вашей темой.
`cp .gitignore2.m2.custom src/.gitignore`

#### Переменные окружения:
Environment variable  | Description                   | Default
--------------------  | -----------                   | -------
MYSQL_HOSTNAME        | MySQL hostname                | db
MYSQL_USERNAME        | MySQL username                | root
MYSQL_ROOT_PASSWORD   | MySQL password                | root
MYSQL_DATABASE        | MySQL database                | magento
CRYPTO_KEY            | Magento Encryption key        | secured
MAGENTO_BASE_URL      | Uri (e.g. http://localhost)   | https://project.test/
MAGENTO_RUN_MODE      | Deploy mode                   | developer
MAGENTO_ADMIN_USER    | Administrator username        | admin
MAGENTO_ADMIN_PASSWORD| Administrator password        | a123456
MAGENTO_ADMIN_FIRSTNAME| Administrator first name     | admin
MAGENTO_ADMIN_LASTNAME| Administrator last name       | admin
MAGENTO_ADMIN_EMAIL   | Administrator email address   | admin@example.com
MAGENTO_BACKEND_FRONTNAME | The URI of the admin panel | manager
MAGENTO_CURRENCY      | Magento's default currency    | USD
MAGENTO_LANGUAGE      | Magento's default language    | en_US
MAGENTO_TIMEZONE      | Magento's timezone            | Europe/Moscow
COMPOSER_GITHUB_TOKEN | GitHub oauth token            | None
COMPOSER_MAGENTO_USERNAME | Public marketplace key    | None
COMPOSER_MAGENTO_PASSWORD | Private marketplace key   | None
ENABLE_MAILHOG        | Start MailHog service for local development | true
PHP_ENABLE_XDEBUG        | Enable / Disable the XDebug | false

По умолчанию переменные окружения COMPOSER_GITHUB_TOKEN, COMPOSER_MAGENTO_USERNAME, COMPOSER_MAGENTO_PASSWORD 
не используются при локальной разработке, поэтому закомментированы

#### Панель:
* Emails: http://localhost:8025
* Elasticsearch: http://localhost:9200

#### Сервер:

Пока не заморачивался с генерацией сертификата, 
поэтому браузер будет ругаться на невалидный сертификат. 

#### Вспомогательные скрипты:
Необходимы права на исполнение

* `bin/install` - Скачивание **Мagento 2** последней версии с помощью композера. Можно передать параметром версию (`bin/install 2.3`)
* `bin/setup` - Установка **Мagento 2**. 
* `bin/log` - Просмотр логов (`bin/log <container_name>`)
* `bin/npm` - Работа с npm менеджером (`bin/npm install` или `bin/npm --grunt <command>` - работа с Grunt M2)
* `bin/start` - запуск контейнеров
* `bin/stop` - остановка контейнеров
* `bin/down` - уничтожение контейнеров
* `bin/db-backup` - создание дампа текущей БД проекта `dump.sql` в папке `backup`
* `bin/db-recreate` - создание чистой БД
* `bin/db-restore` - импорт БД `dump.sql` из папки `backup`
* `bin/composer` - работа с композером 
* `bin/dev-urn-catalog-generate` - генерация `misc.xml` для IDE PHPStorm

#### Особенности
В случае установки **Magento 2** ниже версии 2.3.5, нужно из _bin/setup_ скрипта удалить строки

  --search-engine=elasticsearch7 \
  --elasticsearch-host=elasticsearch \
  --elasticsearch-port=9200 \
  --elasticsearch-enable-auth=0 \
  --elasticsearch-timeout=15 \
  --elasticsearch-index-prefix=magento
  
Данные версии официально не поддерживают **ElasticSearch 7**.

Также заменить версию контейнеров **php** и **php-fpm** согласно сист. требованиям версии **Magento 2**

#### Полезные команды
##### Изменение базовых url
* `bin/magento setup:store-config:set --base-url="http://localhost:8080/"`
* `bin/magento setup:store-config:set --base-url-secure="https://localhost:8080/"`
##### Создание администратора
* `bin/magento admin:user:create --admin-user="newadmin" --admin-password="a123456789" --admin-email="newadmin@example.com" --admin-firstname="firstname" --admin-lastname="lastname"`

