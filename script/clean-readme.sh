#!/bin/sh
num_adl=`sed -n 's/^! Total count: //p' adblock_lite.txt`
num_adb=`sed -n 's/^! Total count: //p' adblock.txt`
num_adp=`sed -n 's/^! Total count: //p' adblock_plus.txt`
num_dns=`sed -n 's/^! Total count: //p' dns.txt`
num_domains=`sed -n 's/^! Total count: //p' ad-domains.txt`

time=$(TZ=UTC-8 date +'%Y-%m-%d %H:%M:%S')
sed -i "s/^Update Time:.*/Update Time: $time  /g" README.md
sed -i 's/^AdRules AdBlock List :.*/AdRules AdBlock List : '$num_adb' /g' README.md
sed -i 's/^AdRules AdBlock List Plus :.*/AdRules AdBlock List Plus : '$num_adp' /g' README.md
sed -i 's/^AdRules AdBlock List Lite :.*/AdRules AdBlock List Lite : '$num_adl' /g' README.md
sed -i 's/^AdRules DNS List .*/AdRules DNS List : '$num_dns' /g' README.md
sed -i 's/^AdRules Ad Domains List .*/AdRules Ad Domains List : '$num_domains' /g' README.md
exit
