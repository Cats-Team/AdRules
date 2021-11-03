cd /d %~dp0
cd aa
@echo off

::start download

wget -O i1.txt https://raw.githubusercontent.com/r-a-y/mobile-hosts/master/AdguardDNS.txt 
wget -O i2.txt https://raw.githubusercontent.com/r-a-y/mobile-hosts/master/AdguardMobileSpyware.txt
wget -O i3.txt https://adaway.org/hosts.txt
wget -O i4.txt https://raw.githubusercontent.com/r-a-y/mobile-hosts/master/AdguardApps.txt
wget -O i5.txt https://raw.githubusercontent.com/r-a-y/mobile-hosts/master/AdguardMobileAds.txt

::add new rules
::wget -O i+number url

::end download

::no need to change
del /f /q *.html
del /f /q *hsts

::blankline
for %%i in (i*.txt) do type blank.dd>>%%i

::TheRuleMaker
::No need to change

::Merge
type frules.dd>mergd.txt
type i*.txt>>mergd.txt

::nore
gawk "!a[$0]++" mergd.txt>nore.txt

::del comments
::(findstr /b /c:"|" /c:"@" nore.txt)>nord.txt

::count rules
for /f "tokens=2 delims=:" %%a in ('find /c /v "" nord.txt')do set/a rnum=%%a
::error
set/a rnum+=1

::add title and date
echo ! Version: %date%>>tpdate.txt
echo ! Last modified: %date%T%time%Z>>tpdate.txt
echo ! Total count: %rnum%>>tpdate.txt
copy title.dd+tpdate.txt+nord.txt+brules.dd final.txt

::end
copy /y final.txt ..\..\dns.txt
del /f /q *.txt&exit
