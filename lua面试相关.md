# lua面试相关
------

## 协程相关内容和考点
### 1. 协程和线程的区别
  * 相同点：协程和线程都有自己的堆栈，局部变量和对应自己的指针，且可以分别和其他协程或者线程共享全局变量等信息。
  * 不同点：在任务多处理中，线程是通过CPU决定来调度的，线程的状态完全是由CPU执行的结果，并不能做到认为代码的实时控制，而这个恰好就是协程的优势所在，可实时根据需求调度协程的进行。多线程是同时运行多个线程，而协程是通过协作实现来完成的，任何时刻只有一个协程程序在运行。
 
### 2. coroutine基础知识点
![coroutine相关](https://raw.githubusercontent.com/littleBearJrue/MarkDownPhotos/master/coroutine.jpg)

show me then code 是最好的证明
```lua
function foo(a)
    print("foo", a);
    return coroutine.yield(2 * a);
end

co = coroutine.create(function (a, b)
    print("co-body", a, b);
    local r = foo(a + 1);
    print("co-body", r);
    local r, s = coroutine.yield(a + b, a - b);
    print("co-body", r, s);
    return b, "end"
end)

print("main", coroutine.resume(co, 1, 10));
print("main", coroutine.resume(co, "r"));
print("main", coroutine.resume(co, "x", "y"));
print("main", coroutine.resume(co, "x", "y"));
```
运行结果如下：
```lua
co-body	1	10
foo	2
main	true	4
co-body	r
main	true	11	-9
co-body	x	y
main	true	10	end
main	false	cannot resume dead coroutine
```
