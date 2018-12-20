FROM php:7.0-fpm
LABEL authors="Sylvain Marty <sylvain@guidap.co>"

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        libmagickwand-dev \
        libmagickcore-dev \
        libcurl4-gnutls-dev \
        zlib1g-dev \
        libicu-dev \
        supervisor \
        curl \
        rsync \
        make \
        libzip2 \
        && pecl install imagick \
        && docker-php-ext-enable imagick

RUN pecl install \
        imagick \
        xdebug \
        unzip \
    && docker-php-ext-install \
        pdo_mysql \
        intl \
        bcmath \
        mbstring \
        zip \
        sockets \
        gd \
    && docker-php-ext-enable \
        opcache \
        imagick \
        gd

COPY php.ini /usr/local/etc/php/
COPY 00-supervisor.conf /etc/supervisor/conf.d/

# Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && rm -rf /tmp/* /var/tmp/*

# forward request and error logs to docker log collector
RUN echo Europe/Paris > /etc/timezone \
    && dpkg-reconfigure --frontend noninteractive tzdata \
    && chmod -R g+rwx /var/www/html \
    && umask 0007