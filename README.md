# MAGENTO 2 Docker

## Magento 2.4.3 + Nginx + PHP 7.4 + MariaDB 10.4.13 + Elasticsearch 7.6.0 + XDebug

### Перед тем как начать

Обратите внимание, что для **Elasticsearch** вам понадобится как минимум **262144** памяти.

Сделать проверку: `more /proc/sys/vm/max_map_count`

Параметр `vm.max_map_count` должен быть постоянно установлен в /etc/sysctl.conf  - `vm.max_map_count=262144`

Откройте данный файл и введите данное значение, если необходимо, и выполните команду `sudo sysctl -p`

### Локальная разработка
1. Склонировать репозиторий `git clone https://github.com/amufazalov/magento2-docker.git`
2. Создать папку `src` командой `mkdir src`
3. Склонировать ваш проект в `./src`
4. Переименовать `cp .env.example .env`. Установить нужные переменные окружения
5. Выполнить команду `bin/start`
6. Расположить БД вашего проекта в папке `./backup` под именем `dump.sql`
7. Выполнить команду `bin/db-restore`
8. Выполнить команду `bin/composer install`
9. Выполнить команды `bin/magento setup:upgrade`, `bin/magento setup:di:compile` и `bin/magento setup:static-content:deploy -f`

### Чистая установка
1. Склонировать репозиторий `git clone https://github.com/amufazalov/magento2-docker.git`
2. Создать папку `src` командой `mkdir src`
3. Переименовать `cp .env.example .env`. Установить нужные переменные окружения
4. Выполнить команду `bin/install`
5. Выполнить команду `bin/setup`

#### Кастомный .gitignore для Magento 2
При желании можно заменить дефлотный _.gitignore_, который идет вместе с **Magento 2**.
В репозитории будут храниться `composer.json`, `composer.lock`, папка `app/code` c вашими модулями и `app/design` с вашей темой.
`cp .gitignore2.m2.custom src/.gitignore`

#### Переменные окружения:
Environment variable  | Description                   | Default
--------------------  | -----------                   | -------
MYSQL_HOSTNAME        | MySQL hostname                | db
MYSQL_USER            | MySQL username                | root
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
VIRTUAL_PORT        | Port of the server (80/443) | 443
SERVER_SSL        | On / Off the SSL | on

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
* `bin/npm` - Работа с npm менеджером (`bin/npm install` или `bin/npm <command>`)
* `bin/gulp-init` - Инициализация gulp (будет использован `helper/package.json`)
* `bin/gulp` - Работа с gulp (`bin/gulp --tasks` - список команд,  `bin/gulp` - кастомные подсказки)
* `bin/start` - запуск контейнеров
* `bin/stop` - остановка контейнеров
* `bin/down` - уничтожение контейнеров
* `bin/clean-frontend` - очистка фронтенда
* `bin/db-backup` - создание дампа текущей БД проекта `dump.sql` в папке `backup`
* `bin/db-recreate` - создание чистой БД
* `bin/db-restore` - импортирует БД `dump.sql` из папки `backup`. И заменяет базовый url на MAGENTO_BASE_URL
* `bin/composer` - работа с композером 
* `bin/change-composer` - переключение версии композера (1 или 2) (`bin/change-composer 1`)
* `bin/dev-urn-catalog-generate` - генерация `misc.xml` для IDE PHPStorm
* `bin/x-debug` - вкл / выкл XDebug. Меняет значение переменной PHP_ENABLE_XDEBUG на противоположное и перезапускает контейнеры.

#### Особенности
В случае установки **Magento 2** ниже версии 2.4, нужно из _bin/setup_ скрипта удалить строки

  --search-engine=elasticsearch7 \
  --elasticsearch-host=elasticsearch \
  --elasticsearch-port=9200 \
  --elasticsearch-enable-auth=0 \
  --elasticsearch-timeout=15 \
  --elasticsearch-index-prefix=magento

#### Полезные команды
##### Изменение базовых url
* `bin/magento setup:store-config:set --base-url="http://localhost:8080/"`
* `bin/magento setup:store-config:set --base-url-secure="https://localhost:8080/"`
##### Создание администратора
* `bin/magento admin:user:create --admin-user="newadmin" --admin-password="a123456789" --admin-email="newadmin@example.com" --admin-firstname="firstname" --admin-lastname="lastname"`
##### Установка Simple Data
* `bin/magento sampledata:deploy`
