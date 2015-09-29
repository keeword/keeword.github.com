---
layout: post
title: x86 内存管理机制发展
category: 
tags: [x86, memory management]
---

本文主要讲述 x86 体系从 8086 到 80386 的内存管理机制。

内存管理机制主要解决 `内存寻址` 、 `内存保护` 、 `内存缓存` 等问题。

## 直接寻址

在内存抽象模型还未出现的早期，内存地址只有物理地址这一概念，
程序都是直接访问物理地址，可以说根本就没有内存管理机制。
所以计算机每次只能运行一个程序。

## 8086

intel 8086 是 16 位的 CPU ，有 16 位的寄存器、 16 位的内部和外部数据总线、 20 位的外部地址总线。
20 位的外部地址总线理论上能寻址 $2^{20} B = 1 M$ 大小的内存，
而用 16 位的寄存器保存内存地址的话，只能寻址 $2^{16} B = 64 K$ 大小的内存，
为了解决这个矛盾， intel 引入了 ‘逻辑地址’ 的概念，采用 ‘段寻址’ 的方式把
‘逻辑地址’ 映射到 ‘物理地址’ 。

为了实现段机制， 8086 里引入了 4 个寄存器：
CS(code segment)、DS(data segment)、SS(stack segment)、ES(extra segment) ，
分别用于保存程序中各段的基址地址。
逻辑地址通常以 `[selector:offset]` 的形式表示，它与物理地址的转换关系如下：
$physicalsadrress = selector \times 16 + offset$ 。

在实际程序中，假设 `DS = 0x1000` 、 `SI = 0xFFFF` ，那么 `MOV AL, DS:[DI]`
的功能就是复制内存 $0x1000 \times 16 + 0xFFFF = 0x1FFFF$ 处的一个字节复制到 `AL` 中。

理论上，段机制的最大寻址空间为 $0xFFFF \times 16 + 0xFFFF = 0x10FFEF = 1M + 64K - 16B$ ，
但由于 20 位的外部总线只能寻址 1M 大小内存，计算超出 1M 大小的地址空间(0x100000 - 0x10FFEF)时，
结果会对 1M 求余，这种技术有时又叫做 `wrap-around` 。

段寻址实际上也存在不少的问题： 

+ 段大小受限：每个段最大为 64K ，如果数据或程序大于这个值就必须分为两部分。 

+ 同一物理地址有多种表达方式：例如 0x01C0:0x0000 和 0x0000:0x1C00 所表示的物理地址都是 0x01C00 。 

+ 没有保护机制：无须任何特权就能够改变段寄存器的值，程序能够随心所欲地访问别的程序的代码和数据。 

## 80286

80286 采取了一种与 8086 完全不同的内存管理机制，为了以示区别，把 8086 所使用的方法称为实模式(real mode) 
，而另外创造的方式称为保护模式(protected mode)。
通常，80286 启动时处于实模式，然后通过指令转移到保护模式。 80286 的实模式是为了向下兼容的一种举措。

### Virtual Addresses

80286 把外部地址总线增加到 24 位，能够寻址 $2^{24} = 16M$ 大小的内存。

8086 中 `[selector:offset]` 形式能寻址 1M 内存是因为 $selector \times 16$ ，
即左移了 4 位，所以能够算出 20 位的地址。按这种方法，是否 selector 再左移 4 位，
共左移 8 位，就能寻址 24 位的地址呢?理论上是可以的，但 80286 采取的是另外一种方法。

从上面可以看出， selector 起到的是一种类似 *基址* 的作用，所以 80286 直接用一个数据结构
来保存段的 **基址** 和 **大小** ，称之为 *Descriptor* ，再用一个叫 *Descriptor Table* 的表把
每段的 descriptor 保存在内存中。寻址时，段寄存器中存放 descriptor 在 descriptor table
中的 *Index* 序号 ，然后根据 index 把段基址读取出来，与 offset 相加，得到内存的物理地址。
过程如下图所示：

![虚拟到物理地址转换](/img/virtual_to_physical_address_translation.png)

如果每次访问内存都需要先访问一次 descriptor table 来获取段基址，显然会使效率大大降低，
因此， 80286 每个段寄存器都有一部分 *Hidden Descriptor Cache* ，用于缓存对应段的 descriptor ，
使之不用再访问 descriptor table 。段寄存器的格式如下图所示：

![段寄存器](/img/segment_register.png)

每当段寄存器加载新的 selector 时， CPU 就会自动从 descriptor table 中读取 descriptor ，
然后放到后 48 位的缓存里。

descriptor 分为很多种类，其中用于段寻址的有 *Code Segment Descriptor* 和 *Data Segment Descriptor* ，
分别是代码段和数据段的描述符。格式如下图所示：

![代码或数据段描述符](/img/code_or_data_segment_descriptor.png)

由图中可见，除了基址和大小外，每个 descriptor 还有很多属性，这些属性将在下文讲述。
图中 base 为 24 位，与外部地址总线位数一致，limit 为 16 位，每段的大小由该值决定，
即每段是不定大小的，但最大值与 8086 一样，都是 64K 。

由于每个 descriptor 的大小为 8 byte ，每个 selector 的最低 3 位都必然为零，
所以，可把这最低的 3 位用于其他用途，而索引只用 13 位就足够了，下面是 selector 的格式：

![段选择器格式](/img/format_of_the_segment_selector_component.png)

可见， index 的大小确实只有 13 位，所以 descriptor table 最多只能保存 $2^{13} = 8192$ 个 descriptor 。

为了增加 descriptor 的最大个数以及把不同任务的 descriptor 独立开来， 80286 把 descriptor table 分为两类，
分别是 *GDT(Global Descriptor Table)* 和 *LDT(Local Descriptor Table)* 。
GDT 在所有任务中共享，而 LDT 只由一个任务拥有或由一组相关的任务共享。

为了保存这两类表的地址， 80286 新增了两个寄存器 *GDTR* 和 *LDTR* 。

![系统地址寄存器](/img/system_address_register.png)

由于 GDT 只有一个，所以只用一个寄存器长期保存就可以。但 LDT 是每个任务都有一个，
不能只用一个寄存器保存，所以把 LDT 的内存空间也用一个 descriptor 来描述，
然后保存在 GDT 里。当要访问的段的 descriptor 保存在 LDT 里时，
就先需要访问 GDT 获得 LDT 的地址，在由 descriptor 获得段的地址。
如下图所示：

![LDT描述符](/img/ldt_descriptor.png)

跟段寄存器一样，为了提高效率， LDTR 同样有自动装载的缓存部分。

在访问过程中， CPU 是根据 selector 低 3 位中的 *TI* 字段判断应该从 GDT 还是 LDT 获取 descriptor 。

![段描述子访问类型](/img/segment_descriptor_access_bytes.png)

特殊描述子的格式如下：

![特殊描述子](/img/system_segment_descriptor_and_gate_descriptor.png)


