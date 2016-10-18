---
layout: post
title: "stunnel verify选项配置"
date: 2016-10-18 09:12:59
comments: true
mathjax: false
categories: tech stunnel
styles: data-table
---

verify配置认证方式，取值0 1 2 3 4。

0 - request and ignore peer cert  
1 - only validate peer cert if present  
2 - always require a valid peer cert  
3 - verify peer with locally installed cert  
4 - ignore CA chain and only verify peer cert  

<!--more-->

## stunnel5 verify配置

代码版本`stunnel 5.36`  文件`option.c`  函数`parse_service_option()`

```
    case CMD_EXEC:
        if(strcasecmp(opt, "verify"))
            break;
        {
            char *tmp_str;
            int tmp_int=(int)strtol(arg, &tmp_str, 10);
            if(tmp_str==arg || *tmp_str || tmp_int<0 || tmp_int>4)
                return "Bad verify level";
            section->option.request_cert=1;
            section->option.require_cert=(tmp_int>=2);
            section->option.verify_chain=(tmp_int>=1 && tmp_int<=3);
            section->option.verify_peer=(tmp_int>=3);
        }
        return NULL; /* OK */
```

`verify`选项合法值为：0  1 2 3 4

|取值|request_cert|require_cert|verify_chain|verify_peer|
|----|----|----|----|----|
| 0 | √ | × | × | × |
| 1 | √ | × | √ | × |
| 2 | √ | √ | √ | × |
| 3 | √ | √ | √ | √ |
| 4 | √ | √ | × | √ |

conf配置文件里，`requireCert`可以修改require_cert，`verifyChain`可以修改`verify_chain`，`verifyPeer`可以修改`verify_peer`。

根据上表可得出，stunnel5里`verify = 3`最全面。

我自己服务器端是`verify = 3`，客户端用的是`verify = 4`。

```
verify = 4
verifyChain = no
verifyPeer = yes
```

如果是stunnel4，配置`verify = 3`即可，点对点连接推荐3。

