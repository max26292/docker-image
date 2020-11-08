FROM node:lts as builder

# install process
COPY ./install_script /home/install_script
# RUN find /home -type f -printf "%f\n"v
# RUN ls /home
RUN chmod +x /home/install_script/install.sh && /bin/sh -c "/home/install_script/install.sh"
EXPOSE 3000

# RUN /home/install_script/yarn install
# RUN /bin/bash /home/install_script/install.sh
# RUN yarn install && yarn cache list

WORKDIR /home/app 