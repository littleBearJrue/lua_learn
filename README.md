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

## 函数
### 主要用途：
1. 完成指定任务，这种情况下函数作为调用语句使用
2. 计算并返回值，这种情况下函数作为赋值语句的表达式使用
### 注意要点
1. 函数是可以作为参数传递给另一个函数的
```
myPrint = function(param)
   print("这是打印函数- ", param)
end

function add(num1, num2, functionPrint)
   result = num1 + num2
   functionPrint(result)
end
myPrint(10)
add(2, 5, myPrint)
```

2. 函数是可以存在多个返回值的，只要return多个值，期间值与值之间用逗号隔开
```
function maxNumAndIndex(table)
  local index = 1  --记住table的索引值从1开始
  local max = table[index]
  for i, val in ipairs(table) do
     if val > max then
        index = i
        max = val
     end
  end
  return max, index
end

print(maxNumAndIndex({88, 1, 22, 12, 99, 5, 66, 42}))
```

3. 函数是可以接受可变数目的参数的
```
function average(...)
  result = 0
  local arg ={...}
  for i, val in ipairs(arg) do
    result = result + val
  end
  print("总共传入" ..#arg.. "个数")
  return result/#arg
end

print("平均值为", average(10, 5, 2, 6, 8, 7, 3))
```

## 常用运算符
  最基本的算术运算符，关系运算符和逻辑运算符这里不提及了，这容易理解，主要说下差异化或者注意点的地方
  1. 逻辑运算符的书写是： and or not
  2. 连接两个字符串： ..
  3. 计算字符串或者表长度： #

## 关于字符串
### 三种表达方式：
1. 单引号的一串字符
2. 双引号间一串字符
3. [[和]]之间的一串字符
### 系统提供的字符串操作api
1. string.upper() <--> 字符串全部转化为大写字母
2. string.lower() <--> 字符串全部转化为小写字母
3. string.gsub(mainString, findString, repalceString, num) <--> 字符串替换，其中num为替换的次数
4. string.find(str, subStr, index) <--> 在指定字符串中搜索指定的内容，返回的是字符index
5. string.reverse(arg) <--> 字符串反转
6. string.format(...) <--> 返回一个格式化后的字符串
7. string.char(arg) <--> char将整型数字转化成字符并连接
8. string.byte(arg, [int]) <--> byte将字符转换为整数值， int为指定字符
9. string.len(arg) <--> 计算字符串长度
10. string.rep(string, n) <--> 返回字符串的n个拷贝

## 迭代器
1. 无状态迭代器： 可避免创建闭包话费额外的代价
2. 多状态迭代器： 使用闭包或者是将所有的状态信息封装到table内，将table作为迭代器的状态常量
注意要点： pairs和ipairs的区别
1. pairs: 迭代table，可以遍历表中所有的key,可以返回nil
2. ipairs: 迭代数组，不能返回nil，如果遇到nil，则退出

## table: 俗称的表，是一种数据结构用来帮助我们创建不同的数据类型（重点）
lua table使用的是关联型数组，可以用任意类型的值来作为数组的索引包括string类型，但这个值不能为nil
### 最基本使用
1. 初始化表：myTable = {}
2. 创建指定值的表： myTbale[1] = "lua"
3. 移除引用，让垃圾回收自动释放内存： myTable = nil

### 几个操作api
1. table.concat() <--> 列出参数中指定table数组部分从start位置到end位置的所有元素，可以以指定分隔符隔开
2. table.insert() <--> 在table的数组部分指定位置插入值为value的一个元素
3. table.maxn() <--> table数组部分中所有正数key值中的最大key值
4. table.remove() <--> 删除table的指定位置的元素
5. table.sort() <--> 对给定的table进行升序排序

## lua模块和包
模块相当于一个封装库，可以把一些公用的代码放在一个文件里，以api接口的形式在其他地方调用，有利于代码的重用和降低代码耦合度

## MetaTable：元表
### 两个重要的函数处理元表
1. setmetatable(table, metatable): 对指定元素设置元表
2. getmetatable(table)： 返回对象的元表

### Lua查找一个表元素时的规则，其实就是如下3个步骤:
1. 在表中查找，如果找到，返回该元素，找不到则继续
2. 判断该表是否有元表，如果没有元表，返回nil，有元表则继续。
3. 判断元表有没有__index方法，如果__index方法为nil，则返回nil；如果__index方法是一个表，则重复1、2、3；如果__index方法是一个函数，则返回该函数的返回值。

## lua协同程序：coroutine
### 协程和线程的区别： 
一个具有多个线程的程序可以同时运行几个线程，而协同程序却需要彼此协作的运行
在任一指定时刻只有一个协同程序在运行，并且这个正在运行的协同程序只有在明确的被要求挂起的时候才会被挂起。
协同程序有点类似同步的多线程，在等待同一个线程锁的几个线程有点类似协同。

### 基本用法：
1. coroutine.create() <--> 创建coroutine
2. coroutine.resume() <--> 重启coroutine
3. coroutine.yield() <--> 挂起coroutine
4. coroutine.status() <--> 查看coroutine的状态
5. coroutine.wrap() <--> 创建coroutine
6. coroutine.running(0 <--> 返回一个正在运行的coroutine的线程号

## lua的文件I/O
### 分类
1. 简单模式： 拥有一个当前输入文件和一个当前输出文件
2. 完全模式：使用外部文件句柄的方式来实现，它是一种面对对象的形式及，将所有文件操作定义为文件句柄的方法
### 基本模式
其打开文件的操作方式为：file = io.open(fileName, [, mode])

| 模式 | 描述 |
|----|------|
| r | 以只读方式打开文件，该文件必须存在 |
| w | 打开只写文件，若文件存在则文件长度清为0，即该文件内容会消失。若文件不存在则建立该文件 |
| a | 以附加的方式打开只写文件。若文件不存在，则会建立该文件，如果文件存在，写入的数据会被加到文件尾，即文件原先的内容会被保留 |
| r+| 以可读写方式打开文件，该文件必须存在 |
| w+| 打开可读写文件，若文件存在则文件长度清为零，即该文件内容会消失。若文件不存在则建立该文件 |
| a+| 与a类似，但此文件可读可写 |
| b | 二进制模式，如果文件是二进制文件，可以加上b |
| + | 文件可读写操作 |

### 基本操作
1. io.open()
2. io.read()
3. io.open()
4. io.input()
5. io.output()
6. io.write()
7. io.close()
8. io.tmpfile(): 返回临时文件句柄
9. io.type(file): 返回是否是可用的文件句柄
10. io.flush(): 向文件写入缓冲的所有数据
11. io.lines(): 返回一个迭代函数，每次调用将获得文件中的一行内容，当到文件尾时，将返回nil，但不关闭文件

### lua的错误处理
1. assert:
```
local function add(a,b)
   assert(type(a) == "number", "a 不是一个数字")
   assert(type(b) == "number", "b 不是一个数字")
   return a+b
end
add(10)
```
2. error(message, [, level]): 终止正在执行的函数，并返回message的内容作为错误信息(error函数永远都不会返回)
3. pcall: 捕获函数执行中的任何错误
`pcall(function(i) print(i) end, 33)`
4. xpcall: 接收第二个参数，一个错误处理的函数。当错误发生时，lua会在调用栈展开前调用错误处理函数，显示错误额外信息·
```
function myfunction ()
   n = n/nil
end

function myerrorhandler( err )
   print( "ERROR:", err )
end

status = xpcall( myfunction, myerrorhandler )
print( status)
```
## lua调试
| 序号 | 方法 | 用途 |
|----|------|------------|
| 1 | debug() | 进入一个用户交互模式，运行用户输入的每个字符串。 使用简单的命令以及其它调试设置，用户可以检阅全局变量和局部变量， 改变变量的值，计算一些表达式，等等。输入一行仅包含 cont 的字符串将结束这个函数， 这样调用者就可以继续向下运行 |
| 2 | getfenv(object) | 返回对象的环境变量 |
| 3 | gethook(optional thread) | 返回三个表示线程钩子设置的值： 当前钩子函数，当前钩子掩码，当前钩子计数 |
| 4 | getinfo ([thread,] f [, what]) | 返回关于一个函数信息的表。 你可以直接提供该函数， 也可以用一个数字 f 表示该函数。 数字 f 表示运行在指定线程的调用栈对应层次上的函数： 0 层表示当前函数（getinfo 自身）； 1 层表示调用 getinfo 的函数 （除非是尾调用，这种情况不计入栈）；等等。 如果 f 是一个比活动函数数量还大的数字， getinfo 返回 nil |
| 5 | debug.getlocal ([thread,] f, local) | 此函数返回在栈的 f 层处函数的索引为 local 的局部变量 的名字和值。 这个函数不仅用于访问显式定义的局部变量，也包括形参、临时变量等 |
| 6 | getmetatable(value) | 把给定索引指向的值的元表压入堆栈。如果索引无效，或是这个值没有元表，函数将返回 0 并且不会向栈上压任何东西 |
| 7 | getregistry() | 返回注册表表，这是一个预定义出来的表， 可以用来保存任何 C 代码想保存的 Lua 值 |
| 8 | getupvalue (f, up) | 此函数返回函数 f 的第 up 个上值的名字和值。 如果该函数没有那个上值，返回 nil。以 '(' （开括号）打头的变量名表示没有名字的变量 （去除了调试信息的代码块）|
| 9 | setlocal ([thread,] level, local, value) | 这个函数将 value 赋给 栈上第 level 层函数的第 local 个局部变量。 如果没有那个变量，函数返回 nil 。 如果 level 越界，抛出一个错误 |
| 10 | setmetatable (value, table) | 将 value 的元表设为 table （可以是 nil）。 返回 value |
| 11 | setupvalue (f, up, value) | 这个函数将 value 设为函数 f 的第 up 个上值。 如果函数没有那个上值，返回 nil 否则，返回该上值的名字 |
| 12 | traceback ([thread,] [message [, level]]) | 如果 message 有，且不是字符串或 nil， 函数不做任何处理直接返回 message。 否则，它返回调用栈的栈回溯信息。 字符串可选项 message 被添加在栈回溯信息的开头。 数字可选项 level 指明从栈的哪一层开始回溯 （默认为 1 ，即调用 traceback 的那里）|

## lua垃圾回收
实现一个增量标记-扫描收集器


| 序号 | 方法 | 描述 |
|---|-------|----------|
| 1 | collectgarbage("collect") | 做一次完整的垃圾收集循环 |
| 2 | collectgarbage("count") | 以 K 字节数为单位返回 Lua 使用的总内存数。 这个值有小数部分，所以只需要乘上 1024 就能得到 Lua 使用的准确字节数 |
| 3 | collectgarbage("restart") | 重启垃圾收集器的自动运行 |
| 4 |  collectgarbage("setpause") | 将 arg 设为收集器的 间歇率。返回 间歇率 的前一个值 | 
| 5 | collectgarbage("setstepmul") | 返回 步进倍率 的前一个值 |
| 6 | collectgarbage("step") | 单步运行垃圾收集器。 步长"大小"由 arg 控制。 传入 0 时，收集器步进（不可分割的）一步。 传入非 0 值， 收集器收集相当于 Lua 分配这些多（K 字节）内存的工作。 如果收集器结束一个循环将返回 true |
| 7 |  collectgarbage("stop") | 停止垃圾收集器的运行。 在调用重启前，收集器只会因显式的调用运行 |
