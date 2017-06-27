title: CSS样式笔记
author: 田_田
tags:
  - HTML
categories: []
date: 2016-09-20 19:06:00
---
记录一下近期写 css 用到的一些属性。然后把相关的东西仔细查了一下。

<!-- more -->

# 选择器
## 基本常识
### 选择器大小写不敏感

选择器语法不是大小写敏感的，a:hover等价于a:HOVER，但标签名和属性名以及属性值是大小写敏感的（取决于HTML，必须保持一致）

### 选择器的分类

type selector——类型选择器（标记选择器）
universal selector——通配选择器
attribute selector——属性选择器
class selector——类选择器
ID selector——ID选择器
pseudo-class——伪类

### 伪类&&伪元素
形式上，伪类有一个冒号，而伪元素有两个冒号。

意义上，伪类相当于给现有元素添加了class属性值，而伪元素相当于创建了一个新的元素。
```
p:first-child匹配p的第一个子元素，相当给第一个子元素设置了匿名class；
p::first-line匹配段落第一行内容，相当于创建了一个span）
特别的，伪类要遵循LVHA爱恨原则；
before, after不是伪类而是伪元素（最容易混淆，原因是浏览器兼容问题——某些浏览器不支持双冒号）
```

### 选择器特殊性计算

特殊性高的样式会覆盖特殊性低的样式，比如：
```
#cnblogspost_body > p          {/*style1*/}
p                              {/*style2*/}
{/*共存时，表现出来的是特殊性更高的style1，*/}
```

特殊性的计算规则如下：
```
a = ID选择器的个数
b = （类选择器 + 属性选择器 + 伪类）的个数
c = （标记选择器 + 伪元素）的个数
```
P.S.1.忽略通配选择器

P.S.2.取反选择器不算数（取反选择器本身不计入伪类的个数，但左右的都算），例如#s12:not(FOO) /* a=1 b=0 c=1 -> specificity = 101 */

P.S.3.重复出现相同的简单选择器都算有效计数

## 常用选择器

| 选择器 | 例子 | 例子描述 | CSS |
| :------| :------ | :------| :------ |
| .class | .intro | 选择 class="intro" 的所有元素。 | 1 |
| #id | #firstname | 选择 id="firstname" 的所有元素。 | 1 |
| * | * | 选择所有元素。 | 2 |
| element | p | 选择所有 `<p>` 元素。 | 1 |
| element,element | div,p | 选择所有 `<div>` 元素和所有 `<p>` 元素。 | 1 |
| element element | div p | 选择 `<div>` 元素内部的所有 `<p>` 元素。 | 1 |
| element>element | div>p | 选择父元素为 `<div>` 元素的所有 `<p>` 元素。 | 2 |
| element+element | div+p | 选择紧接在 `<div>` 元素之后的所有 `<p>` 元素。 | 2 |
| [attribute] | [target] | 选择带有 target 属性所有元素。 | 2 |
| [attribute=value] | [target=_blank] | 选择 target="_blank" 的所有元素。 | 2 |
| [attribute~=value] | [title~=flower] | 选择 title 属性包含单词 "flower" 的所有元素。 | 2 |
| [attribute&#124;=value] | [lang&#124;=en] | 选择 lang 属性值以 "en" 开头的所有元素。 | 2 |
| :link | a:link | 选择所有未被访问的链接。 | 1 |
| :visited | a:visited | 选择所有已被访问的链接。 | 1 |
| :active | a:active | 选择活动链接。 | 1 |
| :hover | a:hover | 选择鼠标指针位于其上的链接。 | 1 |
| :focus | input:focus | 选择获得焦点的 input 元素。 | 2 |
| :first-letter | p:first-letter | 选择每个 `<p>` 元素的首字母。 | 1 |
| :first-line | p:first-line | 选择每个 `<p>` 元素的首行。 | 1 |
| :first-child | p:first-child | 选择属于父元素的第一个子元素的每个 `<p>` 元素。 | 2 |
| :before | p:before | 在每个 `<p>` 元素的内容之前插入内容。 | 2 |
| :after | p:after | 在每个 `<p>` 元素的内容之后插入内容。 | 2 |
| :lang(language) | p:lang(it) | 选择带有以 "it" 开头的 lang 属性值的每个 `<p>` 元素。 | 2 |
| element1~element2 | p~ul | 选择前面有 `<p>` 元素的每个 <ul> 元素。 | 3 |
| [attribute^=value] | a[src^="https"] | 选择其 src 属性值以 "https" 开头的每个 `<a>` 元素。 | 3 |
| [attribute$=value] | a[src$=".pdf"] | 选择其 src 属性以 ".pdf" 结尾的所有 `<a>` 元素。 | 3 |
| [attribute*=value] | a[src*="abc"] | 选择其 src 属性中包含 "abc" 子串的每个 `<a>` 元素。 | 3 |
| :first-of-type | p:first-of-type | 选择属于其父元素的首个 `<p>` 元素的每个 `<p>` 元素。 | 3 |
| :last-of-type | p:last-of-type | 选择属于其父元素的最后 `<p>` 元素的每个 `<p>` 元素。 | 3 |
| :only-of-type | p:only-of-type | 选择属于其父元素唯一的 `<p>` 元素的每个 `<p>` 元素。 | 3 |
| :only-child | p:only-child | 选择属于其父元素的唯一子元素的每个 `<p>` 元素。 | 3 |
| :nth-child(n) | p:nth-child(2) | 选择属于其父元素的第二个子元素的每个 `<p>` 元素。 | 3 |
| :nth-last-child(n) | p:nth-last-child(2) | 同上，从最后一个子元素开始计数。 | 3 |
| :nth-of-type(n) | p:nth-of-type(2) | 选择属于其父元素第二个 `<p>` 元素的每个 `<p>` 元素。 | 3 |
| :nth-last-of-type(n) | p:nth-last-of-type(2) | 同上，但是从最后一个子元素开始计数。 | 3 |
| :last-child | p:last-child | 选择属于其父元素最后一个子元素每个 `<p>` 元素。 | 3 |
| :root | :root | 选择文档的根元素。 | 3 |
| :empty | p:empty | 选择没有子元素的每个 `<p>` 元素（包括文本节点）。 | 3 |
| :target | #news:target | 选择当前活动的 #news 元素。 | 3 |
| :enabled | input:enabled | 选择每个启用的 `<input>` 元素。 | 3 |
| :disabled | input:disabled | 选择每个禁用的 `<input>` 元素 | 3 |
| :checked | input:checked | 选择每个被选中的 `<input>` 元素。 | 3 |
| :not(selector) | :not(p) | 选择非 `<p>` 元素的每个元素。 | 3 |
| ::selection | ::selection | 选择被用户选取的元素部分。 | 3 |




# 定位
## flex笔记
现在的浏览器对 flex 的支持非常好，因此如果不能一眼想好怎么用 absolute 和 float 实现的布局都可以使用 flex。
### 期望
```
在任何流动的方向上(包括上下左右)都能进行良好的布局
可以以逆序 或者 以任意顺序排列布局
可以线性的沿着主轴一字排开 或者 沿着侧轴换行排列
可以弹性的在任意的容器中伸缩大小（今天重点研究的主题）
可以使子元素们在容器主轴方向上 或者 在容器侧轴方向上 进行对齐
可以动态的 沿着主轴方向 伸缩子级的尺寸，与此同时保证父级侧轴方向上的尺寸
```
### 基本概念
- 设为 Flex 布局以后，子元素的float、clear和vertical-align属性将失效。
- 容器默认存在两根轴：水平的主轴（main axis）和垂直的交叉轴（cross axis）。
 - 主轴的开始位置（与边框的交叉点）叫做main start，结束位置叫做main end；
 - 交叉轴的开始位置叫做cross start，结束位置叫做cross end。
- 项目默认沿主轴排列。
- 单个项目占据的主轴空间叫做main size，占据的交叉轴空间叫做cross size。
阮老师的两篇文章：

这一篇可以当字典用 [Flex 布局教程](http://www.ruanyifeng.com/blog/2015/07/flex-grammar.html)

这一篇可以辅助理解 [Flex 布局教程](http://www.ruanyifeng.com/blog/2015/07/flex-examples.html)

### 备忘
```
主轴的方向
flex-direction: row | row-reverse | column | column-reverse;
如何换行
flex-wrap: nowrap | wrap | wrap-reverse;
主轴对齐方式
justify-content: flex-start | flex-end | center | space-between | space-around;
交叉轴如何对齐
align-items: flex-start | flex-end | center | baseline | stretch;
多根轴线的对齐方式
align-content
align-content: flex-start | flex-end | center | space-between | space-around | stretch;

flex属性是flex-grow, flex-shrink 和 flex-basis的简写，默认值为0 1 auto。
存在剩余空间，放大flex-grow倍，默认为0，即如果存在剩余空间，也不放大。
空间不足，缩小flex-shrink倍，默认为1，即如果空间不足，该项目将缩小。
分配多余空间之前项目占据的主轴空间flex-basis。默认值为auto，即项目的本来大小。
flex: none | [ <'flex-grow'> <'flex-shrink'>? || <'flex-basis'> ]
```


# 杂七杂八
## 常用常查的
```
border-radius: 30px;
圆角
box-shadow: 3px 3px 4px #ffffff; 
盒状阴影|  x轴偏移值、y轴偏移值、阴影的模糊度、以及阴影颜色。
background: linear-gradient(to bottom, blue, white);
background: linear-gradient(<angle>, blue, white 80%, orange);
线性渐变
background: linear-gradient(to right, rgba(255,255,255,0), rgba(255,255,255,1)), url(http://foo.com/image.jpg);
图片线性渐变透明 | 0为透明，1为不透
background: repeating-linear-gradient(-45deg, red, red 5px, white 5px, white 10px);
重复的线性渐变

background: radial-gradient(red 5%, yellow 25%, #1E90FF 50%);
径向渐变
background: radial-gradient(ellipse closest-side, red, yellow 10%, #1E90FF 50%, white);
椭圆的渐变
background: repeating-radial-gradient(black, black 5px, white 5px, white 10px);
重复的径向渐变


background-color: rgba(180, 180, 144, 0.6); 
opacity:0.5;
透明度

```
[旋转拉伸](http://www.daqianduan.com/2959.html)

可以实现立体效果，远近效果，3D房间效果等等

## 工具
### compass
```
@import "compass/css3";
.rounded {
    @include border-radius(5px);
}
```
编译成如下代码，帮助做好适配工作：
```
.rounded {
    -moz-border-radius: 5px;
    -webkit-border-radius: 5px;
    -o-border-radius: 5px;
    -ms-border-radius: 5px;
    -khtml-border-radius: 5px;
    border-radius: 5px;
}
```

更加具体的介绍可以看这个链接： [SASS 和 Compass 指南](https://ruby-china.org/topics/4396)