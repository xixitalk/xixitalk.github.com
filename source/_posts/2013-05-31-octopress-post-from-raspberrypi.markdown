---
layout: post
title: "用浏览器发布博客到octopress"
date: 2013-05-31 19:57:25
comments: true
categories: octopress raspberrypi
---
### 目标
用网页发布到octopress，这样手机、iPad、办公环境都可以通过浏览器发octopress博文了。

### 设想
浏览器网页编写，保存在GAE上，raspberry pi上用shell定时检查抓取，下载到octopress的_posts目录下，调用`rake`进行发布，调用`git push`上传markdown源文件到github。

### 硬件环境
需要一个全天运行的电脑（我的是树莓派），用于每10分钟进行检查是否服务器(GAE)上新的博文，并rake生成html格式的博文上传到github。

### 软件环境
树莓派上安装octopress所需的所有工具，生成一个不要密码的SSH密钥，把公钥上传到github上，这样`rake deploy`就不会提示输入密码了。

### GAE网页设计
#### 面向shell的接口
`/md/getnewpost?action=flag`  用于判断GAE上是否有新博文，1表示有新博文，0表示没有新博文   
`/md/getnewpost?action=cleanflag` 将GAE上博文标志1变成0，用于`rake deploy`成功后使用  

`/md/getnewpost?action=getfilename` 获得新博文的文件名  
`/md/getnewpost?action=getfilemd5` 获得新博文的md5，用于检验下载的完整性  
`/md/getnewpost?action=getfilecontent` 获得新博文的内容  

#### 面向用户的接口
`/md/getnewpost?action=new` 用户要新建博文，浏览器访问该地址  
`/md/getnewpost?action=edit` 用户要重新编辑博文，浏览器访问该地址  

#### 用户不需要关心的接口
`/md/getnewpost?action=save` edit之后保存按钮执行本接口  
`/md/getnewpost?action=publish` save后publish按钮执行本接口，将博文标志变成1  

### shell检查

1. 先用`action=flag`获得博文标志。如果是0，GAE上无新博文，直接退出；如果是1，继续。  
2. 获得新博文的文件名、md5、文件内容，用本地命令md5sum计算新博文的md5，与`action=getfilemd5`获得的md5进行比较。如果不一致，抓取博文出错退出；如果一致，抓取博文正确。
3. 将新博文拷贝到octopress到source/_posts目录下，调用`rake generate && rake deploy`进行HTML博文生成和发布，调用`git push`将markdown博文上传到github服务器。
4. 调用`action=cleanflag`将GAE博文标志变成0，表示GAE上新博文已经成功发布。

可能是`rake generate`和`rake deploy`时间比较长，cron 10分钟检查不好使，发现没有效果，最后用后台shell `while` 循环检查，执行一次后 `sleep` 600秒这样才正常。

updated from my iPad with Safari
