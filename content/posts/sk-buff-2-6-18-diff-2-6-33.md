---
title: 结构体sk_buff在Linux内核2.6.18与2.6.33中的区别
tags:
  - Driver
  - INUX_VERSION_CODE
  - kernel
  - KERNEL_VERSION
  - linux
  - sk_buff
id: 476
categories:
  - linux
date: 2013-09-06T17:28:58+08:00
---

在Linux 2.6.33.6中，源文件在：/usr/src/kernels/2.6.33.6/include/linux/skbuff.h

# struct sk_buff在2.6.18中的定义：
```c
struct sk_buff {
        /* These two members must be first. */
        struct sk_buff          *next;
        struct sk_buff          *prev;

        struct sock             *sk;
        struct skb_timeval      tstamp;
        struct net_device       *dev;
        struct net_device       *input_dev;

        union {
                struct tcphdr   *th;
                struct udphdr   *uh;
                struct icmphdr  *icmph;
                struct igmphdr  *igmph;
                struct iphdr    *ipiph;
                struct ipv6hdr  *ipv6h;
                unsigned char   *raw;
        } h;

        union {
                struct iphdr    *iph;
                struct ipv6hdr  *ipv6h;
                struct arphdr   *arph;
                unsigned char   *raw;
        } nh;

        union {
                unsigned char   *raw;
        } mac;

        struct  dst_entry       *dst;
        struct  sec_path        *sp;
        /*
         * This is the control buffer. It is free to use for every
         * layer. Please put your private variables there. If you
         * want to keep them across layers you have to do a skb_clone()
         * first. This is owned by whoever has the skb queued ATM.
         */
        char                    cb[48];

        unsigned int            len,
                                data_len,
                                mac_len,
                                csum;
        __u32                   priority;
        __u8                    local_df:1,
                                cloned:1,
                                ip_summed:2,
                                nohdr:1,
                                nfctinfo:3;
        __u8                    pkt_type:3,
                                fclone:2,
#ifndef CONFIG_XEN
                                ipvs_property:1;
#else
                                ipvs_property:1,
                                proto_data_valid:1,
                                proto_csum_blank:1;
#endif
        __be16                  protocol;

        void                    (*destructor)(struct sk_buff *skb);
#ifdef CONFIG_NETFILTER
        struct nf_conntrack     *nfct;
#if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
       struct sk_buff          *nfct_reasm;
#endif
#ifdef CONFIG_BRIDGE_NETFILTER
        struct nf_bridge_info   *nf_bridge;
#endif
        __u32                   nfmark;
#endif /* CONFIG_NETFILTER */
#ifdef CONFIG_NET_SCHED
        __u16                   tc_index;       /* traffic control index */
#ifdef CONFIG_NET_CLS_ACT
        __u16                   tc_verd;        /* traffic control verdict */
#endif
#endif
#ifdef CONFIG_NET_DMA
        dma_cookie_t            dma_cookie;
#endif
#ifdef CONFIG_NETWORK_SECMARK
        __u32                   secmark;
#endif

        /* These elements must be at the end, see alloc_skb() for details.  */
        unsigned int            truesize;
        atomic_t                users;
        unsigned char           *head,
                                *data,
                                *tail,
                                *end;
        /* Extra stuff at the end to avoid breaking abi */
#ifndef __GENKSYMS__
        int                      peeked;
#endif
};
```

# struct sk_buff在2.6.33中的定义：
```c
struct sk_buff {
        /* These two members must be first. */
        struct sk_buff          *next;
        struct sk_buff          *prev;

        ktime_t                 tstamp;

        struct sock             *sk;
        struct net_device       *dev;

        /*
         * This is the control buffer. It is free to use for every
         * layer. Please put your private variables there. If you
         * want to keep them across layers you have to do a skb_clone()
         * first. This is owned by whoever has the skb queued ATM.
         */
        char                    cb[48] __aligned(8);

        unsigned long           _skb_dst;
#ifdef CONFIG_XFRM
        struct  sec_path        *sp;
#endif
        unsigned int            len,
                                data_len;
        __u16                   mac_len,
                                hdr_len;
        union {
                __wsum          csum;
                struct {
                        __u16   csum_start;
                        __u16   csum_offset;
                };
        };
        __u32                   priority;
        kmemcheck_bitfield_begin(flags1);
        __u8                    local_df:1,
                                cloned:1,
                                ip_summed:2,
                                nohdr:1,
                                nfctinfo:3;
        __u8                    pkt_type:3,
                                fclone:2,
                                ipvs_property:1,
                                peeked:1,
                                nf_trace:1;
        __be16                  protocol:16;
        kmemcheck_bitfield_end(flags1);

        void                    (*destructor)(struct sk_buff *skb);
#if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
        struct nf_conntrack     *nfct;
        struct sk_buff          *nfct_reasm;
#endif
#ifdef CONFIG_BRIDGE_NETFILTER
        struct nf_bridge_info   *nf_bridge;
#endif

        int                     skb_iif;
#ifdef CONFIG_NET_SCHED
        __u16                   tc_index;       /* traffic control index */
#ifdef CONFIG_NET_CLS_ACT
        __u16                   tc_verd;        /* traffic control verdict */
#endif
#endif

        kmemcheck_bitfield_begin(flags2);
        __u16                   queue_mapping:16;
#ifdef CONFIG_IPV6_NDISC_NODETYPE
        __u8                    ndisc_nodetype:2;
#endif
        kmemcheck_bitfield_end(flags2);

        /* 0/14 bit hole */

#ifdef CONFIG_NET_DMA
        dma_cookie_t            dma_cookie;
#endif
#ifdef CONFIG_NETWORK_SECMARK
        __u32                   secmark;
#endif
        union {
                __u32           mark;
                __u32           dropcount;
        };

        __u16                   vlan_tci;

        sk_buff_data_t          transport_header;
        sk_buff_data_t          network_header;
        sk_buff_data_t          mac_header;
        /* These elements must be at the end, see alloc_skb() for details.  */
        sk_buff_data_t          tail;
        sk_buff_data_t          end;
        unsigned char           *head,
                                *data;
        unsigned int            truesize;
        atomic_t                users;
};
```

有了以上定义的话，我们就可以做类似如下定义来使我们的驱动支持多内核了：
```c
struct sk_buff *new_skb;
#if LINUX_VERSION_CODE <= KERNEL_VERSION(2,6,18)
new_skb->mac.raw = (unsigned char *)new_eth_p;
#else
new_skb->mac_header = (unsigned char *)new_eth_p;
#endif
```

参考：[http://www.linuxquestions.org/questions/linux-kernel-70/struct-sk_buff-differs-in-2-6-18-and-2-6-33-kernel-882507/](http://www.linuxquestions.org/questions/linux-kernel-70/struct-sk_buff-differs-in-2-6-18-and-2-6-33-kernel-882507/)
