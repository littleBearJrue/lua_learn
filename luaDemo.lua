--一个简单实现阶乘的方法
--[[function fact (n) 
   if n == 0 then
      return 1
   else 
      return n * fact(n - 1)
   end 
end 
print("enter a number:")
a = io.read("*number")
print(fact(a))--]]

--通过type来判断数据类型
--[[
print(type("hello world"))
print(type(10.84))
print(type(print))
print(type(type))
print(type(true))
print(type(nil))
print(type(type(X)))--]]  

--使用#来计算字符串长度
--len = "boyaa"
--print(#len)

--table的使用
--初始化空table
--local table1 = {}
--直接初始化一个table
--local table = {"apple", "pear", "orange"}
--基本table执行代码
--[[local table = {"apple", "pear", "orange"}
for key, val in pairs(table) do
    print("key", key, "value", val)
end  --]]

--多个变量的赋值
--a,b = 10, 2 * x

--for循环的使用
--[[
for i = 1, 10, 2 do 
  print(i)
end
--]]

--if...then...else语句，这里实现嵌套
--[[
a = 10
b = 18
if (a > 9)
then 
 if (b == 18) 
 then 
    print("a的值为"，a, "b的值为"，b)
 end
end
--]] 

--实现函数作为参数传递给另一个函数
--[[
myPrint = function(param)
   print("这是打印函数- ", param)
end
function add(num1, num2, functionPrint)
   result = num1 + num2
   functionPrint(result)
end
myPrint(10)
add(2, 5, myPrint)
--]]

--实现函数返回多个返回值
--[[
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
--]]

--实现函数接受可变数目的参数
--[[
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
--]]

--迭代器里面pairs和ipairs的区别：
--[[
local tab= { 
[1] = "a", 
[3] = "b", 
[4] = "c" 
} 
for i,v in pairs(tab) do        -- 输出 "a" ,"b", "c"  ,
    print( "pairs的方式输出", tab[i] ) 
end 
for i,v in ipairs(tab) do    -- 输出 "a" ,k=2时断开 
    print( "ipairs的方式输出", tab[i] ) 
end
--]]

--无状态迭代器的实现：简单的状态常量和控制变量
--[[
function square(endNum, beginNum)
  if beginNum < endNum
  then
     beginNum = beginNum + 1
  return beginNum, beginNum * beginNum
  end
end
for i, val in square, 9, 0 do
  print(i, val)
end
--]]

--table的连接
local table = {"lua", "java", "android", "C"}
print("连接后的字符串: ", table.concat(table))
print("连接后的字符串: ", table.concat(table, ", "))
print("连接后的字符串: ", table.concat(table, ", ", 2, 4))

--table插入和移除
local fruits = {"banana","orange","apple"}

table.insert(fruits,"mango")
print("索引为 4 的元素为 ",fruits[4])

table.insert(fruits,2,"grapes")
print("索引为 2 的元素为 ",fruits[2])

print("最后一个元素为 ",fruits[5])
table.remove(fruits)
print("移除后最后一个元素为 ",fruits[5])

--table排序
local language = {"java","lua","C","ruby"}
print("排序前")
for k,v in ipairs(language) do
	print(k,v)
end

table.sort(language)
print("排序后")
for k,v in ipairs(language) do
	print(k,v)
end