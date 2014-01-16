#OS模块
这个模块包含普遍的操作系统功能 。如果你希望你的程序能够与平台无关的话，这个模块是尤为重要的。
即它允许一个程序在编写后不需要任何改动，也不会发生任何问题，就可以在Linux和Windows下运行。
##变量
`os.name` 字符串指示你正在使用的平台。比如对于Windows，它是 `'nt'` ，而对于Linux/Unix用户，它是 `'posix'` 。
        
        >>> os.name
        'posix'

`os.sep` 可以取代操作系统特定的路径分割符。在Linux、Unix下它是 `'/'` ，在Windows下它是 `'\\'` ，而在Mac OS下它是 `':'`。

         >>> os.sep
         '/'

`os.linesep` 给出当前平台使用的行终止符。例如，Windows使用 `'\r\n'` ，Linux使用`'\n'` ，而Mac使用 `'\r'`。
        
        >>> os.linesep
        '\n'

`os.devnull` is the file path of the null device .
        
        >>> os.device
        '/dev/null'
##函数
`os.getlogin()` 返回当前系统的登陆用户。
        
        >>> os.getlogin()
        'root'

`os.listdir()` 返回指定目录下的所有文件和目录名。

        >>> os.listdir('.')
        ['njit','vimrc']

`getenv()` Get an environment variable, return None if it doesn't exist.
The optional second argument can specify an alternate default. 
key, default and the result are str.'

`os.mkdir()` 创建单个目录。
`os.makedirs()` 创建多级目录。

`os.rmdir()` 删除单个目录。
`os.removedirs()` 删除多级目录。

`os.remove()` 删除文件。

`os.chdir()` 切换目录。

`os.getcwd()` 返回当前Python脚本工作的目录路径。

`os.system()` 运行Linux型系统命令。
        
        >>> os.system('sudo df -h')
        [sudo] password for neng: 
        文件系统        容量  已用  可用 已用% 挂载点
        /dev/sda10       19G  6.6G   11G   38% /
        /dev/sda8       9.1G  2.6G  6.0G   30% /home
        /dev/sda6        35G   19G   17G   52% /media/DOCUMENT
        0

`os.walk()` 目录遍历，该函数返回一个元组，该元组有3个元素，分别表示每次遍历的路径名，目录列表和文件列表。
        
        >>> for i in os.walk('/home/neng/workspace/Python/'):
        ... print(i)
        ....
        ('/home/neng/workspace/Python/', [], ['思想.html', 'han.my.css', '.OS模块.mkd.swp', '数据类型.mkd', '数据类型.html', 'md2html.py', '思想.mkd', 'Python.xmind'])

`execl(file, *args)` Execute the executable file with argument list args, replacing the current process.
关于执行的函数还有很多，详见手册。

`renames(old, new)` create directories as necessary and delete any left empty.
this function can fail with the new directory structure made if you lack permissions needed to unlink the leaf directory or file.

[Python学习笔记四（Python OS模块）](http://www.it165.net/pro/html/201307/6362.html)
