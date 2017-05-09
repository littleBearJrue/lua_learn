# Decoda调试lua程序

## Decoda调试lua主要分两种方法：
1. 从Decoda启动宿主程序调试lua
2. Devoda注入宿主程序进行调试

## 方法一：从Decoda启动宿主程序调试lua
1. 打开需要调试的Lua脚本并设置断点

![](http://www.cppblog.com/images/cppblog_com/ming81/19898/o_1.png)

2. 启动Decoda调试

![](http://www.cppblog.com/images/cppblog_com/ming81/19898/o_2.png)

3. 输入应用程序路径并启动

![](http://www.cppblog.com/images/cppblog_com/ming81/19898/o_3.png)


## 方法二：Decoda注入宿主程序进行调试
1. 在需要调试的代码前添加暂停用的代码，用来给decoda注入
```
printf( "Press any key to run lua file./n");
getch();
```

2. 当程序暂停后，启动decoda，打开Lua脚本，设置断点，并进行注入

![](http://www.cppblog.com/images/cppblog_com/ming81/19898/o_4.png)

3. 选择需要调试的程序进行attach

![](http://www.cppblog.com/images/cppblog_com/ming81/19898/o_5.png)

4. 看到decoda output窗口如下显示，就在刚才暂停的程序处

```
Debugging session started
Debugger attached to process
```
继续运行即可！