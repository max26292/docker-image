ARG PHP_VER
FROM php:${PHP_VER}-apache

ENV APP_HOME /var/www/html
ENV USERNAME=www-data
ARG UID=1000
ARG GID=1000
ENV ENV=dev
COPY ./config/php/xdebug.ini /tmp/
COPY ./config/php/xdebug.sh /tmp/
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
      libwebp-dev libfreetype6-dev libjpeg62-turbo-dev libxpm-dev \
      procps \
      nano \
      git \
      unzip \
      libicu-dev \
      libpng-dev \
      libldap2-dev\
      zlib1g-dev \
      libxml2 \
      libxml2-dev \
      libreadline-dev \
      cron \
      libzip-dev \
      libmemcached-dev\
    && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd \
    && docker-php-ext-configure intl \
    && docker-php-ext-install \
      pdo_mysql \
      sockets \
      intl \
      opcache \
      zip \
      mysqli \   
    && rm -rf /var/list/apt/* \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean \
&& curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
# Clear cache
&& apt-get clean && rm -rf /var/lib/apt/lists/* \
&& pecl install xdebug \
&& pecl install memcached-3.1.4 \
#install and set extension
&& docker-php-ext-install pdo_mysql zip exif pcntl bcmath  \ 
&& docker-php-ext-install  -j$(nproc) gd \
&& docker-php-ext-enable xdebug memcached\
&& docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ && \
docker-php-ext-install ldap \
&& chmod u+x /tmp/xdebug.sh && /tmp/xdebug.sh && chown ${USERNAME}:${USERNAME} $APP_HOME \
&& mkdir -p $APP_HOME/public && \
    mkdir -p /home/$USERNAME && chown $USERNAME:$USERNAME /home/$USERNAME \
    && usermod -u $UID $USERNAME -d /home/$USERNAME \
    && groupmod -g $GID $USERNAME \
    && chown -R ${USERNAME}:${USERNAME} $APP_HOME \
    && rm -rf /tmp/* 
RUN a2enmod rewrite && service apache2 restart
COPY ./config/php/www.conf /usr/local/etc/php-fpm.d/www.conf
COPY ./config/php/local.ini /usr/local/etc/php/php.ini
ARG DB_DATABASE
ARG DB_PASSWORD
ARG DB_USERNAME
ARG DB_HOST
WORKDIR $APP_HOME
USER ${USERNAME}

EXPOSE 80
# CMD ["php-fpm"]