---
layout: post
title: "flask_twip在heroku上搭建教程"
date: 2012-11-23 21:01
comments: true
categories: heroku git flask_twip twip twitter
---

[flask_twip](https://github.com/yegle/flask_twip)是@[yegle](http://twitter.com/yegle)写的一个可以搭建在[heroku](http://www.heroku.com/)上的一个[twip](http://code.google.com/p/twip/)的port程序。

经@yegle提醒，flask_twip已经开发到0.0.5版本，支持SQLBackend存储，认证的token不会再丢失，所以本教程更新到flask_twip-0.0.5。

<del>
本教程使用的基于flask_twip-0.0.1的修改版本[flask_twip-0.0.1_mod.zip](https://github.com/xixitalk/flask_twip/blob/master/release/flask_twip-0.0.1_mod.zip)，主要是因为原版本O模式认证后的token保存在文件里，而heroku的文件为临时文件（[ephemeral文件](https://devcenter.heroku.com/articles/python-faq#can-i-read-from-and-write-to-the-file-system)），经过不到一天就会丢失，本修改将认证信息通过写代码里第二次上传来规避临时文件丢失，其次增加了gzip压缩支持。
</del>

准备工作
-

1、注册heroku帐号,过程略。 

2、在<https://dev.twitter.com>注册一个API的key，记录consumer key和consumer secret，下面会用到。 callback的url是
	https://APPNAME.herokuapp.com/twip/oauth/callback/
APPNAME是你heroku应用的名字。@yegle提醒说callback可以随便填写。

3、找一个linux机器，以下以ubuntu为例，windows没试过，windows很多命令工具没有，比如pip和virtualenv。 ubuntu用下面命令安装heroku工具，也可参见<https://toolbelt.heroku.com/debian>
	wget -qO- https://toolbelt.heroku.com/install-ubuntu.sh | sh
有些命令如果系统没有安装单独用apt-get install安装，如git、virtualenv、pip。

开始创建heroku应用
-

以下步骤可以同步参考<https://devcenter.heroku.com/articles/python>

1、输入heroku帐号密码登录
	$heroku login
    
2、用下面命令创建一个目录，比如mytwip，并进入到mytwip目录里。以下命令都是在mytwip目录里进行的。
	$mkdir mytwip && cd mytwip 

3、用下面命令在mytwip目录里创建一个虚拟化环境，mytwip目录里会出现一个venv的目录 
	$virtualenv venv --distribute

4、用下面命令切换到虚拟化环境
	$source venv/bin/activate
命令提示符前增加了(venv)前缀，如(venv)xixitalk@ubuntu:~/mytwip$ 。

5、使用pip install安装Flask_Twip,自动会安装所有依赖。gunicorn需要单独安装。用$pip freeze看依赖安装情况。
	$pip install Flask_Twip
	$pip install gunicorn
	$pip freeze
依赖安装完整后，生成requirements.txt。
	$pip freeze > requirements.txt

6、从<https://github.com/yegle/flask_twip/tree/master/examples/heroku>下载Procfile、app.py到mytwip目录，从<https://github.com/yegle/flask_twip/tree/master/examples>下载settings-example.py文件到mytwip目录，并重命名为settings.py。
修改settings.py里的TWITTER_CONSUMER_KEY和TWITTER_CONSUMER_SECRET值为准备工作第2步twitter API创建的值。  
可以在<https://github.com/yegle/flask_twip/tree/master/examples>页面点击右边中间的Downloads连接下载，蓝色History上面。把上面提到的三个文件挑出来放到步骤2创建的mytwip目录里。
用ls命令查看，现在mytwip有如下几个文件：
	(venv)xixitalk@ubuntu:~/mytwip$ ls
	requirements.txt Procfile venv app.py  settings.py

7、Procfile设置跳过，上步已经下载。

8、$foreman start跳过，这里是本地试运行。

9、在mytwip目录下建一个.gitignore文件，表示venv目录和pyc文件不上传git服务器。
	venv
	*.pyc

10、初始化mytwip目录的git环境。
	$git init 
	$git add .
	$git commit -m "init" 
11、创建应用,APPNAME为自定义名字。
	$heroku create APPNAME 
如果创建后想修改应用名字在mytwip目录用下面命令再修改，newname是自定义新应用名称。
	$heroku apps:rename newname

12、将应用上传到heroku的git服务器，应用自动运行。
	$git push heroku master 

13、浏览器访问https://APPNAME.herokuapp.com/twip/进行O模式认证,认证完API格式为：
	https://APPNAME.herokuapp.com/twip/TWITTER/KEY/
其中TWITTER为你的twitter用户名，KEY就是该API的key，API地址要保密,任何人通过这个地址都能访问你的twitter帐号。

14、如果https://APPNAME.herokuapp.com/twip/访问不正常，可以通过heroku的logs分析定位。
	$heroku logs

这样搭建全部完成，可以在支持twip O模式的客户端使用了，注意将API保持https方式，不然会被墙的。
	https://APPNAME.herokuapp.com/twip/TWITTER/KEY/
