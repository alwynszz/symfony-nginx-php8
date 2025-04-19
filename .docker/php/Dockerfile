# Базовые образы и версии
ARG ALPINE_VERSION=3.19
ARG PHP_VERSION=8.3
FROM php:${PHP_VERSION}-fpm-alpine${ALPINE_VERSION}

# Конфигурация пользователя и окружения
ARG UID=${UID}
ARG GID=${GID}
ENV USER=webmaster PHP_DIR=php83 \
    # Уменьшаем количество слоев через объединение ENV
    COMPOSER_ALLOW_SUPERUSER=1

# Создание пользователя и базовой структуры
RUN apk add --no-cache bash && \
    addgroup -g ${GID} --system ${USER} && \
    adduser -G ${USER} --system -D -s /bin/sh -u ${UID} ${USER} && \
    mkdir -p /var/www/html

# Установка системных зависимостей
RUN apk add --no-cache \
    curl wget nginx zip unzip git supervisor nodejs npm vim \
    # PHP расширения
    ${PHP_DIR} ${PHP_DIR}-cli ${PHP_DIR}-ctype ${PHP_DIR}-curl \
    ${PHP_DIR}-dom ${PHP_DIR}-fileinfo ${PHP_DIR}-fpm ${PHP_DIR}-gd \
    ${PHP_DIR}-intl ${PHP_DIR}-mbstring ${PHP_DIR}-opcache \
    ${PHP_DIR}-openssl ${PHP_DIR}-phar ${PHP_DIR}-session \
    ${PHP_DIR}-tokenizer ${PHP_DIR}-soap ${PHP_DIR}-xml \
    ${PHP_DIR}-xmlreader ${PHP_DIR}-xmlwriter ${PHP_DIR}-simplexml \
    ${PHP_DIR}-zip ${PHP_DIR}-pdo ${PHP_DIR}-pdo_mysql \
    ${PHP_DIR}-mysqlnd ${PHP_DIR}-pecl-xdebug && \
    # Сборка native extensions
    apk add --no-cache --virtual .build-deps \
        libzip-dev freetype-dev icu-dev libjpeg-turbo-dev \
        libpng-dev libxslt-dev openssh-client && \
    docker-php-ext-install pdo pdo_mysql gd && \
    apk del .build-deps

# Критически важные права для работы сервисов
RUN chown -R ${USER}:${USER} /var/www/html /run /var/lib/nginx /var/log/nginx

# Конфигурация рабочего окружения
WORKDIR /var/www/html
COPY --chown=${USER}:${USER} ../ /var/www/html/
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Копирование конфигурационных файлов
COPY ./nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./nginx/conf.d /etc/nginx/conf.d/
COPY ./php/conf.d/fpm-pool.conf /etc/${PHP_DIR}/php-fpm.d/www.conf
COPY ./php/php.ini /etc/${PHP_DIR}/conf.d/custom.ini
COPY ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Финализация образа
USER ${USER}
EXPOSE 80 443
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
