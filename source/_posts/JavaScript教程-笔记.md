title: JavaScript教程&笔记
author: 田_田
tags:
  - JavaScript
  - Language
categories: []
date: 2016-07-26 17:19:00
---
之前写过不少的python和c＋＋代码，近期开始正式的学习javascript，做了一些笔记。重点记录和c＋＋不同的部分
<!-- more -->

##  ECMAScript

因为网景开发了JavaScript，一年后微软又模仿JavaScript开发了JScript，为了让JavaScript成为全球标准，几个公司联合ECMA（European Computer Manufacturers Association）组织定制了JavaScript语言的标准，被称为ECMAScript标准。最新版ECMAScript 6标准（简称ES6）已经在2015年6月正式发布了，所以，讲到JavaScript的版本，实际上就是说它实现了ECMAScript标准的哪个版本。
## 开始编程

 - JavaScript代码可以直接嵌在网页的任何地方，不过通常我们都把JavaScript代码放到`<head>`中.
 - 把JavaScript代码放到一个单独的.js文件，然后在HTML中通过`<script src="..."></script>`引入这个文件.
 - JavaScript引擎有一个在行末自动添加分号的机制,可能让你栽到大坑.

## 数据类型
### 笔记

 - NaN; // NaN表示Not a Number，当无法计算结果时用NaN表示.
 - Infinity; // Infinity表示无限大，当数值超过了JavaScript的Number所能表示的最大值时，就表示为Infinity.
 - %是求余运算.
 - 字符串单双引号都可以`'abc'，"xyz"`
 - 与或非和c++, java 一样
### 比较运算符
 - 两种比较运算符
 - 由于JavaScript这个设计缺陷，不要使用==比较，始终坚持使用===比较.(`"==" 只要求值相等; "===" 要求值和类型都相`)
> 第一种是==比较，它会自动转换数据类型再比较，很多时候，会得到非常诡异的结果；
第二种是===比较，它不会自动转换数据类型，如果数据类型不一致，返回false，如果一致，再比较。

 - NaN这个特殊的Number与所有其他值都不相等，包括它自己
`NaN === NaN; // false`
 - 唯一能判断NaN的方法是通过isNaN()函数
`isNaN(NaN); // true`

### null和undefined

 - null表示一个“空”的值，它和0以及空字符串''不同，0是一个数值，''表示长度为0的字符串，而null表示“空”。
> 在其他语言中，也有类似JavaScript的null的表示，例如Java也用null，Swift用nil，Python用None表示。

 - 和null类似的undefined，它表示“未定义”。
> JavaScript的设计者希望用null表示一个空的值，而undefined表示值未定义。事实证明，这并没有什么卵用，区分两者的意义不大。大多数情况下，我们都应该用null。undefined仅仅在判断函数参数是否传递的情况下有用。

### 变量
 - 变量名是大小写英文、数字、$和_的组合，且不能用数字开头。
 - 如果一个变量没有通过var申明就被使用，那么该变量就自动被申明为全局变量
> ECMA在后续规范中推出了strict模式，在strict模式下运行的JavaScript代码，强制通过var申明变量，未使用var申明变量就使用的，将导致运行错误。启用strict模式的方法是在JavaScript代码的第一行写上：
`'use strict';`

## 数组
### 定义
 - 直接给Array的length赋一个新的值会导致Array大小的变化
 - 如果通过索引赋值时，索引超过了范围，同样会引起Array大小的变化
`var arr = [1, 2, 3];
arr[5] = 'x';
arr; // arr变为[1, 2, 3, undefined, undefined, 'x']`

### 标准函数
[参考这个链接](http://www.liaoxuefeng.com/wiki/001434446689867b27157e896e74d51a89c25cc8b43bdb3000/00143449921138898cdeb7fc2214dc08c6c67827758cd2f000)

 - `arr.indexOf(p);` // 返回元素p在数组中的索引，返回[-1,n-1],没有找到返回-1
 - `arr.slice(s, t);`//返回subsequece，前闭后开，t可以省略
 - `arr.push(p0, p1);arr.pop()`//类似于栈。空数组继续pop不会报错，而是返回undefined
 - `arr.unshift('A', 'B'); arr.shift();`//同上，但是在下标靠近0的一侧。
 - `arr.sort(cmp);arr.reverse()`//排序函数，倒置函数，cmp可以是三目函数。
 - `arr.splice(s, l, p0, p1, p2);`//从数组第s个位置开始删除l个元素，并插入p1 p2 ...
 - `arr.concat([p0, p1, p2...])`//连接两个数组
 - `arr.join('-');` //将数组用分隔符连接 'A-B-C-1-2-3'

## 对象
 - `xiaohong['middle-school']; xiaohong.name; `//middle-school不是一个有效的变量，就需要用''括起来
 - 访问不存在的属性不报错，而是返回undefined.
 - `xiaoming.age = 18; `// 新增一个age属性
 - `delete xiaoming.age;` // 删除age属性,删除一个不存在的school属性也不会报错
 - `'name' in xiaoming;` 检测是否拥有某一属性，可以用in操作。但是这个属性可能是继承得到的。
 - `xiaoming.hasOwnProperty('name');` //可以用hasOwnProperty()方法严格判断是非拥有属性

## 判断&循环
 - `for (var i=1; i<=10000; i++) {}`
 - `for (i=0; i<arr.length; i++) {}`
 - `for (;;) {}`//equal while(true)
 - `for (var key in object) {if (o.hasOwnProperty(key)) { }}`// iterator object
 - `for (var key in list){}`// iterator list
 - `while(){} do{}while()`//same with c++/java

## Map和Set
###  define
 - `var m = new Map([['Michael', 95], ['Bob', 75], ['Tracy', 85]]);`
 - `var s = new Set([1, 2, 3, 3, '3']);`
 - var m = new Map();
### 
 - `m.set('Adam', 67);`
 - `m.has('Adam');` // 是否存在key 'Adam': true
 - `m.get('Adam');` // 67,maybe undefined
 - `m.delete('Adam');` // 删除key 'Adam'
 - `a.forEach(function (element, index, array) {});`// element: 指向当前元素的值, index: 指向当前索, array: 指向Array对象本身
 - `m.forEach(function (value, key, map) {});`//v k map, 和set一样，set的kv同时返回v

 - `for (var x of a) {}`// ES6

## 函数

### 定义函数
 - `var abs = function (x) {};`//需要在函数体末尾加一个`;`表示赋值语句结束.
 - `function abs(x) {}`
 - 如果没有return语句，函数执行完毕后也会返回结果，只是结果为undefined.
 - 允许传入任意个参数而不影响调用，因此传入的参数比定义的参数多也没有问题，虽然函数内部并不需要这些参数
 - 传入的参数比定义的少,参数x将收到undefined

### arguments & rest
 - 只在函数内部起作用，并且永远指向当前函数的调用者传入的所有参数。arguments类似Array但它不是一个Array
 - `arguments.length === 2`//arguments最常用于判断传入参数的个数。
 - `function foo(a, b, ...rest)`//ES6
 - 

### 变量作用域
 - JavaScript的函数可以嵌套，此时，内部函数可以访问外部函数定义的变量，反过来则不行.
 - 函数定义有个特点，它会先扫描整个函数体的语句，把所有申明的变量“提升”到函数顶部. so 在函数内部首先申明所有变量.
 - 顶层函数的定义也被视为一个全局变量，并绑定到window对象
 - `for (let i=0; i<100; i++){}` //ES6, let替代var可以申明一个块级作用域的变
 - `const PI = 3.14;` 通常用全部大写的变量来表示“这是一个常量，不要修改它的值,ES6标准引入了新的关键字const来定义常量.
 - 在一个方法内部，this是一个特殊变量，它始终指向当前对象
 - 单独调用方法函数，此时，该函数的this指向全局对象，也就是window
 - `var fn = xiaoming.age; fn();`// 先拿到xiaoming的age函数,retuen NaN,要保证this指向正确，必须用obj.xxx()的形式调用
 - `Math.max.apply(null, [3, 5, 4]);` // 5,函数本身的apply方法，它接收两个参数，第一个参数就是需要绑定的this变量，第二个参数是Array，表示函数本身的参数。
 - `Math.max.call(null, 3, 5, 4);`// 5, same with apply()
>装饰器
`var count = 0;
var oldParseInt = parseInt; // 保存原函数
window.parseInt = function () {
    count += 1;
    return oldParseInt.apply(null, arguments); // 调用原函数
};`

### 高阶函数
 - `function add(x, y, f) {return f(x) + f(y);}`//一个函数就可以接收另一个函数作为参数，这种函数就称之为高阶函数
 - `arr.map(String);`//把f(x)作用在Array的每一个元素并把结果生成一个新的Array
 - `arr.reduce(function (x, y) {return x + y;});`//把结果继续和序列的下一个元素做累积计算

### 闭包
 - 除了可以接受函数作为参数外，还可以把函数作为结果值返回。
 - 相关参数和变量都保存在返回的函数中，这种称为“闭包（Closure）”.换句话说，闭包就是携带状态的函数，并且它的状态可以完全对外隐藏起来。
 - 当我们调用lazy_func()时，每次调用都会返回一个新的函数，即使传入相同的参数
 - 当一个函数返回了一个函数后，其内部的局部变量还被新函数引用，所以，闭包用起来简单，实现起来不容易。
 - 返回函数不要引用任何循环变量，或者后续会发生变化的变量。再创建一个函数，用该函数的参数绑定循环变量当前的值，无论该循环变量后续如何更改，已绑定到函数参数的值不变.
 - `(function (x) { return x * x }) (3);`//创建一个匿名函数并立刻执行
 - `x => ({ foo: x })`//返回一个对象. 参数不是一个，需要用括号()括起来.
 - `var that = this;`//hack function scope changed
 - generator由function*定义（注意多出的*号），并且，除了return语句，还可以用`yield`返回多次。返回一个对象`{value: x, done: true/false}`


## 标准对象
### Base
 - 在JavaScript的世界里，一切都是对象。
 - number、string、boolean、function和undefined有别于其他类型。特别注意null的类型是object，Array的类型也是object，如果我们用typeof将无法区分出null、Array和通常意义上的object——{}。
 - new String('str') === 'str'; // false,闲的蛋疼也不要使用包装对象！尤其是针对string类型！！！
> 总结一下，有这么几条规则需要遵守：
 - 不要使用new Number()、new Boolean()、new String()创建包装对象；
 - 用parseInt()或parseFloat()来转换任意类型到number；
用String()来转换任意类型到string，或者直接调用某个对象的toString()方法；
 - 通常不必把任意类型转换为boolean再判断，因为可以直接写if (myVar) {...}；
 - typeof操作符可以判断出number、boolean、string、function和undefined；
 - 判断Array要使用Array.isArray(arr)；
 - 判断null请使用myVar === null；
 - 判断某个全局变量是否存在用typeof window.myVar === 'undefined'.
 - `(123).toString();` // '123'
 - `var b2 = Boolean('false');` // true!
 - `var s = String(123.45);` // '123.45'
 - `var n = Number('123');` // 123，相当于parseInt()或parseFloat()

### Date
 - [日期时间入门](http://www.liaoxuefeng.com/wiki/001434446689867b27157e896e74d51a89c25cc8b43bdb3000/001434499525761186acdd5ac3a44f8a50cc0ed8606139b000)
 - [日期时间参考文档](http://www.w3school.com.cn/jsref/jsref_obj_date.asp)

##Reg Exp
 - `var re2 = new RegExp('ABC\\-001');`
 
 - `var re1 = /ABC\-001/;`
 - `var re = /^\d{3}\-\d{3,8}$/;
re.test('010-12345'); // true
re.test('010-1234x'); // false`

 - `'a,b, c  d'.split(/[\s\,]+/);` // ['a', 'b', 'c', 'd']

 - `var re = /^(\d{3})-(\d{3,8})$/;
re.exec('010-12345'); // ['010-12345', '010', '12345']
re.exec('010 12345'); // null`exec()方法在匹配成功后，会返回一个Array，表示匹配成功的子串,失败时返回null。

 - `var re = /^(\d+)(0*)$/;re.exec('102300'); // ['102300', '102300', '']`

## 面向对象编程

 - `xiaoming.__proto__ = Student;`//xiaoming有自己的name属性，但并没有定义run()方法。不过，由于小明是从Student继承而来，只要Student有run()方法，xiaoming也可以调用
 
 - `var s = Object.create(Student);`//Object.create()方法可以传入一个原型对象，并创建一个基于该原型的新对象，但是新对象什么属性都没有，因此，我们可以编写一个函数来创建xiaoming

 - `function Student(name) {
    this.name = name;
    this.hello = function () {
        alert('Hello, ' + this.name + '!');
    }
}
var xiaoming = new Student('小明');
`//果不写new，这就是一个普通函数，它返回undefined。但是，如果写了new，它就变成了一个构造函数，它绑定的this指向新创建的对象，并默认返回this，也就是说，不需要在最后写return this;

 - `xiaoming.constructor === Student.prototype.constructor; // true
Student.prototype.constructor === Student; // true
`//用new Student()创建的对象还从原型上获得了一个constructor属性，它指向函数Student本身.

 - `Student.prototype.hello = function () {};`//如果我们通过new Student()创建了很多对象，这些对象的hello函数实际上只需要共享同一个函数就可以了，这样可以节省很多内存。

 - `function inherits(Child, Parent) {
    var F = function () {};
    F.prototype = Parent.prototype;
    Child.prototype = new F();
    Child.prototype.constructor = Child;
}`

 - `class PrimaryStudent extends Student {
    constructor(name, grade) {
        super(name); // 记得用super调用父类的构造方法!
        this.grade = grade;
    }
    myGrade() {
        alert('I am at grade ' + this.grade);
    }
}`

## 浏览器
### base
 - `alert('window inner size: ' + window.innerWidth + ' x ' + window.innerHeight);`// 可以调整浏览器窗口大小试试

 - 充分利用JavaScript对不存在属性返回undefined的特性，直接用短路运算符||计算：
`var width = window.innerWidth || document.body.clientWidth;`

 - `alert('Screen size = ' + screen.width + ' x ' + screen.height);`//屏幕的信息

 - `http://www.example.com:8080/path/index.html?a=1&b=2#TOP`可以用location.href获取。要获得URL各个部分的值，可以这么写：
`location.protocol; // 'http'
location.host; // 'www.example.com'
location.port; // '8080'
location.pathname; // '/path/index.html'
location.search; // '?a=1&b=2'
location.hash; // 'TOP'`

### reference
[浏览器对象模型](http://www.w3school.com.cn/jsref/dom_obj_window.asp)
[浏览器的信息](http://www.w3school.com.cn/jsref/dom_obj_navigator.asp)
[显示屏幕的信息](http://www.w3school.com.cn/jsref/dom_obj_screen.asp)
[History 对象](http://www.w3school.com.cn/jsref/dom_obj_history.asp)
[当前 URL ](http://www.w3school.com.cn/jsref/dom_obj_location.asp)

### DOM
[Document](http://www.w3school.com.cn/jsref/dom_obj_document.asp)

### COOKIE
 - 服务器在设置Cookie时可以使用httpOnly，设定了httpOnly的Cookie将不能被JavaScript读取。这个行为由浏览器实现，主流浏览器均支持httpOnly选项，IE从IE6 SP1开始支持。