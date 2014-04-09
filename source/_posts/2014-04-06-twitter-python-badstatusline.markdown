---
layout: post
title: "twitter-python BadStatusLine错误"
date: 2014-04-06 20:20:25
comments: true
mathjax: false
categories: tech
---
事情是这样的：我用[twitter-python](https://github.com/bear/python-twitter)在本地运行， 抓取一个推号的homeline， 抓取后sleep两分钟再抓取， 不停的循环｡从昨天早上开始， 程序出现如下错误， 且每次都是这个错误｡获得推友收藏列表和fo人的api返回都是正常的，就是REST的api出这种错误。

<!--more-->

```
Traceback (most recent call last):
  File "hottweetdo.py", line 183, in <module>
    main()
  File "hottweetdo.py", line 126, in main
    status = api2.GetHomeTimeline(since_id=since_id1,count=200)
  File "/media/westdata/read/python-twitter-master/twitter/api.py", line 541, in GetHomeTimeline
    json = self._RequestUrl(url, 'GET', data=parameters)
  File "/media/westdata/read/python-twitter-master/twitter/api.py", line 3383, in _RequestUrl
    timeout=self._requests_timeout
  File "/usr/local/lib/python2.7/dist-packages/requests/api.py", line 55, in get
    return request('get', url, **kwargs)
  File "/usr/local/lib/python2.7/dist-packages/requests/api.py", line 44, in request
    return session.request(method=method, url=url, **kwargs)
  File "/usr/local/lib/python2.7/dist-packages/requests/sessions.py", line 383, in request
    resp = self.send(prep, **send_kwargs)
  File "/usr/local/lib/python2.7/dist-packages/requests/sessions.py", line 486, in send
    r = adapter.send(request, **kwargs)
  File "/usr/local/lib/python2.7/dist-packages/requests/adapters.py", line 382, in send
    raise ConnectionError(e)
requests.exceptions.ConnectionError: HTTPSConnectionPool(host='api.twitter.com', port=443): Max retries exceeded with url: /1.1/statuses/home_timeline.json?count=200 (Caused by <class 'httplib.BadStatusLine'>: '')
```

代码很简单，就是用四个key生成一个api对象，然后直接调用`GetHomeTimeline`

我google之后， 看到很多类似的分析， 但是我都尝试了， 还是没有解决｡尝试罗列如下｡

### bad proxy server
[有人说是bad proxy server](https://stackoverflow.com/questions/18478013/python-requests-exceptions-connectionerror-max-retries-exceeded-witth-url),程序确实使用代理了，代理是shadowsocks+polipo， 代理设置在环境变量HTTP_PROXY和HTTPS_PROXY｡我尝试了不同地区的代理， 甚至切换了不同卖家的代理， 依然出错｡

### DNS问题
尝试了不同的DNS server不起作用

###  httplib2 0.8的问题， 使用0.7.7
不起作用

###  twitter API的问题
twitter-python的一个[issues解答](https://github.com/bear/python-twitter/issues/131)说是twitter API诡异的问题｡问题是我只能等待吗？

### 设置maxretries为5
<https://stackoverflow.com/questions/15431044/can-i-set-max-retries-for-requests-request/15431343#15431343> 不起作用

### 设置requests的session keep-alive为False
不起作用

请python高手或者twitter api高手指点迷津，可以直接在下面留言，或者推上@我。

## [更新后记]

目前解决的办法：1、重新新建一个API，用新的consumer_key和access token；2、更换代理，换用tor+polipo，tor的IP变化比较频繁。经过上面操作，错误暂时不再出现了。

问题可能原因：应该是twitter服务器认为API滥用了，当get提交给服务器后，twitter服务器只返回了ACK，接下来没有返回任何数据，所以httplib判断为BadStatusLine，因为没有数据，所以连status号都没有。

## [再次更新后记]
每天生成HTMLpush到github后自动发推又出现BadStatusLine了，所幸不是`GetHomeTimeline`。

```
requests.exceptions.ConnectionError: HTTPSConnectionPool(host='api.twitter.com', port=443): Max retries exceeded with url: /1.1/statuses/update.json (Caused by <class 'httplib.BadStatusLine'>: '')
```
