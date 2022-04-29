<?php
/**
 * 定义输出格式
 *
 *
 */

!defined('ROOT_DIR') && die('Access Denied.');

class writerFormat{
    /*dnsmasq支持格式的屏蔽广告列表*/
    const DNSMASQ = array(
        'format' => 'address=/{DOMAIN}/',
        'header' => "#TITLE=AdRules \n#VER={DATE}\n#URL={URL}\n#TOTAL_LINES={COUNT}\n",
        'full_domain' => 0,
        'name' => 'dnsmasq',
        'filename' => '../dnsmasq.conf',
        'whitelist_attached' => array(
            'base-dead-hosts.txt' =>array(
                'merge_mode' => 2, //0=单条，1=单条+子域名，2=根域名相当于1，非根域名相当于0
            ),
        ),
        'src' => array(
            'base-src-easylist.txt' => array(
                'type' => 'easylist',
                'strict_mode' => false,
            ),
            'base-src-hosts.txt' => array(
                'type' => 'hosts',
                'strict_mode' => false,
            ),
            'base-src-strict-hosts.txt' => array(
                'type' => 'hosts',
                'strict_mode' => true,
            ),
        ),
    );

    /*easylist 兼容格式的屏蔽广告列表*/
    const EASYLIST = array(
        'format' => '||{DOMAIN}^',
        'header' => "! Title: AdRules\n! Version: {DATE}\n! Homepage: {URL}\n! Total lines: {COUNT}\n",
        'full_domain' => 0,
        'name' => 'easylist',
        'filename' => '../dns.txt',
        'whitelist_attached' => array(
            'base-dead-hosts.txt' =>array(
                'merge_mode' => 2, //0=单条，1=单条+子域名，2=根域名相当于1，非根域名相当于0
            ),
        ),
        'src' => array(
            'base-src-easylist.txt' => array(
                'type' => 'easylist',
                'strict_mode' => false,
            ),
            'base-src-hosts.txt' => array(
                'type' => 'hosts',
                'strict_mode' => false,
            ),
            'base-src-strict-hosts.txt' => array(
                'type' => 'hosts',
                'strict_mode' => true,
            ),
        ),
    );

    /*Surge 兼容格式的屏蔽广告列表*/
    const SURGE = array(
        'format' => 'DOMAIN-SUFFIX,{DOMAIN}',
        'header' => "#TITLE=AdRules\n#VER={DATE}\n#URL={URL}\n#TOTAL_LINES={COUNT}\n",
        'full_domain' => 0,
        'name' => 'surge',
        'filename' => '../surge.txt',
        'whitelist_attached' => array(
            'base-dead-hosts.txt' =>array(
                'merge_mode' => 2, //0=单条，1=单条+子域名，2=根域名相当于1，非根域名相当于0
            ),
        ),
        'src' => array(
            'base-src-easylist.txt' => array(
                'type' => 'easylist',
                'strict_mode' => false,
            ),
            'base-src-hosts.txt' => array(
                'type' => 'hosts',
                'strict_mode' => false,
            ),
            'base-src-strict-hosts.txt' => array(
                'type' => 'hosts',
                'strict_mode' => true,
            ),
        ),
    );

    /*Surge DOMAIN-SET格式的屏蔽广告列表*/
    const SURGE2 = array(
        'format' => '.{DOMAIN}',
        'header' => "#TITLE=AdRules\n#VER={DATE}\n#URL={URL}\n#TOTAL_LINES={COUNT}\n\n#DOMAIN-SET,https://anti-ad.net/surge2.txt,REJECT\n",
        'full_domain' => 0,
        'name' => 'surge2',
        'filename' => '../surge2.txt',
        'whitelist_attached' => array(
            'base-dead-hosts.txt' =>array(
                'merge_mode' => 2, //0=单条，1=单条+子域名，2=根域名相当于1，非根域名相当于0
            ),
        ),
        'src' => array(
            'base-src-easylist.txt' => array(
                'type' => 'easylist',
                'strict_mode' => false,
            ),
            'base-src-hosts.txt' => array(
                'type' => 'hosts',
                'strict_mode' => false,
            ),
            'base-src-strict-hosts.txt' => array(
                'type' => 'hosts',
                'strict_mode' => true,
            ),
        ),
    );

    /*Domains 格式的屏蔽广告列表，用于支持pi-hole等*/
    const DOMAINS = array(
        'format' => '{DOMAIN}',
        'header' => "#TITLE=AdRules\n#VER={DATE}\n#URL={URL}\n#TOTAL_LINES={COUNT}\n",
        'full_domain' => 1, //保留子域名，即使其上级域名
        'name' => 'domains',
        'filename' => '../ad-domains.txt',
        'whitelist_attached' => array(
            'base-dead-hosts.txt' =>array(
                'merge_mode' => 2, //0=单条，1=单条+子域名，2=根域名相当于1，非根域名相当于0
            ),
        ),
        'src' => array(
            'base-src-easylist.txt' => array(
                'type' => 'easylist',
                'strict_mode' => false,
            ),
            'base-src-hosts.txt' => array(
                'type' => 'hosts',
                'strict_mode' => false,
            ),
            'base-src-strict-hosts.txt' => array(
                'type' => 'hosts',
                'strict_mode' => true,
            ),
        ),
    );

    /*smartdns支持格式的屏蔽广告列表*/
    const SMARTDNS = array(
        'format' => 'address /{DOMAIN}/#',
        'header' => "#TITLE=AdRules for SmartDNS\n#VER={DATE}\n#URL={URL}\n#TOTAL_LINES={COUNT}\n",
        'full_domain' => 0,
        'name' => 'dnsmasq',
        'filename' => '../smartdns.conf',
        'whitelist_attached' => array(
            'base-dead-hosts.txt' =>array(
                'merge_mode' => 2, //0=单条，1=单条+子域名，2=根域名相当于1，非根域名相当于0
            ),
        ),
        'src' => array(
            'base-src-easylist.txt' => array(
                'type' => 'easylist',
                'strict_mode' => false,
            ),
            'base-src-hosts.txt' => array(
                'type' => 'hosts',
                'strict_mode' => false,
            ),
            'base-src-strict-hosts.txt' => array(
                'type' => 'hosts',
                'strict_mode' => true,
            ),
        ),
    );

    /*Clash RULE-SET 格式的屏蔽广告列表*/
    const CLASH = array(
        'format' => '  - \'+.{DOMAIN}\'',
        'header' => "#TITLE=AdRules\n#VER={DATE}\n#URL={URL}\n#TOTAL_LINES={COUNT}\n\n#RULE-SET,AdRules,REJECT\npayload:\n",
        'full_domain' => 0,
        'name' => 'clash',
        'filename' => '../clash.yaml',
        'whitelist_attached' => array(
            'base-dead-hosts.txt' =>array(
                'merge_mode' => 2, //0=单条，1=单条+子域名，2=根域名相当于1，非根域名相当于0
            ),
        ),
        'src' => array(
            'base-src-easylist.txt' => array(
                'type' => 'easylist',
                'strict_mode' => false,
            ),
            'base-src-hosts.txt' => array(
                'type' => 'hosts',
                'strict_mode' => false,
            ),
            'base-src-strict-hosts.txt' => array(
                'type' => 'hosts',
                'strict_mode' => true,
            ),
        ),
    );

    /*and etc...*/

}
