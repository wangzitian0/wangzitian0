title: Gitlab安装
author: 田_田
tags:
  - Tools
categories: []
date: 2016-01-05 11:51:00
---
需要一个Git私有库，选来选去觉得 gitlab 比较靠谱。后来搜到一个神器，bitnami！

<!-- more -->
## 简介

gitlab安装方法:
[官方文档](https://about.gitlab.com/installation/#ubuntu)
看着麻烦，一堆依赖，我就想着有没有什么脚本可以一件安装，然后就去找了一会，找到了 bitnami。它可以像 windows 安装包一样，一键安装包括不限于 wiki, git, LAMP, ERP, Dashboard等等。

```
BitNami是一个开源项目，该项目产生的开源软件包括安装 Web应用程序和解决方案堆栈，以及虚拟设备。
```
换句话说，下个安装包，一键安装。安装的时候会让你自己选择需要服务的端口。

```
bitnami install
```
另外，提供了虚拟机的磁盘映像，直接挂载到 virtualbox 或者 vmware就可以开箱即用。

具体介绍和安装可以看这个： [官方文档](https://bitnami.com/stack/gitlab)

## 我遇到的问题

1.安装老是 crash，后来根据错误信息查到，bitnami的 stack 需要内存大于1G，之前是在BUPT ACM 的 EXSi 上面搞，所以大小随便没有报错过。解决方法：改阿里云的 swap area，保证它不小于1g，具体方法在阿里云的帮助文件里面有


2.gitlab 邮件不正常出来
后来查到邮件是两个配置，一个是 bitnami 的系统配置，一个是 gitlab 的系统配置：
第一个
```
$ sudo vi /opt/gitlab-8.1.4-1/apps/gitlab/htdocs/config/environments/production.rb 
```
```
config.action_mailer.perform_deliveries = true
config.action_mailer.raise_delivery_errors = true
config.action_mailer.delivery_method = :smtp
config.action_mailer.smtp_settings = {
  :address => "smtp.aliyun.com",
  :port => "25",
  :domain => "aliyun.com",
  :authentication => :login,
  :user_name => "wangzitian0@aliyun.com",
  :password => "*******",
  :enable_starttls_auto => false
}
```
另一个
```
$ sudo vi /opt/gitlab-8.1.4-1/apps/gitlab/htdocs/config/gitlab.yml 
```
另外，调试过程中发现一个问题，邮箱有一个限制，大致是smtp 协议里的发件人和调用 api 的时候给的发件人必须一样。把email部分的收发人改为配置里面一样的即可。
查了下原因，大致如下：
```
用过outlook的都知道，配置自己的邮件地址和名字为jobs@apple.com（乔布斯），
那么对方就会显示发件人是乔布斯，他回信会回到jobs@apple.com，你收不到而已，
这是因为smtp（邮件协议）并不认证发件人信息，那些发件认证只是确定你在服务器有发邮件权限，
并不认证发件人是否是本人。
```