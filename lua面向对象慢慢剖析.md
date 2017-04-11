# ������Ҫ����LUA��������ʵ�ֹ���

  LUA��table����һ�����󣬼�ʹ�������������ͬ��ֵ����������Ҳ�ǲ�ͬ�Ķ�����Ϊlua��table�������������͵ġ�
  ����ͨ��tableʵ��һ����������
  ```
  Account = {balance = 0}
  function Account.withDraw(value)
     Account.balance = Account.balance - value
  end

  Account.withDraw(10)
  print(Account.balance)
  ```
  ������봴����һ���º�����������������Account�����withDraw�У����ڴ����е����˸ú��������Ǻ�����ʹ�õ���Accountȫ�����ƣ���������������ĵ���ֻ����Զ��������ˡ�һ���ı��˶����
���ƣ�withDraw�÷����Ͳ��ܳɹ���ʹ���ˣ����Ǹ��ܴ�������������´���
  ```
  a = Account
  Account = nil
  a.withDraw(10)
  ```
  ����ʹ��Account������һ���¶���a������Account��ֵΪnil��Ӧ�öԶ���a�������κ�Ӱ�죬�����������ԭ�򡣵�����Ϊ�ں���withDraw��ʹ�õ���Account�������Ǳ���a��Account��Ϊ�գ����Կ϶�����ᱨ��
���˵��Ҫ��һ�������н��в���ʱ����Ҫ�ƶ�ʵ�ʵĲ������������������еĶ���a�������޸Ŀɿ�������룺
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
  ����ʹ����self������ʵ�ֶ�ָ������ĵ��á����Ǻܶ���򲢲���Ҫʹ��self��ʽ������ָ����������Java��this��ʹ�ã����������õ����ĸ�����lua��Ҳ�Ǵ���������ʽ�����ķ�ʽ����ʹ��ð�������庯��
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
  ʹ��ð�ż��˶Զ��������������

  ##���Լ����������ʵ����
  ֮ǰ�Ѿ�˵����LUA���ǲ����������ָ���ģ����ǿ���ͨ��table+function�ķ�ʽȥģ��ʵ����Ĺ��̣����оͰ���������ʵ����������Ҫ��ʾһ���ֻ࣬��Ҫ����һ��ר�������������ԭ�ͣ�
ԭ��Ҳ�ǳ���Ķ���Ҳ����˵���ǿ���ֱ��ͨ��ԭ��ȥ���ö�Ӧ�ķ����� 
  ����һ�������£�
  ```
  local Account = {}
  ```
  �����࣬�Ǿ�Ҫ����ȥʵ��һ�����˶԰ɡ�������ôд
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
  ���ſ��Ե���Account:new������һ��ʵ��
  ```
  local a = Account:new()
  a.show()
  ```
  ���ǽ����¸öδ��룬��ʵ�ܼ򵥣�����ʹ��Account:new������һ���µ�ʵ�����󣬲���Account��Ϊ�µ�ʵ������a��Ԫ��(������Ԫ��ĸ����鲻�����о��ˣ�����Ҳ�᳢�Ը����������)
�����ǵ���a:show����ʱ�����൱��a.show(a)�Ĳ�������ԭ���ǣ������ǵ���showʱ���ͻ�ȥ�����Ƿ���show�ֶΣ�û�еĻ���ȥ��������Ԫ�������ʾ���£�
  ```
  getmetatable(a).__index(show(a))
  ```
  ��ʵ����
  ```
  Account.show(a)
  ```
  ��Ϊa��Ԫ����Account,���Կ���ʵ������a�в�û��show���������Ǽ̳���Account�����е�show�����Ǵ���show�����е�self��a�������Ĳ�����ʵ�����ڼ̳С�
  ��Ȼ�����еĲ���������ֻ�з��������������ֶΡ���ô���ǳ��Կ�����ôʵ�ֶ�������Ժͷ����Ĳ����ģ�ֱ�Ӵ������£�
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
  Account������һ��value�ֶΣ�����Ĭ��ֵΪ0��������൱����������ˡ������Ǵ���һ��ʵ������aʱ������û���ṩvalue�ֶΣ�������show�����У��ͻ�ȥ����Ԫ��Account,
���յõ�Account�е�value��ֵ�����ȡ������value��Ĭ��ֵΪ0��
  ����Ҫ�����µ��ǣ�ʵ������a����show����ʱ��a:show()ʵ���Ͼ���
  ```
  a.show(a)
  ```
  �䱾�����ߵ�������������
  ```
  a.value = getmetatable(a).__index(value) + 10
  ```
  ��һ�ε���showʱ���Ⱥ�����self.value����a.value,���൱����a�������һ�����ֶ�value,���ڶ��ε���ʱ,����a���Ѿ���value�ֶΣ����ԾͲ���ȥAccount��Ѱ��value�ֶ��ˡ�

  ## ��ļ̳�
  ����JAVA���ԣ���Ȼ������ĸ������lua��ʵ����Զ����˼�룬�Ǳز������ӹ��ļ̳е�ʵ���ˣ����ǳ���ʹ��luaʵ����ļ̳С��������£�
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
  ������Ҫ��fruit��������һ�����࣬����һ���յ��࣬���ӻ����м̳����еĲ���
  ```
  local Apple = Fruit:new()
  ```
  ���ڶ��ؼ̳�Ҳ��һ���ģ���ʾ�����Դ�luaDemo�в鿴���ġ�
  
