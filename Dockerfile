FROM php:7.4-alpine
LABEL maintainer="xaljer@outlook.com"
RUN set -x \
  && apk --update --no-cache add wget bash \
        freetype libpng libjpeg-turbo \
        freetype-dev libpng-dev libjpeg-turbo-dev \
	postgresql-dev \
  && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
  && docker-php-ext-install -j "$(getconf _NPROCESSORS_ONLN)" gd \
        mysqli pdo pdo_mysql \
	pgsql pdo_pgsql \
#  && docker-php-ext-enable pdo_mysql \
  && apk del --no-cache freetype-dev libpng-dev libjpeg-turbo-dev \
  && rm -rf /tmp/*

WORKDIR /var/www/html

COPY entrypoint.sh /usr/local/bin/
RUN chmod a+x /usr/local/bin/entrypoint.sh

EXPOSE 80

ENTRYPOINT ["entrypoint.sh"]
CMD [ "php", "-S", "0.0.0.0:80", "-t", "/var/www/html" ]

