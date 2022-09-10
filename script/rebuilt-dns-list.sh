#!/bin/bash
cd $(cd "$(dirname "$0")";pwd)
cd ./origin-files/
echo 开始处理DNS规则
yc=`cat base-src-easylist.txt base-src-hosts.txt wildcard-src-easylist.txt| grep -vE ']|@|!' | sed -e "s/127.0.0.1 //g" | sed 's/[ ]//g'|sort|uniq `
wl=`cat ../mod-lists.txt |grep -v "^#" |sed "s/\#.*//g"`
dead=`cat base-dead-hosts.txt |sed "s/\#.*//g"`
wl0=`echo "$wl" |grep '^0 '|sed 's/0 //g'`
wl1=`echo "$wl" |grep '^1 '|sed 's/1 //g'`
wl2=`echo "$wl" |grep '^2 '|sed 's/2 //g'`
wl4=`echo "$wl" |grep '^4 '|sed 's/4 //g'`
rm=`echo "$wl" |grep '^3 '|sed 's/3 //g'`
echo "$yc" >pre-rules.txt
cat pre-rules.txt base-dead-hosts.txt base-dead-hosts.txt |sort |uniq -u |grep -Pv "^((25[0-5]|2[0-4]\d|((1\d{2})|([1-9]?\d)))\.){3}(25[0-5]|2[0-4]\d|((1\d{2})|([1-9]?\d)))$" > 1.txt
mv -f 1.txt pre-rules.txt
echo Moding...
for i in `echo "$wl0"`
do
  sed -i "/$i/d" pre-rules.txt
done
wait
for i in `echo "$wl1"`
do
  sed -i "/.*$i/d" pre-rules.txt
done
wait
for i in `echo "$wl2"`
do
  sed -i "/$i/d" pre-rules.txt
done
wait
echo 输出文件
i=`cat pre-rules.txt| grep -v "#"|grep -v "\/"|grep -v "^\."|sed 's/.*#.*//g' | sed '/^$/d'`
echo "$i"| grep -v "\*"| sed '/^$/d' > ../../ad-domains.txt
echo "$i"| sed 's/^/||/g'|sed "s/$/\^/g"|sed '/^$/d' > ../../dns.txt
echo "$i"|  grep -v "\*"|sed '/^$/d' |sed 's/^/0.0.0.0 /g' > ../../hosts.txt
#echo "$i"| grep -v '\*' |sed 's/^/host-suffix,/g'|sed 's/$/,reject/g' > ../../qx.conf
wait
cd ../../
cat ./mod/rules/*-rules.txt |grep -E "^(\@\@)[^\/\^]+\^" |sort|uniq >> dns.txt

echo "$wl2"|sed "s/^/\@\@\|\|/g" |sed "s/$/\^/g" >> dns.txt
#cat ./script/*/white_domain_list.php |grep -Po "(?<=').+(?=')" | sed "s/^/||&/g" |sed "s/$/&^/g"| sed '/^$/d'   > allowtest.txt
hostlist-compiler -c ./script/dns-rules-config.json -o dns-output.txt 
wait
rm -f allowtest.txt
mv -f dns-output.txt dns.txt
#通配符规则
for i in $rm
do
  sed -i "/||.*$i^/d" dns.txt
  echo "$i" |sed 's/^/||/g'|sed 's/$/\^/g'>> dns.txt
done
wait
#cd ./script/
#cd ../
echo "# Title:AdRules Quantumult X List " > qx.conf
echo "# Title:AdRules SmartDNS List " > smart-dns.conf
echo "# Update: $(TZ=UTC-8 date +'%Y-%m-%d %H:%M:%S')(GMT+8) " >> qx.conf 
echo "# Update: $(TZ=UTC-8 date +'%Y-%m-%d %H:%M:%S')(GMT+8) " >> smart-dns.conf
cat dns.txt|grep -v '@'|grep -Po "(?<=\|\|).+(?=\^)"| grep -v "\*" |sed 's/^/host-suffix,/g'|sed 's/$/,reject/g' >> ./qx.conf
cat dns.txt|grep -v '@'|grep -Po "(?<=\|\|).+(?=\^)"| grep -v "\*" |sed "s/^/address \//g"|sed "s/$/\/#/g" >> ./smart-dns.conf
#cd ./script/origin-files/
rm -f ./script/origin-files/*.txt
touch ./script/origin-files/0.txt
cd ./script/
echo "$wl0" |grep "\." |grep -v "\*" >> ../allow-domains-list.txt
echo "$wl1" |grep "\." |grep -v "\*" >> ../allow-domains-list.txt
echo "$wl2" |grep "\." |grep -v "\*" >> ../allow-domains-list.txt
echo "$wl4" |grep "\." |grep -v "\*" >> ../allow-domains-list.txt

echo "$wl4"| sed 's/^/@@||/g'|sed "s/$/\^/g"|sed '/^$/d' > ../allow.txt
python rule.py ../allow-domains-list.txt

exit
