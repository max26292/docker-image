FROM php:7.3-fpm

ENV APP_HOME /var/www/html
ENV USERNAME=www-data
ARG UID=1000
ARG GID=1000
ENV ENV=dev

RUN apt-get update && apt-get upgrade -y && apt-get install -y \
      procps \
      nano \
      git \
      unzip \
      libicu-dev \
      libpng-dev \
      zlib1g-dev \
      libxml2 \
      libxml2-dev \
      libreadline-dev \
      supervisor \
      cron \
      libzip-dev \
    && docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd \
    && docker-php-ext-configure intl \
    && docker-php-ext-install \
      pdo_mysql \
      sockets \
      intl \
      opcache \
      zip \
    && rm -rf /tmp/* \
    && rm -rf /var/list/apt/* \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean \
&& curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
# Clear cache
&& apt-get clean && rm -rf /var/lib/apt/lists/* \
&& pecl install xdebug \
#install and set extension
&& docker-php-ext-install pdo_mysql zip exif pcntl bcmath gd \ 
&& docker-php-ext-enable xdebug 

COPY ./config/php/xdebug.ini /tmp/
COPY ./config/php/xdebug.sh /tmp/
RUN chmod u+x /tmp/xdebug.sh && /tmp/xdebug.sh && chown ${USERNAME}:${USERNAME} $APP_HOME \
&& mkdir -p $APP_HOME/public && \
    mkdir -p /home/$USERNAME && chown $USERNAME:$USERNAME /home/$USERNAME \
    && usermod -u $UID $USERNAME -d /home/$USERNAME \
    && groupmod -g $GID $USERNAME \
    && chown -R ${USERNAME}:${USERNAME} $APP_HOME

# # install composer
# COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
# RUN chmod +x /usr/bin/composer
# ENV COMPOSER_ALLOW_SUPERUSER 1
COPY ./config/php/www.conf /usr/local/etc/php-fpm.d/www.conf
COPY ./config/php/local.ini /usr/local/etc/php/php.ini

WORKDIR $APP_HOME
USER ${USERNAME}

EXPOSE 9000
CMD ["php-fpm"]