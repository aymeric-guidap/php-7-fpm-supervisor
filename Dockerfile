FROM php:7.2-fpm
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
        libzip4 \
        pngquant \
        jpegoptim \
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

# Installing wkhtmltopdf
RUN apt-get install -y --no-install-recommends libfontenc1 libxfont1 xfonts-75dpi xfonts-base xfonts-encodings xfonts-utils \
    && curl -sL https://downloads.wkhtmltopdf.org/0.12/0.12.5/wkhtmltox_0.12.5-1.stretch_amd64.deb --output /tmp/wkhtmltox.deb --silent \
    && dpkg -i /tmp/wkhtmltox.deb \
    && rm /tmp/wkhtmltox.deb

# Changing local time and fixing permissions
RUN unlink /etc/localtime \
    && ln -s /usr/share/zoneinfo/Europe/Paris /etc/localtime \
    && dpkg-reconfigure --frontend noninteractive tzdata \
    && chmod -R g+rwx /var/www/html \
    && umask 0007