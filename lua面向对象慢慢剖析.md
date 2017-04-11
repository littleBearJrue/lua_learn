# 此文主要分析LUA面向对象的实现过程

  LUA中table就是一个对象，即使两个对象具有相同的值，但是他们也是不同的对象，因为lua中table是属于引用类型的。
  下面通过table实现一个基本对象：
  ```
  Account = {balance = 0}
  function Account.withDraw(value)
     Account.balance = Account.balance - value
  end

  Account.withDraw(10)
  print(Account.balance)
  ```
  上面代码创建了一个新函数，并将函数存入Account对象的withDraw中，并在代码中调用了该函数。但是函数中使用的是Account全局名称，以至于这个函数的调用只能针对对象本身工作了。一旦改变了对象的
名称，withDraw该方法就不能成功的使用了，这是个很大的隐患。如以下代码
  ```
  a = Account
  Account = nil
  a.withDraw(10)
  ```
  这里使用Account创建了一个新对象a，当将Account赋值为nil后，应该对对象a不产生任何影响，这是最基本的原则。但是因为在函数withDraw中使用的是Account，而不是变量a，Account已为空，所以肯定代码会报错。
这就说明要在一个函数中进行操作时，需要制定实际的操作对象，如上述代码中的对象a，具体修改可看下面代码：
  ```
  Account = {balance = 0}
  function Account.withDraw(self, value)
    self.balance = self.balance - value
  end

  a = Account 
  Account = nil
  a.withDraw(a, 10)
  print(a.balance)
  ```
  这里使用了self参数来实现对指定对象的调用。但是很多程序并不需要使用self显式的声明指定对象，正如Java中this的使用，来表明调用的是哪个对象，lua中也是存在这种隐式声明的方式。可使用冒号来定义函数
  ```
  Account = {balance = 0}
  function Account:withDraw(value)
    self.balance = self.balance - value
  end

  a= Account
  Account = nil
  a:withDraw(10)
  print(a.balance)
  ```
  使用冒号简化了对对象的声明操作。

  ##类以及类的声明、实例化
  之前已经说过，LUA中是不存在类这种概念的，但是可以通过table+function的方式去模拟实现类的过程，其中就包括声明和实例化操作。要表示一个类，只需要创建一个专用作其他对象的原型，
原型也是常规的对象，也就是说我们可以直接通过原型去调用对应的方法。 
  创建一个类如下：
  ```
  local Account = {}
  ```
  有了类，那就要尝试去实例一个类了对吧。尝试这么写
  ```
  function Account:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
  end

  function Account:show()
    print("show data successfully")
  end
  ```
  接着可以调用Account:new来创建一个实例
  ```
  local a = Account:new()
  a.show()
  ```
  我们解析下该段代码，其实很简单，就是使用Account:new来创建一个新的实例对象，并将Account作为新的实例对象a的元表(这里有元表的概念，这块不多做研究了，后续也会尝试跟进这块内容)
当我们调用a:show函数时，就相当于a.show(a)的操作。其原理是：当我们调用show时，就会去查找是否有show字段，没有的话就去搜索它的元表，代码表示如下：
  ```
  getmetatable(a).__index(show(a))
  ```
  其实就是
  ```
  Account.show(a)
  ```
  因为a的元表是Account,可以看出实例对象a中并没有show方法，而是继承了Account方法中的show，但是传入show方法中的self是a。这样的操作其实类似于继承。
  当然对类中的操作不单单只有方法，还有属性字段。那么我们尝试看下怎么实现对类的属性和方法的操作的，直接代码如下：
  ```
  local Account = {value = 0}
  function Account:new(o)
     o = o or {}
     setmetatable(o,self)
     self.__index = self
     return o
  end

  function Account:show()
     self.value = self.value + 10
     print("current value is ", self.value)
  end

 local a = Account:new{}
 a:show()
 ```
  Account类中有一个value字段，并且默认值为0，这里就相当于类的属性了。当我们创建一个实例对象a时，由于没有提供value字段，所以在show方法中，就回去查找元表Account,
最终得到Account中的value的值，因此取到的是value的默认值为0。
  这里要解析下的是，实例对象a调用show方法时，a:show()实际上就是
  ```
  a.show(a)
  ```
  其本质上走的流程是这样的
  ```
  a.value = getmetatable(a).__index(value) + 10
  ```
  第一次调用show时，等号左侧的self.value就是a.value,就相当于在a中添加了一个新字段value,当第二次调用时,由于a中已经有value字段，所以就不会去Account中寻找value字段了。

  ## 类的继承
  正如JAVA而言，既然有了类的概念，并且lua想实现面对对象的思想，那必不可能逃过的继承的实现了，我们尝试使用lua实现类的继承。代码如下：
  ```
  local Fruit = {color = "yellow"}
  function Fruit:new(o)
     o = o or {}
     setmetatable(o, self)
     self.__index = self
     return o
  end
  
  function Fruit:show()
     print("The fruit color is ", self.color)
  end
  ``` 
  现在需要从fruit中派生出一个子类，创建一个空的类，来从基类中继承所有的操作
  ```
  local Apple = Fruit:new()
  ```
  至于多重继承也是一样的，此示例可以从luaDemo中查看到的。
  
