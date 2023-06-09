#!/bin/dash
testConfig="8.1"
phpVer=${testConfig%_*}
nodeVer=${testConfig#"$phpVer"}
nodeVer=${nodeVer#_}
echo "php ver: ${phpVer}"
echo "node ver: ${nodeVer}"
echo "PHP_VER=${phpVer} NODE_VER=${nodeVer}"
docker build --build-arg PHP_VER="${phpVer}" \
    --build-arg NODE_VER="${nodeVer}" \
    -f ./test.dockerfile \
    -t 'test:v1' .
# if [ -z "$nodeVer" ]; then
#     docker build --build-arg PHP_VER="${phpVer}" \
#     -f ./test.dockerfile \
#     -t 'test:v1' .
# else
#     docker build --build-arg PHP_VER="${phpVer}" \
#     --build-arg NODE_VER="${nodeVer}" \
#     -f ./test.dockerfile \
#     -t 'test:v1' .
# fi
