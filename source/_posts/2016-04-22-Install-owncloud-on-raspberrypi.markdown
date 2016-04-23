---
layout: post
title: "Install owncloud 9.0.2 on RaspberryPi"
date: 2016-04-22 23:16:41
comments: true
mathjax: false
categories: owncloud raspberrypi
---

Install owncloud 9.0.2 on RaspberryPi  
在树莓派上安装owncloud 9.0.2

<!--more-->

### 系统环境

我用的硬件是树莓派3，系统是`raspbian JESSIE LITE`，下载地址<https://www.raspberrypi.org/downloads/raspbian/>，我是新系统全新安装`owncloud`，仅供参考。

首先配置系统扩展到整个SD卡，配置后重启系统才生效。

```
sudo raspi-config 
```

更新`apt`软件仓库，升级系统到最新，可以修改`/etc/apt/source.list`使用aliyun的源。

```
sudo apt-get update
sudo apt-get dist-upgrade
``` 

### owncloud官方安装文档

这里是`owncloud 9.0`版本的官方安装文档,供参阅：<https://doc.owncloud.org/server/9.0/admin_manual/installation/source_installation.html>

### 安装过程

#### 第一步：安装apache2 php和mariadb数据库

安装`owncloud`所需要的`apache` `php` 和`mariadb`数据库软件，安装过程会提示配置`mariadb`数据库的`root`账号密码，牢记这个密码。

```
sudo apt-get install apache2 mariadb-server libapache2-mod-php5 php5-gd php5-json php5-mysql php5-curl php5-intl php5-mcrypt php5-imagick
```

#### 第二步：下载owncloud软件包

下载`owncloud`软件包，并解压，即发现`owncloud`目录。

```
wget https://download.owncloud.org/community/owncloud-9.0.1.tar.bz2
tar -xjf owncloud-9.0.1.tar.bz2
```

### 第三步：为owncloud配置apache2

拷贝`owncloud`代码到`apache2`的网站根目录

```
cp -r owncloud /var/www
```

为`apache2`添加`owncloud.conf`配置文件

```
sudo vi /etc/apache2/sites-available/owncloud.conf
```

```
Alias /owncloud "/var/www/owncloud/"

<Directory /var/www/owncloud/>
  Options +FollowSymlinks
  AllowOverride All

 <IfModule mod_dav.c>
  Dav off
 </IfModule>

 SetEnv HOME /var/www/owncloud
 SetEnv HTTP_HOME /var/www/owncloud

</Directory>
```

将`sites-enabled`里`owncloud.conf`软连接到`sites-available`的`owncloud.conf`

```
ln -s /etc/apache2/sites-available/owncloud.conf /etc/apache2/sites-enabled/owncloud.conf
```

打开`apache2`里`owncloud`所需的模块

```
a2enmod rewrite
a2enmod headers
a2enmod env
a2enmod dir
a2enmod mime
```

重启`apache2`服务

```
service apache2 restart
```

#### 第四步：用occ安装owncloud剩余部分

这一部分可以参考官方文档<https://doc.owncloud.org/server/9.0/admin_manual/installation/command_line_installation.html>

改变`/var/www/owncloud`目录的用户属性

```
sudo chown -R www-data:www-data /var/www/owncloud/
```

用`occ`安装`owncloud`，`database-pass`即为数据库的`root`用户密码，`admin`和`password`是`owncloud`的用户帐号和密码，牢记。

```
$ cd /var/www/owncloud/
```

```
$ sudo -u www-data php occ  maintenance:install --database
"mysql" --database-name "owncloud"  --database-user "root" --database-pass
"password" --admin-user "admin" --admin-pass "password"
```

会提示以下信息

```
ownCloud is not installed - only a limited number of commands are available
ownCloud was successfully installed
```

添加IP或者域名到`config.php`的可信域`trusted_domains`。

```
sudo vi /var/www/owncloud/config/config.php
```

类似下面格式

```
  'trusted_domains' =>
  array (
    0 => 'localhost',
    1 => '192.168.1.104',
    2 => '192.168.1.106',
  ),
``` 

#### 第五步：浏览器打开owncloud

用浏览器访问owncloud的地址，Enjoy owncloud!

```
http://RaspberryPi-IP/owncloud
```

### TODO

1. 没有配置SSL
2. 安全的配置目录权限

