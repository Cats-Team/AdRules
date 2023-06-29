# -*- coding: UTF-8 -*-
import requests
import json
import os
import re
import time
#import base64
#from io import BytesIO
from datetime import datetime, timezone, timedelta

PUSH_TOKEN = os.environ["SCKEY"]
PUSH_PUSH = os.environ["PUSH_PUSH"]
MAILCHANNEL = "mail"
TG_TOKEN = os.environ["TG_TOKEN"]
CHAT_ID = os.environ["CHAT_ID"]

def iter_count(file_name):
    from itertools import (takewhile, repeat)
    buffer = 1024 * 1024
    with open(file_name, 'r', encoding='utf-8') as f:
        buf_gen = takewhile(lambda x: x, (f.read(buffer) for _ in repeat(None)))
        return sum(buf.count('\n') for buf in buf_gen)

count_a = iter_count("adguard.txt") -9
count_af = iter_count("adguard-full.txt") -9
count_ab = iter_count("adblock_plus.txt") -9
count_al = iter_count("allow.txt") -9
count_A = iter_count("adblock.txt") -9
count_d = iter_count("dns.txt") -9
count_ad = iter_count("hosts.txt") -9
count_domians = iter_count("ad-domains.txt") -6

#设置时区
#tz_utc_8 = timezone(timedelta(hours=8))
now_time = datetime.now()

tz_utc_8 = now_time + timedelta(hours=8)
#设置时间
#time = (time.strftime('%Y-%m-%d %H:%M:%S',time.localtime(time.time())))       # 打印按指定格式排版的时间
time = tz_utc_8.strftime("%Y-%m-%d %H:%M:%S")

#一言
api_url = 'https://v1.hitokoto.cn/?&encode=text'
one = requests.get(api_url)

#图库
png_url = 'https://api.ixiaowai.cn/api/api.php'
png = requests.get(png_url)
#图片转base64
#pngb6 = base64.b64encode(BytesIO(png.content).read())

CONTENT = 'AdRules规则更新完毕！ 来自Github~<br>更新时间 ' + str(time) + '（北京时间）<br><br>AdRules (For AdBlock)共计' + str(count_A) + '条规则，<br>AdRules (For AdGuard)共计' + str(count_a) + '条规则，<br>AdRules (For DNS)共计' + str(count_d) + '条规则，<br>AdRules (For Adaway)共计' + str(count_ad) + '条规则，<br>Allowlist共计' + str(count_al) + '条规则，<br>广告domians共计' + str(count_domians) + '个。<br>AdRules AdBlock Full List 共计' + str(count_ab) + '条规则<br>AdRules AdGuard Full List 共计' + str(count_af) +'条规则<br><br>一言：' + str(one.text) +' <img style="max-width:100%;overflow:hidden;" src="' + str(png.url) + '"/>' 

#def post_tg(message):
#    telegram_message = f"{message}"
#    params = (
#        ('chat_id', CHAT_ID),
#        ('text', telegram_message),
#        ('parse_mode', "Html")
#    )
#    telegram_url = "https://api.telegram.org/bot" + TG_TOKEN + "/sendMessage"
#    telegram_req = requests.post(telegram_url, params=params)
#    telegram_status = telegram_req.status_code
#    if telegram_status == 200:
#        print(f"INFO: Telegram Message sent")
#    else:
#        print(telegram_status)

def post_pp():
    TITLE = 'AdRules更新通知'
    url = 'http://www.pushplus.plus/send'
    data = {
		  "token":PUSH_PUSH,
		  "title":TITLE,
		  "content":CONTENT
        }
    body = json.dumps(data).encode(encoding = 'utf-8')
    headers = {'Content-Type':'application/json'}
    requests.post(url, data=body, headers=headers)
	
def post_ppp():
    TITLE = 'AdRules更新通知'
    url = 'http://www.pushplus.plus/send'
    data = {
		  "token":PUSH_PUSH,
		  "title":TITLE,
		  "content":CONTENT,
	          "channel":MAILCHANNEL
        }
    body = json.dumps(data).encode(encoding = 'utf-8')
    headers = {'Content-Type':'application/json'}
    requests.post(url, data=body, headers=headers)

#post_tg(CONTENT)
post_pp()
post_ppp()

