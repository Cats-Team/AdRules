cd /d %~dp0
cd aa
@echo off

::start download

wget -O i1.txt https://adguardteam.github.io/AdGuardSDNSFilter/Filters/filter.txt
wget -O i5.txt https://file.trli.club/dns/hosts.txt
wget -O i6.txt https://adaway.org/hosts.txt

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
(findstr /r /b "^/." nore.txt)>ntpa.txt
(findstr /r /v /b "^/." nore.txt)>ntpq.txt
(findstr /v /b /e "#[^#]*" ntpq.txt)>ntpf.txt
(for /f "eol=! delims=" %%i in (ntpf.txt) do (echo %%i))>ntps.txt
(for /f "eol=[ delims=" %%i in (ntps.txt) do (echo %%i))>nord.txt
type ntpa.txt>>nord.txt

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
copy /y final.txt ..\..\dnsfilter.txt
del /f /q *.txt&exit
