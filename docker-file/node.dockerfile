ARG PHP_VER
FROM max26292/local-php:${PHP_VER}
USER root
SHELL [ "/bin/bash","-c" ]
ARG NODE_VER
ENV USERNAME=www-data
RUN curl -sL https://deb.nodesource.com/setup_${NODE_VER}.x -o /tmp/nodesource_setup.sh && bash /tmp/nodesource_setup.sh \
    && apt-get install nodejs \
    && rm -rf /var/list/apt/* \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean \
    && npm install -g npm \
    && npm install -g yarn
USER ${USERNAME}
