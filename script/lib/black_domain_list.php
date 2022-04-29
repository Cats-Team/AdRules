<?php
//黑名单域名，即直接封杀主域名，效果就是只要是使用该域名及其下级所有域名的请求全部被阻挡，慎重使用

//这个文件主要定义针对hosts文件中不能泛域名解析而优化减少生成行数
//对于个性化屏蔽的域名，全部移动到block_domains.root.conf中管理

return array(
    'cnzz.com' => array('cnzz.com'),
    'cnzz.net' => array('cnzz.net'),
    'cnzz.cn' => array('cnzz.cn')
);
