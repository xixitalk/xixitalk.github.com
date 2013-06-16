---
layout: post
title: "搭建带代理的奶瓶腿"
date: 2013-06-15 21:39:29
comments: true
mathjax: true
categories: twitter proxy
---

今天证实了一个猜想：因为奶瓶腿连接twitter API是通过cURL模块，而cURL本身支持proxy，所以在国内可以搭建奶瓶腿，只要加上代理就可以正常使用。代理可以是shadowsocks转换的socks代理，也可以是再通过polipo进一步转化的HTTP代理。

<!--more-->

### 下载奶瓶腿代码

把奶瓶腿的代码放在apache的浏览的根目录：

```
git clone git@github.com:netputer/netputweets.git
```

可以将目录netputweets修改为t。

### 安装好奶瓶腿所要的环境

apache、php5+、cURL、URL Rewrite等，这部分略过。

### 添加代理

假设代理是：HTTP 192.168.1.106:8118,其他格式代理相应修改。  
修改img.php、class.upload.php、twitter.php、handler.php文件里在所有执行`curl_exec`函数前添加：

```
curl_setopt($ch, CURLOPT_PROXY, '192.168.1.106:8118');
```

`setup.php`文件里的`curl_exec`前不要修改。

### 安装奶瓶腿

浏览器里访问http://xxxxx.org/t/setup.php，进行奶瓶腿安装。安装后正常进行twitter帐号关联。

![netputweets](https://pbs.twimg.com/media/BMzloh6CMAEonlF.png:large)

### 推文两次base64编码防止敏感词过滤

推文进行base64两次编码，客户端浏览器进行base64两次解码，这样可以防止敏感词过滤。缺点是按照base64的特点两次编码推文字节会变成原来的$$ \frac{16}{9} $$。


