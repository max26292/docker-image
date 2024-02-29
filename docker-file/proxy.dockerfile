FROM nginx:latest

ARG APP_SERVICE
RUN  rm -rf /etc/nginx/conf.d/*
# put nginx config
COPY ./config/nginx/nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 1237
CMD ["nginx", "-g", "daemon off;"]