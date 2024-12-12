FROM php:8.2-fpm-bullseye

RUN apt-get install -y --no-install-recommends \
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
    gnupg \
    dirmngr \
    wget \
    unzip

RUN apt-get install -y --no-install-recommends \
    pngquant \
    jpegoptim \
    wkhtmltopdf

RUN apt-get install -y --no-install-recommends \
    libfontenc1 \
    xfonts-75dpi \
    xfonts-base \
    xfonts-encodings \
    xfonts-utils

RUN pecl install imagick xdebug && \
    docker-php-ext-enable imagick xdebug

RUN docker-php-ext-install -j$(nproc) \
    pdo_mysql \
    intl \
    bcmath \
    mbstring \
    zip \
    sockets \
    gd \
    opcache

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY php.ini /usr/local/etc/php/
COPY 00-supervisor.conf /etc/supervisor/conf.d/

# Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --version=2.2.0 \
    && rm -rf /tmp/* /var/tmp/*

# Fixes permissions
RUN chmod -R g+rwx /var/www/html \
    && umask 0007