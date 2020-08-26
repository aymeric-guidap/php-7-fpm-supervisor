FROM php:7.2-fpm-alpine
LABEL authors="Sylvain Marty <sylvain@guidap.co>"

ARG TIMEZONE=Europe/Paris


RUN apk add --no-cache \
        $PHPIZE_DEPS \
        tzdata \
        imagemagick-dev \
        libcurl \
        zlib-dev \
        icu-dev \
        supervisor \
        curl \
        make \
        libzip \
        libpng-dev \
        pngquant \
        jpegoptim \
        wkhtmltopdf \
        && cp /usr/share/zoneinfo/$TIMEZONE /etc/localtime \
        && echo "$TIMEZONE" > /etc/timezone \
        && apk del tzdata

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

# Installing wkhtmltopdf
# RUN apk add --no-cache libfontenc1 libxfont1 xfonts-75dpi xfonts-base xfonts-encodings xfonts-utils \
#     && curl -sL https://downloads.wkhtmltopdf.org/0.12/0.12.5/wkhtmltox_0.12.5-1.stretch_amd64.deb --output /tmp/wkhtmltox.deb --silent \
#     && dpkg -i /tmp/wkhtmltox.deb \
#     && rm /tmp/wkhtmltox.deb

# Fixes permissions
RUN chmod -R g+rwx /var/www/html \
    && umask 0007