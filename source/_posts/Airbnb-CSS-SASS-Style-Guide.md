title: Airbnb CSS / SASS Style Guide
author: 田_田
tags:
  - CSS
categories: []
date: 2017-10-26 14:36:00
---

*A mostly reasonable approach to CSS and Sass*
*一个最讲道理的CSS、Sass指南*

<!-- more -->


## 术语

### 规则声明

“规则声明”是说伴随一组属性的选择器（或者一个组选择器）：

```css
.listing {
  font-size: 18px;
  line-height: 1.2;
}
```

### 选择器

规则声明的时候，选择器负责选择需要被修改样式的元素。选择器可以匹配 HTML 元素，元素的类，ID，或者任何一个属性：

```css
.my-element-class {
  /* ... */
}

[aria-hidden] {
  /* ... */
}
```

### 属性
最好，属性负责告诉被选择元素的样式规则声明。属性是一个键值对，一个规则声明可以包括一个或者多个属性：


```css
/* some selector */ {
  background: #f1f1f1;
  color: #333;
}
```


## CSS

### 格式

* 语法缩进使用两个空格
* 横线连接的类名比小驼峰要好
  - 如果使用 BEM 下划线和帕斯卡命名都可以，后面有详细说
* 不要使用 ID 选择器
* 同一个规则声明里，如果有多个选择器，让他们每个占据一行
* 左花括号`{`前面应该有一个空格
* 属性里`:`字符后面应该有空格，前面没有
* 右花括号`}`需要新建一行
* 规则声明之间放空行


**不好的例子**

```css
.avatar{
    border-radius:50%;
    border:2px solid white; }
.no, .nope, .not_good {
    // ...
}
#lol-no {
  // ...
}
```

**Good**

```css
.avatar {
  border-radius: 50%;
  border: 2px solid white;
}

.one,
.selector,
.per-line {
  // ...
}
```

### 注释

* 行注释比块注释要好`//`
* 注释最好单独放一行，避免放在代码行末
* 不能自解释的代码加上细节注释:
  - 用 z-index
  - 浏览器特殊黑科技

### OOCSS 和 BEM

我们鼓励组合 OOCSS 和 BEM, 原因：
  * 它帮助 CSS 和 HTML 建立更加清晰严谨的关系
  * 它帮助建立可复用的、更容易整理的组件
  * 它考虑了如何更少的嵌套和降低专一性
  * 它帮助创建可复用的样式表

**OOCSS**, or “面向对象CSS”, 是一个写 CSS 的准则，鼓励你考虑样式表的时候像一个集合的对象：可复用，重复的代码片段自始至终可以独立使用。

  * Nicole Sullivan's [OOCSS wiki](https://github.com/stubbornella/oocss/wiki)
  * Smashing Magazine's [Introduction to OOCSS](http://www.smashingmagazine.com/2011/12/12/an-introduction-to-object-oriented-css-oocss/)

**BEM**, or “Block-Element-Modifier 块元素修饰符”, 是一个 HTML 和 CSS 的命名约定。最开始是 Yandex 为了复用巨大的代码库，后来逐步演化成 OOCSS 的一种固定的实现。

  * CSS Trick's [BEM 101](https://css-tricks.com/bem-101/)
  * Harry Roberts' [introduction to BEM](http://csswizardry.com/2013/01/mindbemding-getting-your-head-round-bem-syntax/)

我们推荐使用帕斯卡命名的“块”BEM变体，当与组件（例如React）组合时，该变体的工作特别好。 下划线和破折号仍然用于修饰符和子元素。


**Example**

```jsx
// ListingCard.jsx
function ListingCard() {
  return (
    <article class="ListingCard ListingCard--featured">

      <h1 class="ListingCard__title">Adorable 2BR in the sunny Mission</h1>

      <div class="ListingCard__content">
        <p>Vestibulum id ligula porta felis euismod semper.</p>
      </div>

    </article>
  );
}
```

```css
/* ListingCard.css */
.ListingCard { }
.ListingCard--featured { }
.ListingCard__title { }
.ListingCard__content { }
```

  * `.ListingCard` 是一个“block”，代表更高层次的组件
  * `.ListingCard__title` 是一个“element”，代表`.ListingCard`的子节点，这样可以帮助把整个块写成一个
  * `.ListingCard--featured` 是一个 “modifier”，它代表一个在`.ListingCard`块上的不同状态或变化.

### ID 选择器

虽然 CSS 里面可以使用 ID 选择器，但是这会被认为是反模式的。ID 选择器引入了一个不必要的高层次特性[specificity](https://developer.mozilla.org/en-US/docs/Web/CSS/Specificity)来规则声明，他们不可复用。

想了解更多，可以读[CSS Wizardry's article](http://csswizardry.com/2014/07/hacks-for-dealing-with-specificity/) 讨论了这个特性.

### JavaScript hooks

避免在CSS和JavaScript中绑定到同一个类。 当开发人员必须交叉引用他们正在改变的每个类时，合并这两者往往导致在重构过程中浪费的时间，最糟糕的是，开发人员害怕进行了功能破坏。

我们推荐创建JavaScript-specific的类来绑定，加上后缀`.js-`:

```html
<button class="btn btn-primary js-request-to-book">Request to Book</button>
```

### 边界

用`0`而不是`none`来指定一个没有边界的样式。


**Bad**

```css
.foo {
  border: none;
}
```

**Good**

```css
.foo {
  border: 0;
}
```


## Sass

### 语法

* 用`.scss`语法，不要用`.sass`语法
* 你的 CSS and `@include`声明应该逻辑上有序(看后面)

### 属性定义的顺序

1. 属性定义

     列出所有的标准属性，所有不是 `@include` 或者递归的选择器。

    ```scss
    .btn-green {
      background: green;
      font-weight: bold;
      // ...
    }
    ```

2. `@include` 声明

    把`@include`放一起，可以更容易的读整个选择器

    ```scss
    .btn-green {
      background: green;
      font-weight: bold;
      @include transition(background 0.5s ease);
      // ...
    }
    ```

3. 嵌套选择器

    嵌套选择器，如果有必要，放最后，之后别有其他东西。 你规则声明和递归选择器之间加上空白，两个选择器之间也加上。里面的嵌套选择器也遵循这套准则。

    ```scss
    .btn {
      background: green;
      font-weight: bold;
      @include transition(background 0.5s ease);

      .icon {
        margin-right: 10px;
      }
    }
    ```

### 变量

和小驼峰camelCased还有蛇形snake_cased命名，更倾向于横线命名法(e.g. `$my-variable`)。下划线前缀只在同一个文件内使用可以接受。


### Mixins


Mixin 用来保障你的代码不会重复。增加清晰度，或者抽象复杂的东西，和函数命好名一样的方式。没有参数的Mixins可以用来做这个，但是如果你没有压缩你的荷载，可能需要重复你没有用的样式。


### Extend 指令


`@extend` 应该尽量避免。因为他有反直觉和潜在的危险习惯，尤其是使用递归的选择器。甚至extend高层次占位符选择器可以由于选择器顺序改变引起问题（比如其他文件有同样的选择器，然后加载顺序混乱了）。Gzip压缩可以无副作用地解决大部分`@extend`的问题，而且很好的满足 DRY 原则。


### 嵌套选择器

**嵌套不要超过三层**

```scss
.page-container {
  .content {
    .profile {
      // STOP!
    }
  }
}
```

选择器很长的时候，你可能是这样写 CSS的：

* 强行耦合到HTML（弱）* -OR- *
* 过度具体（强）* -OR- *
* 不可重用

Again: **打死不要用嵌套 ID 选择器!**

如果你非要用 ID 选择器在第一个地方（你真的不该尝试），他们也不应该嵌套。如果你发现你这么干了，你应该重新浏览你的标记，找出为什么你需要这么强的专一性。如果你写了优美形式的 HTML 和 CSS，你**不应该**这么做。