#!/bin/dash
testConfig="8.1_16"
phpVer=${testConfig%_*}
nodeVer=${testConfig#"$phpVer"}
nodeVer=${nodeVer#_}
echo "php ver: ${phpVer}"
echo "node ver: ${nodeVer}"
# echo "con 1:${configs[1]}"