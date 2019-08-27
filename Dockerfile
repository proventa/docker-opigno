FROM php:7.3-apache

COPY --from=composer /usr/bin/composer /usr/bin/composer
RUN apt-get update
RUN apt-get install -y unzip git
RUN apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libzip-dev \
    && docker-php-ext-install -j$(nproc) zip \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd
RUN composer create-project opigno/opigno-composer /opt/opigno
RUN cd /opt/opigno/web && composer require drush/drush
RUN ln -s /opt/opigno/vendor/bin/drush /usr/local/bin
RUN chown -R www-data:www-data /opt/opigno
RUN cd /var/www && rm -r html && ln -s /opt/opigno/web html
