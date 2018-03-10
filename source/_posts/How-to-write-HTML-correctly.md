title: 如何优雅的写HTML
author: 田_田
tags:
  - HTML
categories: []
date: 2016-06-26 11:17:00
---
项目源自 github 的项目 [frontend-guidelines](https://github.com/bendc/frontend-guidelines/blob/master/README.md)，对它做了一个翻译。

<!-- more -->

## HTML文档

### 语义

HTML5为我们提供了许多用于精确描述内容的语义元素，用来确保你可以从其丰富的词汇中获益。

```html
<!-- bad -->
<div id="main">
  <div class="article">
    <div class="header">
      <h1>Blog post</h1>
      <p>Published: <span>21st Feb, 2015</span></p>
    </div>
    <p>…</p>
  </div>
</div>

<!-- good -->
<main>
  <article>
    <header>
      <h1>Blog post</h1>
      <p>Published: <time datetime="2015-02-21">21st Feb, 2015</time></p>
    </header>
    <p>…</p>
  </article>
</main>
```
确保你理解了正在使用元素的语义，用错了比不用还糟糕。


```html
<!-- bad -->
<h1>
  <figure>
    <img alt=Company src=logo.png>
  </figure>
</h1>

<!-- good -->
<h1>
  <img alt=Company src=logo.png>
</h1>
```

### 简明

保持代码简要，不要按照 xhtml 的方法瞎搞。
```html
<!-- bad -->
<!doctype html>
<html lang=en>
  <head>
    <meta http-equiv=Content-Type content="text/html; charset=utf-8" />
    <title>Contact</title>
    <link rel=stylesheet href=style.css type=text/css />
  </head>
  <body>
    <h1>Contact me</h1>
    <label>
      Email address:
      <input type=email placeholder=you@email.com required=required />
    </label>
    <script src=main.js type=text/javascript></script>
  </body>
</html>

<!-- good -->
<!doctype html>
<html lang=en>
  <meta charset=utf-8>
  <title>Contact</title>
  <link rel=stylesheet href=style.css>

  <h1>Contact me</h1>
  <label>
    Email address:
    <input type=email placeholder=you@email.com required>
  </label>
  <script src=main.js></script>
</html>
```

### 易用性

易用性不该忘了，虽然你不需要变成 WCAG [无障碍网页内容指引,Web Content Accessibility Guidelines]专家，但你可以通过一些小改进获得巨大的效益:

* 学习使用 `alt` 元素属性
* 确保 link 和 button 用了正确标签 (别有 `<div class=button>` 这种暴行)
* 不依赖于颜色来传达信息
* 明确标注表单控件

```html
<!-- bad -->
<h1><img alt="Logo" src="logo.png"></h1>

<!-- good -->
<h1><img alt="My Company, Inc." src="logo.png"></h1>
```

### 语言

虽然你不一定需要指定语言和字符编码，但是建议你document的基本声明一下（即使 header 里面已经声明了）。

字符编码推荐 UTF-8。

[中文编码参考资料](http://www.ruanyifeng.com/blog/2007/10/ascii_unicode_and_utf-8.html)

```html
<!-- bad -->
<!doctype html>
<title>Hello, world.</title>

<!-- good -->
<!doctype html>
<html lang=en>
  <meta charset=utf-8>
  <title>Hello, world.</title>
</html>
```

### 性能
除非找了个牛逼的理由把JS脚本放在正文前面，否则应该避免这种阻塞渲染的做法。

如果 CSS 非常重，可以把初始化的时候需要的样式隔离，后续需要的样式放到另一个CSS 文件里延时加载。

两个请求肯定不如一个快，但是更重要的是用户感知的速度。

```html
<!-- bad -->
<!doctype html>
<meta charset=utf-8>
<script src=analytics.js></script>
<title>Hello, world.</title>
<p>...</p>

<!-- good -->
<!doctype html>
<meta charset=utf-8>
<title>Hello, world.</title>
<p>...</p>
<script src=analytics.js></script>
```

## CSS样式

### 分号

因为分号是分隔符，所以应该始终以分号结尾。

```css
/* bad */
div {
  color: red
}

/* good */
div {
  color: red;
}
```

### Box model

理想情况下，整个文档的Box model应该相同。 全局
`* {box-sizing：border-box; }`就行，能不改特定元素的默认框模型
就不要改。

```css
/* bad */
div {
  width: 100%;
  padding: 10px;
  box-sizing: border-box;
}

/* good */
div {
  padding: 10px;
}
```

### Flow
能不改元素的默认行为就不要改，让元素在document里尽可能多地流动。

例如，删除图像下方的空白区域，不应该更改其默认display：

```css
/* bad */
img {
  display: block;
}

/* good */
img {
  vertical-align: middle;
}
```
同理，能不让元素脱离文档流就不要脱离。

```css
/* bad */
div {
  width: 100px;
  position: absolute;
  right: 0;
}

/* good */
div {
  width: 100px;
  margin-left: auto;
}
```

### 改变位置

有很多方法可以在CSS中定位元素，但是用下面这些属性/值的时候尽可能严格要求自己。 按优先顺序：

```
display: block;
display: flex;
position: relative;
position: sticky;
position: absolute;
position: fixed;
```

### 选择器

最小化与DOM紧密耦合的选择器。 选择器超过3个结构伪类、后代或同级组合器时，为要匹配的元素添加一个类。

```css
/* bad */
div:first-of-type :last-child > p ~ *

/* good */
div:first-of-type .info
```

避免重载不必要的选择器
```css
/* bad */
img[src$=svg], ul > li:first-child {
  opacity: 0;
}

/* good */
[src$=svg], ul > :first-child {
  opacity: 0;
}
```

### 准确选择
不要搞得值和选择器难以重构，尽量少用`id`'，尽量不用`!important`.

```css
/* bad */
.bar {
  color: green !important;
}
.foo {
  color: red;
}

/* good */
.foo.bar {
  color: green;
}
.foo {
  color: red;
}
```

### 覆盖
覆盖样式会让调试选择器变难，避免这样做。

```css
/* bad */
li {
  visibility: hidden;
}
li:first-child {
  visibility: visible;
}

/* good */
li + li {
  visibility: hidden;
}
```

### 继承

不要重复可以继承的样式声明。

```css
/* bad */
div h1, div p {
  text-shadow: 0 1px 0 #fff;
}

/* good */
div {
  text-shadow: 0 1px 0 #fff;
}
```

### 简洁性
保持代码精简，使用速记属性，避免用多个不必要的属性。

```css
/* bad */
div {
  transition: all 1s;
  top: 50%;
  margin-top: -10px;
  padding-top: 5px;
  padding-right: 10px;
  padding-bottom: 20px;
  padding-left: 10px;
}

/* good */
div {
  transition: 1s;
  top: calc(50% - 10px);
  padding: 5px 10px 20px;
}
```

### 语言

能用英文的不用数字。

```css
/* bad */
:nth-child(2n + 1) {
  transform: rotate(360deg);
}

/* good */
:nth-child(odd) {
  transform: rotate(1turn);
}
```

### 浏览器引擎前缀
积极的去掉过时前缀。如果需要用前缀要房子标准属性之前。

```css
/* bad */
div {
  transform: scale(2);
  -webkit-transform: scale(2);
  -moz-transform: scale(2);
  -ms-transform: scale(2);
  transition: 1s;
  -webkit-transition: 1s;
  -moz-transition: 1s;
  -ms-transition: 1s;
}

/* good */
div {
  -webkit-transform: scale(2);
  transform: scale(2);
  transition: 1s;
}
```

### 动画

transition比animation好。可以使用`opacity` 和 `transform`的时候避免使用animation。

```css
/* bad */
div:hover {
  animation: move 1s forwards;
}
@keyframes move {
  100% {
    margin-left: 100px;
  }
}

/* good */
div:hover {
  transition: 1s;
  transform: translateX(100px);
}
```

### 单位

尽量使用无单位的数字，如果用相对单位`rem`更好，秒比毫秒好。

```css
/* bad */
div {
  margin: 0px;
  font-size: .9em;
  line-height: 22px;
  transition: 500ms;
}

/* good */
div {
  margin: 0;
  font-size: .9rem;
  line-height: 1.5;
  transition: .5s;
}
```

### 颜色

用透明度就用`rgba`，否则用十六机制数比较好。

```css
/* bad */
div {
  color: hsl(103, 54%, 43%);
}

/* good */
div {
  color: #5a3;
}
```

### 画图

CSS 可以复现的不要用http 请求资源来实现。

```css
/* bad */
div::before {
  content: url(white-circle.svg);
}

/* good */
div::before {
  content: "";
  display: block;
  width: 20px;
  height: 20px;
  border-radius: 50%;
  background: #fff;
}
```

### Hacks

别用

```css
/* bad */
div {
  // position: relative;
  transform: translateZ(0);
}

/* good */
div {
  /* position: relative; */
  will-change: transform;
}
```

## JavaScript

### 性能

可读性，正确性和表现力比性能重要多了。

JS 基本上不会成为你的性能瓶颈。

优化图像压缩，网络访问和DOM回流等功能效果好多了。 

```javascript
// bad (albeit way faster)
const arr = [1, 2, 3, 4];
const len = arr.length;
var i = -1;
var result = [];
while (++i < len) {
  var n = arr[i];
  if (n % 2 > 0) continue;
  result.push(n * n);
}

// good
const arr = [1, 2, 3, 4];
const isEven = n => n % 2 == 0;
const square = n => n * n;

const result = arr.filter(isEven).map(square);
```

### 无状态
保持函数的干净。

理想情况下，所有功能都不会产生副作用、不使用外部数据，并返回新对象、不突变现有的对象。

```javascript
// bad
const merge = (target, ...sources) => Object.assign(target, ...sources);
merge({ foo: "foo" }, { bar: "bar" }); // => { foo: "foo", bar: "bar" }

// good
const merge = (...sources) => Object.assign({}, ...sources);
merge({ foo: "foo" }, { bar: "bar" }); // => { foo: "foo", bar: "bar" }
```

### 原生函数

尽量使用原生函数
```javascript
// bad
const toArray = obj => [].slice.call(obj);

// good
const toArray = (() =>
  Array.from ? Array.from : obj => [].slice.call(obj)
)();
```

### 隐式声明

隐式声明有意义则拥抱，否则避免。不要[cargo-cult](http://baike.baidu.com/link?url=nVBWGg3g52vGmkfkmfg1Z4GXxPmQgCimgmsMfOtxfaXESig_C82Vo0zE506x9DgMtUwsKGFPbQyizBWqSTwgqw3oHvNE9NufgVx921ZuSzIWCkwq-Ju4KBWVtAQUqIAm)，不要相信约翰布鲁姆教。

```javascript
// bad
if (x === undefined || x === null) { ... }

// good
if (x == undefined) { ... }
```

### 循环
不要使用循环去艹可变对象。使用`array.prototype` 方法.

```javascript
// bad
const sum = arr => {
  var sum = 0;
  var i = -1;
  for (;arr[++i];) {
    sum += arr[i];
  }
  return sum;
};

sum([1, 2, 3]); // => 6

// good
const sum = arr =>
  arr.reduce((x, y) => x + y);

sum([1, 2, 3]); // => 6
```
如果不行，用 `array.prototype` 很丑 or 很有争议，用递归。

```javascript
// bad
const createDivs = howMany => {
  while (howMany--) {
    document.body.insertAdjacentHTML("beforeend", "<div></div>");
  }
};
createDivs(5);

// bad
const createDivs = howMany =>
  [...Array(howMany)].forEach(() =>
    document.body.insertAdjacentHTML("beforeend", "<div></div>")
  );
createDivs(5);

// good
const createDivs = howMany => {
  if (!howMany) return;
  document.body.insertAdjacentHTML("beforeend", "<div></div>");
  return createDivs(howMany - 1);
};
createDivs(5);
```


### 参数

忘掉 `arguments` 对象。Rest参数比一个 option 对象要好:

1. 它有名字，能更好的帮助你知道它预期的意义。
2. 数组比较好用

```javascript
// bad
const sortNumbers = () =>
  Array.prototype.slice.call(arguments).sort();

// good
const sortNumbers = (...numbers) => numbers.sort();
```

### Apply

忘了`apply()`，用`...`展开的参数。

```javascript
const greet = (first, last) => `Hi ${first} ${last}`;
const person = ["John", "Doe"];

// bad
greet.apply(null, person);

// good
greet(...person);
```

### Bind

有更好习惯的用法时，不要用`bind()`。

```javascript
// bad
["foo", "bar"].forEach(func.bind(this));

// good
["foo", "bar"].forEach(func, this);
```
```javascript
// bad
const person = {
  first: "John",
  last: "Doe",
  greet() {
    const full = function() {
      return `${this.first} ${this.last}`;
    }.bind(this);
    return `Hello ${full()}`;
  }
}

// good
const person = {
  first: "John",
  last: "Doe",
  greet() {
    const full = () => `${this.first} ${this.last}`;
    return `Hello ${full()}`;
  }
}
```

### 高阶函数

避免不必要的函数嵌套。
```javascript
// bad
[1, 2, 3].map(num => String(num));

// good
[1, 2, 3].map(String);
```

### Composition

避免多层函数嵌套，用composition更好。

```javascript
const plus1 = a => a + 1;
const mult2 = a => a * 2;

// bad
mult2(plus1(5)); // => 12

// good
const pipeline = (...funcs) => val => funcs.reduce((a, b) => b(a), val);
const addThenMult = pipeline(plus1, mult2);
addThenMult(5); // => 12
```

### 缓存

缓存昂贵的操作，包括不限于功能测试、大数据结构等等。

```javascript
// bad
const contains = (arr, value) =>
  Array.prototype.includes
    ? arr.includes(value)
    : arr.some(el => el === value);
contains(["foo", "bar"], "baz"); // => false

// good
const contains = (() =>
  Array.prototype.includes
    ? (arr, value) => arr.includes(value)
    : (arr, value) => arr.some(el => el === value)
)();
contains(["foo", "bar"], "baz"); // => false
```

### 声明变量

`const` > `let` > `var`

```javascript
// bad
var me = new Map();
me.set("name", "Ben").set("country", "Belgium");

// good
const me = new Map();
me.set("name", "Ben").set("country", "Belgium");
```

### 条件语句
[IIFE](https://developer.mozilla.org/zh-CN/docs/Glossary/%E7%AB%8B%E5%8D%B3%E6%89%A7%E8%A1%8C%E5%87%BD%E6%95%B0%E8%A1%A8%E8%BE%BE%E5%BC%8F) 比一堆的 if else 和 switch 要好。

```javascript
// bad
var grade;
if (result < 50)
  grade = "bad";
else if (result < 90)
  grade = "good";
else
  grade = "excellent";

// good
const grade = (() => {
  if (result < 50)
    return "bad";
  if (result < 90)
    return "good";
  return "excellent";
})();
```

### 对象迭代

避免 `for...in`，尽可能函数式编程。

```javascript
const shared = { foo: "foo" };
const obj = Object.create(shared, {
  bar: {
    value: "bar",
    enumerable: true
  }
});

// bad
for (var prop in obj) {
  if (obj.hasOwnProperty(prop))
    console.log(prop);
}

// good
Object.keys(obj).forEach(prop => console.log(prop));
```

### 对象当字典
Maps 比 objects 更强大，有疑问的时候用`Map`。

```javascript
// bad
const me = {
  name: "Ben",
  age: 30
};
var meSize = Object.keys(me).length;
meSize; // => 2
me.country = "Belgium";
meSize++;
meSize; // => 3

// good
const me = new Map();
me.set("name", "Ben");
me.set("age", 30);
me.size; // => 2
me.set("country", "Belgium");
me.size; // => 3
```

### Curry

咖喱是许多开发人员的强大但外来的范式。
不要滥用它，因为适用它的地方很少。

```javascript
// bad
const sum = a => b => a + b;
sum(5)(3); // => 8

// good
const sum = (a, b) => a + b;
sum(5, 3); // => 8
```

### 可读性

不要使用看似聪明的技巧来模糊你的代码的意图。

```javascript
// bad
foo || doSomething();

// good
if (!foo) doSomething();
```
```javascript
// bad
void function() { /* IIFE */ }();

// good
(function() { /* IIFE */ }());
```
```javascript
// bad
const n = ~~3.14;

// good
const n = Math.floor(3.14);
```

### 代码复用

别怕造一堆的可复用的小的函数。

```javascript
// bad
arr[arr.length - 1];

// good
const first = arr => arr[0];
const last = arr => first(arr.slice(-1));
last(arr);
```
```javascript
// bad
const product = (a, b) => a * b;
const triple = n => n * 3;

// good
const product = (a, b) => a * b;
const triple = product.bind(null, 3);
```

### 依赖
尽量最小化依赖，三方代码是你无法掌控的，不要为了一些容易实现的功能区引用一个完整的大库。

```javascript
// bad
var _ = require("underscore");
_.compact(["foo", 0]));
_.unique(["foo", "foo"]);
_.union(["foo"], ["bar"], ["foo"]);

// good
const compact = arr => arr.filter(el => el);
const unique = arr => [...Set(arr)];
const union = (...arr) => unique([].concat(...arr));

compact(["foo", 0]);
unique(["foo", "foo"]);
union(["foo"], ["bar"], ["foo"]);
```