FROM php:8.1.4-fpm-buster

# Install Postgre PDO
RUN apt-get update && apt-get install -y libpq-dev \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install pdo pdo_pgsql pgsql


RUN apt-get update --fix-missing \
    && apt-get install -y apt-utils \
    && apt-get install -y libfreetype6-dev \
    && apt-get install -y libjpeg62-turbo-dev \
    && apt-get install -y libcurl4-gnutls-dev \
    && apt-get install -y libxml2-dev \
    && apt-get install -y freetds-dev \
    && apt-get install -y git \
    && apt-get install -y curl \
    && apt-get install -y zip unzip \
    && apt-get install -y freetds-bin \
    && docker-php-ext-configure gd \
    && docker-php-ext-install gd \
    && docker-php-ext-install soap \
    && docker-php-ext-install calendar \
    && docker-php-ext-install intl \
    && docker-php-ext-install bcmath \
    && apt-get install -y libzip-dev \
    && docker-php-ext-install zip

ENV ACCEPT_EULA=Y

RUN apt-get update \
    && apt-get -y --no-install-recommends install  gnupg apt-transport-https \
    && apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

WORKDIR /var/www

RUN  curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

COPY . .
COPY .env.example .env
COPY --from=composer /usr/bin/composer /usr/bin/composer

ENV COMPOSER_ALLOW_SUPERUSER=1


RUN composer install

RUN php artisan key:generate

RUN usermod -u 1000 www-data
#RUN chown -R www-data:www-data /var/www

# RUN php artisan migrate:refresh --seed
EXPOSE 9000
