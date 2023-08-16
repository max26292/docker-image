FROM nginx:latest

ARG APP_SERVICE
RUN  ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log && \
    rm -rf /etc/nginx/conf.d/*
# put nginx config
COPY config/nginx /etc/nginx/templates
EXPOSE 80 443
