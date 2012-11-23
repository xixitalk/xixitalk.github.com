---
layout: post
title: "flask_twip在heroku上搭建教程"
date: 2012-11-23 21:01
comments: true
categories: 
---

[flask_twip](https://github.com/yegle/flask_twip)是@[yegle](http://twitter.com/yegle)写的一个可以搭建在[heroku](http://www.heroku.com/)上的一个[twip](http://code.google.com/p/twip/)移植版本。

本教程使用的基于flask_twip-0.0.1的修改版本[flask_twip-0.0.1_mod.zip](https://github.com/xixitalk/flask_twip/blob/master/release/flask_twip-0.0.1_mod.zip)，主要是因为原版本O模式认证后的token保存在文件里，而heroku的文件为临时文件，经过不到一天就会丢失，本修改将认证信息通过写代码里第二次上传来规避临时文件丢失，其次增加了gzip支持。

准备工作
-

1、注册heroku帐号,过程略。 

2、在<https://dev.twitter.com>注册一个API的key，记录consumer key和consumer secret，下面会用到。 callback的url是
    http://APPNAME.herokuapp.com/twip/oauth/callback/
APPNAME是你heroku应用的名字。可以提前写好，也可以heroku的应用创建后再回来修改。 在进行O模式认证前要修改好，不然认证后返回不正确，切记。

3、找一个linux机器，以下以ubuntu为例，windows没试过，windows很多命令工具没有，比如pip和virtualenv。 ubuntu用下面命令安装heroku工具，也可参见<https://toolbelt.heroku.com/debian>
    wget -qO- https://toolbelt.heroku.com/install-ubuntu.sh | sh
有些命令如果系统没有安装单独用apt-get install安装，如git、virtualenv、pip。

开始创建heroku应用
-

以下步骤可以同步参考<https://devcenter.heroku.com/articles/python>

1、输入heroku帐号密码登录
    $heroku login
    
2、用下面命令创建一个目录，比如mytwip，并进入到mytwip目录里。
    $mkdir mytwip && cd mytwip 

3、用下面命令在mytwip目录里创建一个虚拟化环境，mytwip目录里会出现一个venv的目录 
    $virtualenv venv --distribute

4、用下面命令切换到虚拟化环境 
    $source venv/bin/activate

5、将代码拷入,将Procfile同级目录的所有文件目录拷贝到mytwip目录里。 用$pip freeze看依赖情况，要求输出和和代码里的requirements.txt一样，如果不完整，用pip install安装。 如$pip install Flask 
    $pip freeze
    $pip install Flask
requirements.txt文件内容如下:
	Flask==0.9
	Flask-OAuth==0.12
	Jinja2==2.6
	Werkzeug==0.8.3
	argparse==1.2.1
	distribute==0.6.24
	httplib2==0.7.7
	oauth2==1.5.211
	requests==0.14.2
	wsgiref==0.1.2

6、修改examples\settings.py 修改settings.py里的TWITTER_CONSUMER_KEY和TWITTER_CONSUMER_SECRET值为准备工作第2步twitter API创建的值。 

7、Procfile设置跳过，代码里已经包含。

8、$foreman start跳过，这里是本地试运行。

9、在mytwip目录下建一个.gitignore文件，表示venv目录和pyc文件不上传git服务器。
    venv
    *.pyc

10、初始化mytwip目录的git环境。
    $git init $git add . 
    $git commit - m "init" 
11、创建应用,APPNAME为自定义名字。
    $heroku create APPNAME 
检查准备工作第2步的twitter API key的callback URL是否为：         
    http://APPNAME.herokuapp.com/twip/oauth/callback/
如果创建后想修改应用名字在mytwip目录用下面命令再修改，newname是自定义新应用名称。
    $heroku apps:rename newname

12、将应用上传到heroku的git服务器，应用自动运行。
    $ git push heroku master 

13、浏览器访问https://APPNAME.herokuapp.com/twip/进行O模式认证 认证完成后记录API和TWITTER_ACCESS_TOKEN。API为：
    http://APPNAME.herokuapp.com/twip/TWITTER/KEY/
其中TWITTER为你的twitter用户名，KEY就是该API的key，API地址要保密,任何人通过这个地址都能访问你的twitter帐号。

14、将twitter帐号、API的key和access token修改到settings.py里，TWITTER_ACCESS_TOKEN比较长，要保证在一行。用下面命令重新上传。 
    $git add . 
    $git commit -m "update key" 
    $git push heroku master 
这样据全部完成，可以在支持twip O模式的客户端使用了，注意将API里的http替换成https，不然会被墙的。
    https://APPNAME.herokuapp.com/twip/TWITTER/KEY/
