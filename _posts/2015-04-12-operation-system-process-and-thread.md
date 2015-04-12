---
layout: post
title: 现代操作系统笔记：进程与线程
category: os
tags: [os, process, thread]
---

# 进程

*进程(process)*是程序在系统中的一个运行实例。

## 进程的创建

有四种原因会导致进程的创建：

1. 系统初始化

2. 某进程通过*系统调用(system call)*创建子进程

3. 用户创建新进程

4. 一个批处理作业的初始化
