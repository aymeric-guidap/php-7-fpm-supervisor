FROM php:8.2-fpm-bullseye

RUN apt-get update && apt-get install -y --no-install-recommends \
    libmagickwand-dev \
    libmagickcore-dev \
    libcurl4-gnutls-dev \
    zlib1g-dev \
    libicu-dev \
    supervisor \
    git \
    curl \
    ssh \
    rsync \
    make \
    awscli \
    libzip-dev \
    pngquant \
    jpegoptim \
    gnupg \
    dirmngr \
    wget \
    unzip \
    libfontenc1 \
    xfonts-75dpi \
    xfonts-base \
    xfonts-encodings \
    xfonts-utils \
    wkhtmltopdf \
    libonig-dev \
 && pecl install imagick xdebug \
 && docker-php-ext-enable imagick xdebug \
 && docker-php-ext-install \
    pdo_mysql \
    intl \
    bcmath \
    mbstring \
    zip \
    sockets \
    gd \
    opcache

COPY php.ini /usr/local/etc/php/
COPY 00-supervisor.conf /etc/supervisor/conf.d/

# Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --version=2.2.0 \
    && rm -rf /tmp/* /var/tmp/*

# Fixes permissions
RUN chmod -R g+rwx /var/www/html \
    && umask 0007