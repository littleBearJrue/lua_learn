# 一步步学习lua

## 环境安装
一般下载luaforwindow便可以实现集成好的编译环境，但是我在下载安装过程中出现问题，始终显示安装错误所以选择了另一种方式。
1. 先下载好编译完成后的下载资源包(http://joedf.ahkscript.org/LuaBuilds/hdata/lua-5.3.4_Win64_bin.zip),注：此版本为window 64位
2. 配置环境变量：将下载好的三个文件包括lua.exe lua53.dll luac.exe三个文件放在同个文件夹并在系统变量中，新建变量名为lua和变量值为文件夹地址。并在path中加入 %lua%，完成环境变量的配置
3. 在命令行中输入lua，如果出现版本信息即表明配置完成

## 一些基本语法
1. 单行注释： --
2. 多行注释： --[[xxxxx--]]
3. 标识符是区分大小写的，即jrue和Jrue是不同的标识符
4. 默认申请的变量均为全局变量，全局变量不使用时只需要初始化 a = nil;

## 常用数据类型
1. 常用的数据类型包括： nil, boolean, number, string, function, userdata, thread, table
2. type可作为判断哪种数据类型
3. 使用#来计算字符串长度
4. table的创建是通过"构造表达式"来完成的，其实本身是一个关联数组，数组的索引可以是数字也是可以是字符串(这点跟java数组差别比较大).记住table的初始索引为1，而不是0
5. table不会有固定长度大小，而有新数据添加时table长度会自动增加，没初始化的table都是nil
6. thread: 线程跟协程的区别： 线程可以同时多个运行，而协程任意时刻只能运行一个，并且处于运行状态的协程只有被挂起时才会暂停
7. userdata:是一种自定义数据，用于表示一种由应用程序或者C/C++语言库所创建的类型。可以将任意C/C++的任意数据类型存储到lua变量中调用

## lua变量
全局变量，局部变量，表中的域
注意：lua中的变量全是全局变量，除非用local显式声明为局部变量
访问table的索引lua提供了两种方法： table[i] <--> table.i

## 循环
1. 主要的三种循环方式： while循环， for循环， repeat...until循环
2. for循环不同于while循环比较常规，for循环可以写定三个值，分别为初始值，增长到的值和递增值。基本分为数值for循环和泛型for循环