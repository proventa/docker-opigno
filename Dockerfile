FROM drupal:apache

COPY --from=composer /usr/bin/composer /usr/bin/composer
RUN apt-get update
RUN apt-get install -y unzip git
RUN composer create-project opigno/opigno-composer /opt/opigno
RUN cd /opt/opigno && composer require drush/drush && composer clearcache
RUN ln -s /opt/opigno/vendor/bin/drush /usr/local/bin
RUN chown -R www-data:www-data /opt/opigno
RUN cd /var/www && rm -r html && ln -s /opt/opigno/web html
RUN { \
		echo 'post_max_size=128M'; \
		echo 'upload_max_filesize=120M'; \
		echo 'memory_limit=256M'; \
	} > /usr/local/etc/php/conf.d/opigno.ini

COPY docker-opigno-entrypoint /usr/local/bin/
ENTRYPOINT ["docker-opigno-entrypoint"]
CMD ["apache2-foreground"]
