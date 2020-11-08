#!/bin/bash
cd /home/install_script
yarn install && yarn cache list
cd ../
rm -dR install_script
# rm -R install_script
