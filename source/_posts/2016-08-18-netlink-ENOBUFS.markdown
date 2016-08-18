---
layout: post
title: "netlink遇到ENOBUFS错误"
date: 2016-08-18 08:49:42
comments: true
mathjax: false
categories: linux
---

一个场景：USB插拔的时候内核会通过netlink广播到user层，多个应用接收这个消息。但是出现了errno 105错误，105错误是：`No buffer space available`

<!--more-->

经过内核代码分析，`af_netlink.c`里`netlink_broadcast_deliver`函数返回-1才会触发`ENOBUFS`流程。加`printk`和`panic`复现问题(因为嵌入式开发环境抓panic死机现场分析和串口log都太方便了)。

```
static int netlink_broadcast_deliver(struct sock *sk, struct sk_buff *skb)
{
	struct netlink_sock *nlk = nlk_sk(sk);

	if (atomic_read(&sk->sk_rmem_alloc) <= sk->sk_rcvbuf &&
	    !test_bit(0, &nlk->state)) {
		skb_set_owner_r(skb, sk);
		__netlink_sendskb(sk, skb);
		return atomic_read(&sk->sk_rmem_alloc) > (sk->sk_rcvbuf >> 1);
	}
	printk("[testcode]netlink sk_rmem_alloc:%x sk_rcvbuf:%x \n",atomic_read(&sk->sk_rmem_alloc),sk->sk_rcvbuf);
	panic("[testcode]netlink broadcast panic\n");
	return -1;
}
```

抓取的串口log如下显示`sk_rcvbuf`确实小于`sk_rmem_alloc`了，没有空间了。

> [   18.618473] [testcode]netlink sk_rmem_alloc:b00 sk_rcvbuf:8b8  [  
> 18.623727] Kernel panic - not syncing: [testcode]netlink broadcast panic

对比发现死机现场里的`kobject_uevent_env`函数里的`uevent_sock`变量里`sk_sndbuf`和`sk_rcvbuf`都是163840（160K）。而`netlink_broadcast_deliver`里sock是8b8（2232）。很明显netlink接收socket里的sock比内核驱动的sock接收buf差距太大了。

内核sock.c里`sock_init_data`函数里进行sock初始化，初始化成`sysctl_rmem_default`。`sysctl_rmem_default`是个全局变量，导出的panic现场看值就是163840。

> sk->sk_rcvbuf		=	sysctl_rmem_default;
> sk->sk_sndbuf		=	sysctl_wmem_default;

看应用netlink的接收，果然用`setsockopt`修改了`RCVBUF`。

```
    const int buffersize = 1024;  
    int ret;  

    struct sockaddr_nl snl;  
    bzero(&snl, sizeof(struct sockaddr_nl));  
    snl.nl_family = AF_NETLINK;  
    snl.nl_pid = getpid();  
    snl.nl_groups = 1;  

    int s = socket(PF_NETLINK, SOCK_DGRAM, NETLINK_KOBJECT_UEVENT);  
    if (s == -1)   
    {  
        perror("socket");  
        return -1;  
    }  
    setsockopt(s, SOL_SOCKET, SO_RCVBUF, &buffersize, sizeof(buffersize));  
```

C库的`setsockopt`函数会通过系统调用进入到内核`sock.c`文件里的`sock_setsockopt`函数。`SOCK_MIN_RCVBUF`就是2232。很明显应用`setsockopt`的`buffersize`是1024，乘以2还小于`SOCK_MIN_RCVBUF`，所以`sk_rcvbuf`就变成`SOCK_MIN_RCVBUF`。

```
	case SO_RCVBUF:
	    if (val > sysctl_rmem_max)
			val = sysctl_rmem_max;
		if ((val * 2) < SOCK_MIN_RCVBUF)
			sk->sk_rcvbuf = SOCK_MIN_RCVBUF;
		else
			sk->sk_rcvbuf = val * 2;
		break;
```

解决办法：删除应用代码里的`setsockopt`语句,这样`sk_rcvbuf`默认就是160K，或者用`setsockopt`设置合适的大小。

通过Google发现，网络上好多netlink实例都用了`setsockopt`设置了1024的buffer大小。应用这个代码应该是从网上抄来的。


