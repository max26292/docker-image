FROM nginx:stable

ARG APP_SERVICE
RUN  ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log && \
    rm -rf /etc/nginx/conf.d/*
# put nginx config
# COPY ./config/nginx/nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 3000 80 443 5173 9000 9003