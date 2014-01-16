WIKI=$(shell find . -regex ".*md" ) # 从本路径向下查找所有.md作为源文件
HTML=$(WIKI:%.md=%.html) 	    # 将.md的同名.html文件作为目标文件

# 总目标
all:$(HTML)

# 每个html的编译规则
%.html:%.md res/header.html res/footer.html makefile res/pandoctpl.html res/md2html.sh
	@echo "Making $@"
	@res/md2html.sh $< $@ 
	@cp -f $@ ../published/wiki/

# 伪目标
%PHONY:clean
clean:
	@rm -f $(HTML)
