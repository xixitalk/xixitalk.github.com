---
layout: post
title: "linux kernel全局变量contig_page_data含义"
date: 2016-07-13 09:03:20
comments: true
mathjax: false
categories: linux
---

`contig_page_data`是内核内存管理一个很重要的变量。

<!--more-->

平台：uClinux 内核版本号：linux-3.4.12

![enter image description here](http://7bv9id.com1.z0.glb.clouddn.com/contig_page_data.png)

`watermark`是3840 4800 5760对应 watermark[min] watermark[low] watermark[high]，这里是page数，一个page 4K，所以`watermark`对应`min_free_kbytes`是3840*4K是15360（15M），符合配置`echo 15360 > /proc/sys/vm/min_free_kbytes`。其他计算如下。

```
 watermark[min] = min_free_kbytes换算为page单位即可
 watermark[low] = watermark[min] * 5 / 4
 watermark[high] = watermark[min] * 3 / 2
```

在系统空闲内存低于 watermark[low]时，开始启动内核线程kswapd进行内存回收，直到该zone的空闲内存数量达到watermark[high]后停止回收。如果上层申请内存的速度太快，导致空闲内存降至watermark[min]后，内核就会进行direct reclaim（直接回收），即直接在应用程序的进程上下文中进行回收，再用回收上来的空闲页满足内存申请，因此实际会阻塞应用程序，带来一定的响应延迟，而且可能会触发系统OOM。这是因为watermark[min]以下的内存属于系统的自留内存，用以满足特殊使用，所以不会给用户态的普通申请来用。

free_area里order是0到10，对应4K到4M。free_list[n]是双向链表，只有next的next指向同样的节点才是表示链表为空。（双向链表，很明显如果只有两个节点，next和prev都是另一个节点）。和`cat /proc/pagetypeinfo`信息一致。

`contig_page_data`里的`vm_stat`对应mmzone.h里`zone_stat_item`枚举。另外本身有一个内核全局变量`vm_stat`，值和`contig_page_data`的这个`vm_stat`一样的。这个参数可以对照着`/proc/meminfo`一起看。

page_alloc.c  show_free_areas()

```
for (type = 0; type < MIGRATE_TYPES; type++) {
				if (!list_empty(&area->free_list[type]))
					types[order] |= 1 << type;
			}
```

mmzone.h里看出MIGRATE_TYPES为4。**0是UNMOVABLE区，1是RECLAIMABLE可回收区，2是可MOVABLE区，3是PCPTYPES或者RESERVE保留区**。

```
enum {
	MIGRATE_UNMOVABLE,
	MIGRATE_RECLAIMABLE,
	MIGRATE_MOVABLE,
	MIGRATE_PCPTYPES,	/* the number of types on the pcp lists */
	MIGRATE_RESERVE = MIGRATE_PCPTYPES,
#ifdef CONFIG_CMA
	/*
	 * MIGRATE_CMA migration type is designed to mimic the way
	 * ZONE_MOVABLE works.  Only movable pages can be allocated
	 * from MIGRATE_CMA pageblocks and page allocator never
	 * implicitly change migration type of MIGRATE_CMA pageblock.
	 *
	 * The way to use it is to change migratetype of a range of
	 * pageblocks to MIGRATE_CMA which can be done by
	 * __free_pageblock_cma() function.  What is important though
	 * is that a range of pageblocks must be aligned to
	 * MAX_ORDER_NR_PAGES should biggest page be bigger then
	 * a single pageblock.
	 */
	MIGRATE_CMA,
#endif
#ifdef CONFIG_MEMORY_ISOLATION
	MIGRATE_ISOLATE,	/* can't allocate from here */
#endif
	MIGRATE_TYPES
};
```

```
enum zone_stat_item {
	/* First 128 byte cacheline (assuming 64 bit words) */
	NR_FREE_PAGES,
	NR_ALLOC_BATCH,
	NR_LRU_BASE,
	NR_INACTIVE_ANON = NR_LRU_BASE, /* must match order of LRU_[IN]ACTIVE */
	NR_ACTIVE_ANON,		/*  "     "     "   "       "         */
	NR_INACTIVE_FILE,	/*  "     "     "   "       "         */
	NR_ACTIVE_FILE,		/*  "     "     "   "       "         */
	NR_UNEVICTABLE,		/*  "     "     "   "       "         */
	NR_MLOCK,		/* mlock()ed pages found and moved off LRU */
	NR_ANON_PAGES,	/* Mapped anonymous pages */
	NR_FILE_MAPPED,	/* pagecache pages mapped into pagetables.
			   only modified from process context */
	NR_FILE_PAGES,
	NR_FILE_DIRTY,
	NR_WRITEBACK,
	NR_SLAB_RECLAIMABLE,
	NR_SLAB_UNRECLAIMABLE,
	NR_PAGETABLE,		/* used for pagetables */
	NR_KERNEL_STACK,
	/* Second 128 byte cacheline */
	NR_UNSTABLE_NFS,	/* NFS unstable pages */
	NR_BOUNCE,
	NR_VMSCAN_WRITE,
	NR_VMSCAN_IMMEDIATE,	/* Prioritise for reclaim when writeback ends */
	NR_WRITEBACK_TEMP,	/* Writeback using temporary buffers */
	NR_ISOLATED_ANON,	/* Temporary isolated pages from anon lru */
	NR_ISOLATED_FILE,	/* Temporary isolated pages from file lru */
	NR_SHMEM,		/* shmem pages (included tmpfs/GEM pages) */
	NR_DIRTIED,		/* page dirtyings since bootup */
	NR_WRITTEN,		/* page writings since bootup */
#ifdef CONFIG_NUMA
	NUMA_HIT,		/* allocated in intended node */
	NUMA_MISS,		/* allocated in non intended node */
	NUMA_FOREIGN,		/* was intended here, hit elsewhere */
	NUMA_INTERLEAVE_HIT,	/* interleaver preferred this zone */
	NUMA_LOCAL,		/* allocation from local node */
	NUMA_OTHER,		/* allocation from other node */
#endif
	NR_ANON_TRANSPARENT_HUGEPAGES,
	NR_FREE_CMA_PAGES,
	NR_VM_ZONE_STAT_ITEMS };
```

#### 参考文章

<http://kernel.taobao.org/index.php?title=Kernel_Documents/mm_sysctl>
