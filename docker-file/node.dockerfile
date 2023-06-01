ARG PHP_VER
FROM max26292/local-php:${PHP_VER}
ARG NODE_VER
USER root
SHELL [ "/bin/bash","-c" ]
ENV USERNAME=www-data
RUN curl -fsSL https://deb.nodesource.com/setup_${NODE_VER}.x -o /tmp/nodesource_setup.sh && bash /tmp/nodesource_setup.sh \
    && apt-get install -y nodejs chromium\
    && rm -rf /var/list/apt/* \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean \
    && npm install -g npm \
    && npm install -g yarn
EXPOSE 5173 3000 
USER ${USERNAME}
ARG DATABASE_URL
