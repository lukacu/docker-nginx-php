FROM php:7.2-fpm-alpine

# install the PHP extensions we need
RUN set -ex; \
    docker-php-ext-install opcache pdo_mysql mysqli

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=4000'; \
		echo 'opcache.revalidate_freq=60'; \
		echo 'opcache.fast_shutdown=1'; \
		echo 'opcache.enable_cli=1'; \
	} > /usr/local/etc/php/conf.d/opcache-recommended.ini

RUN apk add --no-cache bash nginx runit

COPY start_runit /sbin/
COPY php-fpm.conf /usr/local/etc/
COPY etc /etc/

RUN chmod a+x /sbin/start_runit && mkdir -p /run/nginx

EXPOSE 80

ENTRYPOINT ["/sbin/start_runit"]
