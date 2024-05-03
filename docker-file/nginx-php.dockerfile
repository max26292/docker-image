ARG PHP_VER
FROM max26292/local-php:${PHP_VER}
USER root
RUN apt-get update && apt-get install -y nginx gettext supervisor\
    && rm -rf /var/list/apt/* \
        && rm -rf /var/lib/apt/lists/* \
        && apt-get remove --purge --auto-remove -y && rm -rf /var/lib/apt/lists/* /etc/apt/sources.list.d/nginx.list \
        && apt-get clean
RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log && \
    rm -rf /etc/nginx/conf.d/* \
    && rm -rdf /etc/nginx/sites-available/* \
    && rm -rdf /etc/nginx/sites-enabled/* \
# if we have leftovers from building, let's purge them (including extra, unnecessary build deps)
    && if [ -n "$tempDir" ]; then \
        apt-get purge -y --auto-remove \
        && rm -rf "$tempDir" /etc/apt/sources.list.d/temp.list; \
    fi \
# create a docker-entrypoint.d directory
    && mkdir /docker-entrypoint.d

COPY config/nginx/entriesPoint/docker-entrypoint.sh /
COPY config/nginx/entriesPoint/ /docker-entrypoint.d
COPY config/nginx/nginx-php.conf /etc/nginx/templates/nginx.conf.template
COPY config/nginx/ssl.conf /etc/nginx/templates
COPY config/supervisor/nginx-php.conf /etc/supervisor/conf.d/
COPY config/nginx/php-fpm.conf /usr/local/etc/php-fpm.d/zz-docker.conf
RUN chmod +x -R /docker-entrypoint.d /docker-entrypoint.sh
# USER ${USERNAME}
ENTRYPOINT ["/docker-entrypoint.sh", "nginx"]
# put nginx config

EXPOSE 80 443
CMD ["/usr/bin/supervisord", "-n"]