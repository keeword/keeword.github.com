---
layout: post
title: mooc：图像视频处理 week 2 笔记
category: mooc
tags: [mooc, 图像处理]
---

这是图像视频处理课程 week 2 的笔记.
本周主要讲图像视频压缩.

## Vedio 1 - The why and how of compression

Vedio 1 主要讲了图像压缩的原理.

各种图像和视频之所以能够被压缩,是因为它们存在信息冗余.
有种类的冗余,例如图像只有几种图像;有空间的冗余,图像上一大片的空间都是同一种颜色;
还有精度的冗余,例如灰度127和灰度128可以当作同一种.

目前比较常用的压缩标准有 Jpeg 家族和 Mpeg 家族.

以 Jpeg 为例,原始图像会经过以下过程得到压缩文件:
原始图像->分块->变换(transform)->量化(quantizer)->符号编码(symbol encoder)->压缩图像

经下面逆过程得到解压文件
压缩文件->解符号编码(symbol decoder)->逆变换(inverse transform)->合并块->解压文件

## Vedio 2 - Huffman coding

霍夫曼编码是符号编码过程中常用的编码方式.

它是一种无前缀(prefix-free)的变长编码方式,
并且能达到最短的编码长度.

无前缀是指编码后,每个结果都不会是其它结果的前缀,
所以译码器能够准确译码.

## Vedio 3 - Jpeg's 8x8 blocks

在 Jpeg 标准中，并不是对整个图像进行变换，
而是先将图像分为很多个 $8 \times 8$ 大小的块，再对每个块进行变换。

对于彩色图像，每个像素由RGB 3种颜色组成，
不过，Jpeg 并不是分别对RGB通道分块变换，而是先把颜色从RGB空间
变换到YCbCr空间，再处理。

把图像从RGB空间映射到YCbCr空间只需乘上一个 $3 \times 3$ 的矩阵。

$$
\begin{bmatrix}
Y \\
Cb \\
Cr
\end{bmatrix}=

\begin{bmatrix}
0.299 & 0.587 & 0.114 \\
-0.169 & -0.331 & 0.501 \\
0.500 & -0.419 & -0.081
\end{bmatrix}\times
\begin{bmatrix}
R \\
G \\
B
\end{bmatrix}
$$
