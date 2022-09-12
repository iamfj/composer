ARG PHP_VERSION
ARG COMPOSER_VERSION

#########################################################
# Composer                                              #
#########################################################
FROM composer:${COMPOSER_VERSION} AS composer

#########################################################
# PHP Extensions                                        #
#########################################################
FROM php:${PHP_VERSION} AS composer-with-extensions
MAINTAINER Fabian Jocks
COPY --from=composer /usr/bin/composer /usr/bin/composer
ENTRYPOINT [ "php", "/usr/bin/composer" ]
