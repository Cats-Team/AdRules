#!/bin/bash
cd script/hosts/src

# Start Download
echo "开始更新AdRules（For Adaway）"
#wget https://raw.githubusercontent.com/Cats-Team/AdRules/main/dns.txt
cp ../../dns.txt ./dns.txt
cat dns.txt | grep '^|' | grep -v '\*'| grep -Ev "([0-9]{1,3}.){3}[0-9]{1,3}" |sed 's/||/0.0.0.0 /' | sed 's/\^//' | grep -v "^|" > mergd.txt

# Start Merge and Duplicate Removal
cat mergd.txt | grep '^1'  > 1.txt
cat mergd.txt | grep '^0'  > 0.txt
cat 1.txt 0.txt hosts.txt > tmpp.txt
cat tmpp.txt | grep -v 'local' | sed 's/127.0.0.1 /0.0.0.0 /' >temp.txt
sort -n temp.txt | uniq > tmp.txt
echo "开始处理规则"
# Create ad damian
cat tmp.txt | sed 's/0.0.0.0 //' > damian-init.txt

# Start Count Rules
num=`cat tmp.txt | wc -l`

# Start Add title and date
echo "# Version: `date +"%Y-%m-%d %H:%M:%S"`" >> tpdate.txt
echo "# Total count: $num" >> tpdate.txt
cat title.dd tpdate.txt tmp.txt > final.txt
cat tpdate.txt damian-init.txt >> damian.txt
echo "规则处理完毕"
mv final.txt ../../hosts.txt
mv damian.txt ../../../damian.txt
rm *.txt
cd ../../
exit
