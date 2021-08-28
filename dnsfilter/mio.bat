cd /d %~dp0
cd aa
@echo off

::start download

wget -O i1.txt https://adguardteam.github.io/AdGuardSDNSFilter/Filters/filter.txt
wget -O i2.txt https://file.trli.club/dns/hosts.txt
wget -O i3.txt https://adaway.org/hosts.txt
wget -O i4.txt https://raw.githubusercontent.com/banbendalao/ADgk/master/ADgk.txt
#wget -O i5.txt https://raw.githubusercontent.com/o0HalfLife0o/list/master/ad-pc.txt

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
(for /f "eol=/ delims=" %%i in (nord.txt) do (echo %%i))>norc.txt
(for /f "eol=$ delims=" %%i in (norc.txt) do (echo %%i))>norb.txt
(for /f "eol=# delims=" %%i in (norb.txt) do (echo %%i))>nora.txt
type ntpa.txt>>nora.txt

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
