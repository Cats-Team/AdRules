# AdKillRules
# 项目说明

合并类过滤广告规则订阅

## 描述
去广告规则<br/>
适用AdGuard,AdGuardHome,ADAWAY等等<br/>
由众多规则合并产生<br/>

## 规则总数
AdKillRules规则：180000+<br/>
AdGuardRules规则：80000+<br/>

## 🔖 过滤工具推荐

过滤工具：
* 🌍 浏览器插件
  * [AdGuard](https://adguard.com)
  * [uBlock Origin](https://github.com/gorhill/uBlock)
  * [AdBlock Plus](https://adblockplus.org)
  * [Adblock](https://getadblock.com)
* 📺 路由器端
  * [AdGuard Home](https://adguard.com/zh_cn/adguard-home/overview.html)
  * [KoolProxyR](https://github.com/user1121114685/koolproxyR)
  * [Adbyby](http://www.adbyby.com/)
  * [阿呆喵](http://www.admflt.com)
* 📱 移动端
  * [AdGuard for Android](https://adguard.com/zh_cn/adguard-android/overview.html)
  * [AdGuard for iOS](https://adguard.com/zh_cn/adguard-ios/overview.html)
* 💻 桌面端（全局去广告）
  * [AdGuard for Windows](https://adguard.com/zh_cn/adguard-windows/overview.html)
  * [AdGuard for macOS](https://adguard.com/zh_cn/adguard-mac/overview.html)

## 🕹 项目原理
项目使用了 GitHub Actions 在每天 UTC 时间每隔12小时更新合并一次最新规则，然后推送到 GitHub Repo。  
配合使用四个网站提供的全球加速 CDN 来分发规则  
①[FastGit](https://fastgit.org) （实时更新）  
②[Coding](https://coding.net) （实时更新）   
③[Jsdelivr](https://www.jsdelivr.net) （具有缓存）   
④[Staticaly](https://staticaly.io) （具有缓存）  
从而实现秒秒钟更新所有去广告规则。

## 🍔 使用方法
**⚠️ 注意：** 该规则不是针对网络代理工具的，不要给 Surge、ShadowRocket、Quantumult(X)、Clash(X/A) 等类似工具使用！
直接拷贝下方表格中，对应规则的加速地址，作为去广告工具的订阅规则链接即可。

## 📃 规则列表

|   规则名称   | 🚀 加速地址 ① | 🚀 加速地址  ② | 🚀 加速地址 ③ | 🚀 加速地址 ④ |
|  :----:  | :----:  | :----:  |  :----:  |  :----:  |
| AdkillRules | [加速链接①](https://raw.fastgit.org/Cats-Team/AdRules/main/AdKillRules.txt) |[加速链接②](https://cats-team.coding.net/p/adguard/d/AdRules/git/raw/main/AdKillRules.txt) |[加速链接③](https://cdn.jsdelivr.net/gh/Cats-Team/AdRules@latest/AdKillRules.txt) |[加速链接④](https://cdn.staticaly.com/gh/Cats-Team/AdRules@latest/AdKillRules.txt)|
| AdGuardRules | [加速链接①](https://raw.fastgit.org/Cats-Team/AdRules/main/adguard.txt) | [加速链接②](https://cats-team.coding.net/p/adguard/d/AdRules/git/raw/main/adguard.txt)|[加速链接③](https://cdn.jsdelivr.net/gh/Cats-Team/AdRules@latest/adguard.txt) |[加速链接④](https://cdn.staticaly.com/gh/Cats-Team/AdRules@latest/adguard.txt) |

# Coding地址：[链接](https://cats-team.coding.net/public/adguard/AdRules/git/files)
# 特别鸣谢
* [@Cats-team](https://github.com/Cats-Team)
* [@DoingDog](https://github.com/DoingDog)

## 访问量
![](http://profile-counter.glitch.me/cats-team/count.svg)
