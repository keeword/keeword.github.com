#!/bin/bash

src=$1
dst=$2
if [ ! `which pandoc` ];then
    echo "Can't find pandoc command"
    exit
fi

# pandoc选项
PANDOC_FLAG=" --toc"                                            # 自动生成目录
PANDOC_FLAG+=" --css=res/style.css"                                 # 指定css样式文件.
PANDOC_FLAG+=" --template=res/pandoctpl.html"                       # pandoc模板.
PANDOC_FLAG+=" --tab-stop=4"
PANDOC_FLAG+=" --include-before-body    res/header.html"            # 导航
PANDOC_FLAG+=" --include-after-body     res/footer.html"            # 页脚

# 预处理
title=$(sed -ne '1s/#\(.*\)$/\1/p' $src)        # 文章标题
date=$(date '+%Y年%m月%d日%H时')                # 文章时间
sed -i -e '1s/#\(.*\)/<!-- \1 -->/'     $src    # 暂时删除文章标题

PANDOC_FLAG+=" --variable title=$title"                         # 文章标题
PANDOC_FLAG+=" --variable date=$date"                           # 更新日期

# pandoc转换
pandoc ${PANDOC_FLAG} --from=markdown --to=html $src -o $dst    # 调用pandoc编译

# 后处理
sed -i -e '1s/<!-- \(.*\) -->/#\1/'     $src    #恢复文章标题
