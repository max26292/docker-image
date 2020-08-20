FROM node:lts as builder
WORKDIR /home/yarn-preinstall
ADD package.json package.json
ADD yarn.lock yarn.lock
RUN yarn install && yarn cache list