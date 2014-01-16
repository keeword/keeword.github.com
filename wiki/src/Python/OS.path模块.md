#os.path模块
`os.path` 模块是 Python 与路径有关的一个模块。
##路径处理
`os.path.basename(path)` 去掉目录路径，返回fname文件名

        >>> os.path.basename('/Volumes/1.mp4')  
        '1.mp4'

`os.path.dirname(path)` 去掉文件名，返回目录路径

         >>> os.path.dirname('/Volumes/1.mp4')   
        '/Volumes'

`os.path.splitdrive(path)` 返回（drivername，fpath）元组

        >>> os.path.splitdrive('Volumes/1.mp4')   
        ('','/Volumes/1.mp4')

`os.path.split(path)` 分割文件名与路径；返回（fpath，fname）元组；如果完全使用目录，它也会将最后一个目录作为文件名分离，且不会判断文件或者目录是否存在

        >>> os.path.split('/Volumes/1.mp4')    
        ('/Volumes','1.mp4')

`os.path.splitext(path)` 分离文件名与扩展名；默认返回(fname,fextension)元组，可做分片操作

        >>> os.path.splitext('/Volumes/Leopard/Users/Caroline/Desktop/1.mp4')
        ('/Volumes/Leopard/Users/Caroline/Desktop/1','.mp4')

`os.path.join('a','b','fname.extension')` 将分离的部分组成一个路径名

        os.path.join('a','b','1.mp4')
        'a/b/1.mp4'
##查询：返回值True，False
`os.path.exists(path)` 指定路径（文件或者目录）是否存在

`os.path.isabs(s)` 指定路径是否为绝对路径

`os.path.abspath(path)` 返回绝对路径

`os.path.isdir(s)` 指定路径是否存在且为一个目录

`os.path.isfile(path)` 指定路径是否存在且为一个文件

`os.path.islink(path)` 指定路径是否存在且为一个符号链接

`os.path.ismount(path)` 指定路径是否存在且为一个挂载点 

`os.path.samefile(f1, f2)` 两个路径名是否指向同一个文件

`os.path.sameopenfile(fp1, fp2)`  两个文件指针是否指向同一个文件

`os.path.samestat(s1, s2)` Test whether two stat buffers reference the same file
  
##文件信息
`os.path.getatime(filename)` 返回最近访问时间  （浮点型秒数）

`os.path.getctime(filename)` 返回文件创建时间

`os.path.getmtime(filename)` 返回最近文件修改时间

`os.path.getsize(filename)` 返回文件大小 （字节为单位）

`os.path.normcase(s)` Normalize case of pathname.  Has no effect under Posix

`os.path.normpath(path)` Normalize path, eliminating double slashes, etc.

`os.path.realpath(filename)` Return the canonical path of the specified filename, eliminating any symbolic links encountered in the path.

`os.path.relpath(path, start=None)` Return a relative version of a path

参考：
[Python os.path模块](http://my.oschina.net/cuffica/blog/33494)

