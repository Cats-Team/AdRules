<?php
//white_domain_list
//白名单机制...，白名单是
//@date 2018年12月23日
//value=-1,代表失效本条规则，暂只支持单域名（针对引入外部白名单时的精确控制）,当处于strict_mode时，排除此key，单条关闭strict_mode
//value=0,代表仅加白单条域名
//value=1,代表其下级域名全部加白（例如3级域名，则其4级子域名全部加白）
//value=2,代表仅加白主域名及其子域名，即如果是主域名，加白全部，如果是子域名，加白命中的单条

return array(
    /**notracking 提议加白的一批域名 start**/
    'scribol.com' => 0,
    'tracking.epicgames.com' => 0,
    'logrocket.com' => 0,
    'loggly.com' => 0,
    'om.cbsi.com' => 0,
    'ipinfo.io' => 0,
    'v.shopify.com' => 0,
    'adobedtm.com' => 0,
    'c.evidon.com' => 0,
    'ereg.wip3.adobe.com' => 0,
    'csi.gstatic.com' => 0,
    'g.msn.com' => 0,
    'sascdn.com' => 0,
    'duckdns.org' => 0,
    'prf.hn' => 0,
    'placehold.it' => 0,
    'digg.com' => 0,
    'feedburner.com' => 0,
    'rambler.ru' => 1,
    'jiathis.com' => 0,
    'rs6.net' => 0,
    'com.com' => 0,
    's0.2mdn.net' => 0,
    'pr0gramm.com' => 0,
    'consent.cmp.oath.com' => 0,
    's.youtube.com' => 0,
    'purch.com' => 0,
    'fpdownload.macromedia.com' => 0,
    'dynatrace.com' => 0,
    'auditude.com' => 0,
    'app.link' => 0,
    /**notracking 提议加白的一批域名 end**/
);
