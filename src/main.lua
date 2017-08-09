
cc.FileUtils:getInstance():setPopupNotify(false)
cc.FileUtils:getInstance():addSearchPath("src/")
cc.FileUtils:getInstance():addSearchPath("res/")

require "config"
require "cocos.init"

local function main()
    require("app.MyApp"):create():run()
end

require "luaTest.luaModuleAndPackage.test1"

c1 = complex.new(0, 1)
c2 = complex.new(1, 2)


ret = complex.add(c1, c2)
print(ret.r, ret.i)

print("####################################")

require "luaTest.luaLibrary1.test1"
print("####################################")

local str = "Hello123v45World"
local subStr = string.match(str, "%d+")
print(subStr)

local i, j =string.find(str, "%d+")
print(i, j)
subStr =string.sub(str, i, j)
print(subStr)
print("####################################")


local str = "Hello World"
local iteratorFunc = string.gmatch(str, "%a+") -- %a+表示匹配所有单词

for i in iteratorFunc do
	print(i)
end
print("####################################")

print(package.path)
print("####################################")

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end

local function newCounter()
local i = 12
return function () -- 匿名函数
i = i + 1
return i
end
end

local c1 = newCounter()
print("vv vv1",c1())     -->输出什么？
print(c1())     -->又输出什么？

local c2 = newCounter()

print("vv vv2",c2())     -->输出什么？
print(c2())     -->又输出什么？

print("vv vv3",c1())     -->输出什么？
print(c1())     -->又输出什么？





local function foo (a)
print("foo", a)  -- foo 2
return coroutine.yield(2 * a) -- return 2 * a
end

local co = coroutine.create(function (a , b)
print("co-body", a, b) -- co-body 1 10
local r = foo(a + 1)

print("co-body2", r)
local r, s = coroutine.yield(a + b, a - b)

print("co-body3", r, s)
return b, "end"
end)

print("main", coroutine.resume(co, 1, 10)) -- true, 4
print("------")
print("main", coroutine.resume(co, "r")) -- true 11 -9
print("------")
print("main", coroutine.resume(co, "x", "y")) -- true 10 end
print("------")
print("main", coroutine.resume(co, "x", "y")) -- false cannot resume dead coroutine
print("------")

local newProductor


local function receive()
local status, value = coroutine.resume(newProductor)
return value
end

local function send(x)
coroutine.yield(x)     -- x表示需要发送的值，值返回以后，就挂起该协同程序
end


local function productor()
local i = 0
while i<10 do
i = i + 1
send(i)     -- 将生产的物品发送给消费者
end
end

local function consumer()
local flag = true;
while flag do

local i = receive()     -- 从生产者那里得到物品
if i==nil or i >= 10 then
flag = false
end
print(i)
end
end

-- 启动程序
newProductor = coroutine.create(productor)
consumer()


print(getmetatable("Hello World"))
print(getmetatable(nil))


local Set = {}
local mt = {} -- 集合的元表

-- 根据参数列表中的值创建一个新的集合
function Set.new(l)
    local set = {}
    setmetatable(set, mt)
    for _, v in pairs(l) do
        print("test ", _, v);
        set[v] = true
    end
    return set
end
Set.new{"33","123"};




local Windows = {} -- 创建一个命名空间

-- 创建默认值表
Windows.default = {x = 0, y = 0, width = 100, height = 100, color = {r = 255, g = 255, b = 255}}

Windows.mt = {} -- 创建元表

-- 声明构造函数
function Windows.new(o)
setmetatable(o, Windows.mt)
return o
end

-- 定义__index元方法
Windows.mt.__index = function (table, key)
print("key", key)
return Windows.default[key]
end

local win = Windows.new({x = 10, y = 10})
print(win.x)               -- >10 访问自身已经拥有的值
print(win.width)          -- >100 访问default表中的值
print(win.color.r)          -- >255 访问default表中的值


local tb1 = {}
local tb2 = {}
local tb3 = {}

setmetatable(tb1, tb2)
tb2.__newindex = tb3


tb1.x = 20
print("tb1", tb1.x)
print("tb2", tb2.x)
print("tb3", tb3.x)