# Lua元表和元方法
 在lua中不像数字或者字符串可以实现相加或者连接操作，当存在两个table类型的变量，是无法直接进行操作的。于是引进了元表的概念，通过元表来修改一个行为，使其在面对一个非预定操作时执行一个指定的操作。如以两个表相加为例子，讲解下大致过程：
  1. 存在两个table类型的变量a和b
  2. 先判断a和b中是否有元表
  3. 检查该元表中是否有__add字段
  4. 如果找到了该字段，就调用该字段对应的值，这个值对应的是一个metamethod的元方法
  5. 调用__add对应的metamethod计算a和b的值

### 元方法

    其中在table中，存在可重新定义的元方法有：

    | 元方法 | 操作描述 |
    |--------------|------------|
    | __add(a, b) | 加法 |
    | __sub(a, b) | 减法 |
    | __mul(a, b) | 乘法 |
    | __div(a, b) | 除法 |
    | __mod(a, b) | 取模 |
    | __pow(a, b) | 乘幂 |
    | __unm(a)    | 相反数|
    | __concat(a, b) | 连接 |
    | __len(a)  | 长度  |
    | __eq(a, b) | 相等 |
    | __lt(a, b) | 小于 |
    | __le(a, b) | 小于等于 |
    | __index(a, b) | 索引查询 |
    | __newindex(a, b, c) | 索引更新 |
    | __call(a, ...) | 执行方法调用 |
    | __tostring(a) | 字符串输出 |
    | __metatable | 保护元表 |


   所以我们是可以根据需求重新定义table中的元方法，并作为己用的。

   那么我们就针对两个table实现相加的操作，就类似于集合的操作方法。代码先放上来：

```
Set = {}
local mt = {} --集合的元表

--重写new函数，每次创建一个table时都要创建一个元表
function Set.new(l)
	local set = {}
	setmetatable(set, mt)
	for _, v in pairs(l) do
	   set[v] = true
	 end
	 return set
end

function Set.union(a, b)
	local retSet = Set.new{}
	for v in pairs(a) do retSet[v] = true end
	for v in pairs(b) do retSet[v] = true end
	return retSet
end

function  Set.intersection(a, b)
	local retSet = Set.new{}
	for v in pairs(a) do retSet[v] = b[v] end
	return retSet
end

function Set.toString(set)
	local tb = {}
	for e in pairs(set) do
		tb[#tb + 1] = e
	end
	return "{".. table.concat(tb, ",") .. "}"
end

function Set.print(s)
	print(Set.toString(s))
end
```

   这里我们定义了加的操作来实现两个集合的并集，那么就需要让所有用于此操作的table共享一个元表，并且在该元表中定义如何执行一个加法操作。所以我们需要创建一个常规的table，准备作为集合的元表，然后实现Set.new()函数，这样在每次创建一个集合的时候，都能为这个集合创建一个元表。
 
   最后我们需要执行的操作时将元方法加入到元表

 ```
 mt.__add = Set.union
 ```

  那么执行两个table之间的相加操作就可以顺利完成了

```
local set1 = Set.new({10, 20, 30})
local set2 = Set.new({1, 2})
local set3 = set1 + set2
Set.print(set3)
```

  当然对于打印table的操作，由于直接调用print(table)是打印不出想要的效果的。那么我们就需要重新定义__toString元方法来实现对table类型的数据的打印工作了。同__add的操作，我们也是需要将tostring方法加入到元表中的。

```
mt.__tostring = Set.toString
```

### 关于__index和__newindex
lua元表中是存在一个__index的元方法，其中其具有查询的作用，一般一个table的查询调用步骤是这样的：
  1. 当访问一个table的字段时，如果table有这个字段，则直接返回对应的值
  2. 当table没有这个字段，则会促使解释器去查找一个叫__index的元方法，接下来就就会调用对应的元方法，返回元方法返回的值
  3. 如果没有这个元方法，那么就返回nil结果

这里用代码解析下：

```
Windows = {}

-- 创建默认值表
Windows.default = {x = 0, y = 0, width = 100, height = 100, color = {r = 255, g = 255, b = 255}}

Windows.mt = {} -- 创建元表

function Windows.new(o)
     setmetatable(o, Windows.mt)
     return o
end

-- 定义__index元方法
Windows.mt.__index = function (table, key)
     return Windows.default[key]
end

local win = Windows.new({x = 10, y = 10})
print(win.x)               -- >10 访问自身已经拥有的值
print(win.width)          -- >100 访问default表中的值
print(win.color.r)          -- >255 访问default表中的值
```

其执行过程是这样的：
 print(win.x）时，由于win变量本身就拥有x字段，所以就直接打印了其自身拥有的字段的值；print(win.width)由于win变量本身没有width字段，那么就去查找是否拥有元表，元表中是否有__index对应的元方法，由于存在__index元方法，返回了default表中的width字段的值，print(win.color.r)也是同样的道理

 还有个__newindex的元方法，是用于更新table中的数据的，一般一个table的更新步骤如下：
   1. Lua解释器先判断这个table是否有元表
   2. 如果有了元表，就查找元表中是否有__newindex元方法；如果没有元表，就直接添加这个索引，然后对应的赋值
   3. 如果有这个__newindex元方法，Lua解释器就执行它，而不是执行赋值
   4. 如果这个__newindex对应的不是一个函数，而是一个table时，Lua解释器就在这个table中执行赋值，而不是对原来的table
  这里就不进行代码剖析了。

  最后附上完整的代码：

  ```
  Set = {}
local mt = {} --元表

function Set.new(l)
	local set = {}
	setmetatable(set, mt)
	for _, v in pairs(l) do
	   set[v] = true
	 end
	 return set
end

function Set.union(a, b)
	local retSet = Set.new{}
	for v in pairs(a) do retSet[v] = true end
	for v in pairs(b) do retSet[v] = true end
	return retSet
end

function  Set.intersection(a, b)
	local retSet = Set.new{}
	for v in pairs(a) do retSet[v] = b[v] end
	return retSet
end

function Set.toString(set)
	local tb = {}
	for e in pairs(set) do
		tb[#tb + 1] = e
	end
	return "{".. table.concat(tb, ",") .. "}"
end

function Set.print(s)
	print(Set.toString(s))
end

mt.__add = Set.union
mt.__toString = Set.toString

local set1 = Set.new({10, 20, 30})
local set2 = Set.new({1, 2})
local set3 = set1 + set2
Set.print(set3)

local table = {19, 22, 17}
Set.toString(table)
```