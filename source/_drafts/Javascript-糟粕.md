title: Javascript 糟粕
author: 田_田
date: 2017-07-28 15:04:16
tags:
---
记录一下辣鸡特性
<!-- more -->
### x 和 !x不一定互斥
x 可以是 undefined
```
x = undefined
x==false
x===false
!x==false
!x===false
// All TM of those are false
```

### 变量定义
[一道常被人轻视的前端JS面试题](http://www.cnblogs.com/xxcanghai/p/5189353.html)
```
function Foo() {
    getName = function () { alert (1); };
    return this;
}
Foo.getName = function () { alert (2);};
Foo.prototype.getName = function () { alert (3);};
var getName = function () { alert (4);};
function getName() { alert (5);}

//答案：
Foo.getName();//2
getName();//4
Foo().getName();//1
getName();//1
new Foo.getName();//2
new Foo().getName();//3
new new Foo().getName();//3
```



### 相等比较九九乘法表
[javascript 相等比较](https://developer.mozilla.org/zh-TW/docs/Web/JavaScript/Equality_comparisons_and_sameness)
```
var num = 0;
var obj = new String("0");
var str = "0";
var b = false;

console.log(num === num); // true
console.log(obj === obj); // true
console.log(str === str); // true

console.log(num === obj); // false
console.log(num === str); // false
console.log(obj === str); // false
console.log(null === undefined); // false
console.log(obj === null); // false
console.log(obj === undefined); // false
```