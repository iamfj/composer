ARG PHP_VERSION
ARG COMPOSER_VERSION

#########################################################
# Composer                                              #
#########################################################
FROM composer:${COMPOSER_VERSION} AS composer

#########################################################
# Composer with Extensions                              #
#########################################################
FROM php:${PHP_VERSION}-cli-alpine AS composer-with-extensions
COPY --from=composer /usr/bin/composer /usr/bin/composer

RUN apk add --no-cache --virtual .build-deps \
      $PHPIZE_DEPS \
      build-base \
      gcc \
      g++ \
      autoconf \
      tar \
    && apk add --no-cache \
      libpng-dev \
      gettext-dev \
      icu-dev \
      oniguruma-dev \
      libpq-dev \
      sqlite-dev \
      libxml2-dev \
      libsodium-dev \
      libzip-dev \
    && pecl install \
      xdebug \
      mongodb \
    && docker-php-ext-enable \
      xdebug \
      mongodb \
    && docker-php-ext-install -j$(nproc) \
      bcmath \
      bz2 \
      exif \
      gd \
      gettext \
      intl \
      mbstring \
      mysqli \
      opcache \
      pdo \
      pdo_mysql \
      pdo_pgsql \
      pdo_sqlite \
      simplexml \
      sodium \
      xml \
      zip \
    && apk del --no-cache .build-deps

ENTRYPOINT [ "php", "/usr/bin/composer" ]
