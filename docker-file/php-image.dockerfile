ARG PHP_VER
FROM php:${PHP_VER}-fpm

ENV APP_HOME /var/www/html
ENV USERNAME=www-data
ARG UID=1000
ARG GID=1000
ENV ENV=dev
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
      jq \
      procps \
      nano \
      git \
      unzip \
      zip \
      libicu-dev \
      libpng-dev \
      libldap2-dev\
       libldb-dev \
      zlib1g-dev \
      libxml2 \
      libxml2-dev \
      libreadline-dev \
      libmemcached-dev libssl-dev \
      rsync \
      cron \
      libzip-dev \
      libfreetype6-dev \
      libjpeg62-turbo-dev \
      libwebp-dev \
    libpng-dev \
    libgmp-dev \
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
#install and set extension
&& docker-php-source extract \
&& pecl install xdebug memcached redis mongodb opentelemetry\
&& docker-php-ext-enable xdebug redis memcached mongodb opentelemetry\
&& docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
&& docker-php-ext-install -j$(nproc) gd\
&& docker-php-ext-install pdo_mysql zip exif pcntl bcmath gmp\ 
&& docker-php-ext-configure ldap \
&& docker-php-ext-install ldap \
&& docker-php-source delete\
&& chown ${USERNAME}:${USERNAME} $APP_HOME \
&& mkdir -p $APP_HOME/public && \
    mkdir -p /home/$USERNAME && chown $USERNAME:$USERNAME /home/$USERNAME \
    && usermod -u $UID $USERNAME -d /home/$USERNAME \
    && groupmod -g $GID $USERNAME \
    && chown -R ${USERNAME}:${USERNAME} $APP_HOME
COPY ./config/php/www.conf /usr/local/etc/php-fpm.d/www.conf
COPY ./config/php/local.ini /usr/local/etc/php/php.ini
COPY ./config/php/xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
ARG DB_DATABASE
ARG DB_PASSWORD
ARG DB_USERNAME
ARG DB_HOST
WORKDIR $APP_HOME
USER ${USERNAME}
EXPOSE 9003 9000
CMD ["php-fpm"]