#!/bin/bash
testConfig="8.1_17"
configs=(${testConfig//_/ })
echo "${configs[0]}"
echo "con 1:${configs[1]}"