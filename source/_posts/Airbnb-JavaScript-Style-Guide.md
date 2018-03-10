title: Airbnb JavaScript Style Guide (1)
author: 田_田
tags:
  - JavaScript
  - Language
categories: []
date: 2013-07-28 16:22:00
---

*A mostly reasonable approach to JavaScript*
*一个最讲道理的JavaScript方法论*
<!-- more -->

Other Style Guides

  - [ES5 (Deprecated)](https://github.com/airbnb/javascript/tree/es5-deprecated/es5)
  - [React](react/)
  - [CSS-in-JavaScript](css-in-javascript/)
  - [CSS & Sass](https://github.com/airbnb/css)
  - [Ruby](https://github.com/airbnb/ruby)

## 目录
略
## Types 类型
  - [1.1] **Primitives**: When you access a primitive type you work directly on its value.
  **基本类型**: 存取原始值的时候直接操作它的值。
    - `string`
    - `number`
    - `boolean`
    - `null`
    - `undefined`

    ```javascript
    const foo = 1;
    let bar = foo;

    bar = 9;

    console.log(foo, bar); // => 1, 9
    ```

  - [1.2]  **Complex**: When you access a complex type you work on a reference to its value.
  **复杂类型**: 存取复杂值的时候直接操作它的引用。

    - `object`
    - `array`
    - `function`

    ```javascript
    const foo = [1, 2];
    const bar = foo;

    bar[0] = 9;

    console.log(foo[0], bar[0]); // => 9, 9
    ```

## References 引用

  - [2.1] Use `const` for all of your references; avoid using `var`. eslint: [`prefer-const`](http://eslint.org/docs/rules/prefer-const.html), [`no-const-assign`](http://eslint.org/docs/rules/no-const-assign.html)
  所有引用都使用 `const` ，避免使用 `var`。

    > Why? This ensures that you can’t reassign your references, which can lead to bugs and difficult to comprehend code.
    
    > 为什么？这样可以保证你不重新赋值引用导致 bug，另外更加容易理解。

    ```javascript
    // bad
    var a = 1;
    var b = 2;

    // good
    const a = 1;
    const b = 2;
    ```

  - [2.2] If you must reassign references, use `let` instead of `var`. eslint: [`no-var`](http://eslint.org/docs/rules/no-var.html) jscs: [`disallowVar`](http://jscs.info/rule/disallowVar)
  如果一定要重新赋值，用 `let` 而不是 `var`。

    > Why? `let` is block-scoped rather than function-scoped like `var`. 
    
    > 为什么? `let` 其作用域为该语句所在的代码块，而不像 `var` 的作用域为该语句所在的函数。  PS：`let` 没有变量提升。
    
    ```javascript
    // bad
    var count = 1;
    if (true) {
      count += 1;
    }

    // good, use the let.
    let count = 1;
    if (true) {
      count += 1;
    }
    ```
    
  - [2.3] Note that both `let` and `const` are block-scoped.
  注意`let` 和 `const` 都是块作用域。

    ```javascript
    // const and let only exist in the blocks they are defined in.
    {
      let a = 1;
      const b = 1;
    }
    console.log(a); // ReferenceError
    console.log(b); // ReferenceError
    ```

## Objects  对象
  - [3.1]  Use the literal syntax for object creation. eslint: [`no-new-object`](http://eslint.org/docs/rules/no-new-object.html)
  创建对象的时候使用字面语法。

    ```javascript
    // bad
    const item = new Object();

    // good
    const item = {};
    ```
  - [3.2] Use computed property names when creating objects with dynamic property names.
  有动态计算属性名需求的时候使用计算属性名。

    > Why? They allow you to define all the properties of an object in one place.
    
    > 为什么？他们允许你在一个地方定义一个对象所有的属性。
    
    ```javascript
    function getKey(k) {
      return `a key named ${k}`;
    }

    // bad
    const obj = {
      id: 5,
      name: 'San Francisco',
    };
    obj[getKey('enabled')] = true;

    // good
    const obj = {
      id: 5,
      name: 'San Francisco',
      [getKey('enabled')]: true,
    };
    ```

  - [3.3] Use object method shorthand. eslint: [`object-shorthand`](http://eslint.org/docs/rules/object-shorthand.html) jscs: [`requireEnhancedObjectLiterals`](http://jscs.info/rule/requireEnhancedObjectLiterals)
  使用速记法的对象方法。

    ```javascript
    // bad
    const atom = {
      value: 1,

      addValue: function (value) {
        return atom.value + value;
      },
    };

    // good
    const atom = {
      value: 1,

      addValue(value) {
        return atom.value + value;
      },
    };
    ```
  - [3.4] Use property value shorthand. eslint: [`object-shorthand`](http://eslint.org/docs/rules/object-shorthand.html) jscs: [`requireEnhancedObjectLiterals`](http://jscs.info/rule/requireEnhancedObjectLiterals)
  使用速记法的对象属性。

    > Why? It is shorter to write and descriptive.
    
    > 为什么？写起来和描述更短。

    ```javascript
    const lukeSkywalker = 'Luke Skywalker';

    // bad
    const obj = {
      lukeSkywalker: lukeSkywalker,
    };

    // good
    const obj = {
      lukeSkywalker,
    };
    ```

  - [3.5] Group your shorthand properties at the beginning of your object declaration.
  给你的速记对象分组并放在对象定义的头部。

    > Why? It’s easier to tell which properties are using the shorthand.
    > 为什么？更容易了解哪些变量使用了速记法。

    ```javascript
    const anakinSkywalker = 'Anakin Skywalker';
    const lukeSkywalker = 'Luke Skywalker';

    // bad
    const obj = {
      episodeOne: 1,
      twoJediWalkIntoACantina: 2,
      lukeSkywalker,
      episodeThree: 3,
      mayTheFourth: 4,
      anakinSkywalker,
    };

    // good
    const obj = {
      lukeSkywalker,
      anakinSkywalker,
      episodeOne: 1,
      twoJediWalkIntoACantina: 2,
      episodeThree: 3,
      mayTheFourth: 4,
    };
    ```

  - [3.6] Only quote properties that are invalid identifiers. eslint: [`quote-props`](http://eslint.org/docs/rules/quote-props.html) jscs: [`disallowQuotedKeysInObjects`](http://jscs.info/rule/disallowQuotedKeysInObjects)
  只有属性名不合法的时候使用引号。

    > Why? In general we consider it subjectively easier to read. It improves syntax highlighting, and is also more easily optimized by many JS engines.
    
    > 为什么？一般来说我们主观上认为它更容易阅读，它提升了语法高亮，还更容易被 JS 引擎优化。
    

    ```javascript
    // bad
    const bad = {
      'foo': 3,
      'bar': 4,
      'data-blah': 5,
    };

    // good
    const good = {
      foo: 3,
      bar: 4,
      'data-blah': 5,
    };
    ```

  - [3.7] Do not call `Object.prototype` methods directly, such as `hasOwnProperty`, `propertyIsEnumerable`, and `isPrototypeOf`.
  不要直接调用 `Object.prototype` 的方法，比如`hasOwnProperty`，`propertyIsEnumerable` 和 `isPrototypeOf`。

    > Why? These methods may be shadowed by properties on the object in question - consider `{ hasOwnProperty: false }` - or, the object may be a null object (`Object.create(null)`).
    > 为什么？ 这些方法可能被属性遮挡掉，考虑这种情况`{ hasOwnProperty: false }` 或者它本身是个空对象(`Object.create(null)`).

    ```javascript
    // bad
    console.log(object.hasOwnProperty(key));

    // good
    console.log(Object.prototype.hasOwnProperty.call(object, key));

    // best
    const has = Object.prototype.hasOwnProperty; // cache the lookup once, in module scope.
    /* or */
    import has from 'has';
    // ...
    console.log(has.call(object, key));
    ```

  - [3.8]  Prefer the object spread operator over [`Object.assign`](https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Global_Objects/Object/assign) to shallow-copy objects. Use the object rest operator to get a new object with certain properties omitted.
  浅拷贝对象最好通过 `Object.assign` 传递对象。使用对象剩余操作符来得到包含省略属性的新对象。

    ```javascript
    // very bad
    const original = { a: 1, b: 2 };
    const copy = Object.assign(original, { c: 3 }); // this mutates `original` ಠ_ಠ
    delete copy.a; // so does this

    // bad
    const original = { a: 1, b: 2 };
    const copy = Object.assign({}, original, { c: 3 }); // copy => { a: 1, b: 2, c: 3 }

    // good
    const original = { a: 1, b: 2 };
    const copy = { ...original, c: 3 }; // copy => { a: 1, b: 2, c: 3 }

    const { a, ...noA } = copy; // noA => { b: 2, c: 3 }
    //PS: ES7 feature
    ```


## Arrays 数组

  - [4.1] Use the literal syntax for array creation. eslint: [`no-array-constructor`](http://eslint.org/docs/rules/no-array-constructor.html)
  数组创建使用字面语法。

    ```javascript
    // bad
    const items = new Array();

    // good
    const items = [];
    ```

  - [4.2] Use [Array#push](https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Global_Objects/Array/push) instead of direct assignment to add items to an array.
  使用 Array.push 而不要直接通过直接赋值来添加元素

    ```javascript
    const someStack = [];

    // bad
    someStack[someStack.length] = 'abracadabra';

    // good
    someStack.push('abracadabra');
    ```

  - [4.3] Use array spreads `...` to copy arrays.
  使用数组传递 `...` 来拷贝数组。

    ```javascript
    // bad
    const len = items.length;
    const itemsCopy = [];
    let i;

    for (i = 0; i < len; i += 1) {
      itemsCopy[i] = items[i];
    }

    // good
    const itemsCopy = [...items];
    ```
    
  - [4.4] To convert an array-like object to an array, use [Array.from](https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Global_Objects/Array/from).
  使用 Array.from 来把长得像数组的对象转换成数组。

    ```javascript
    const foo = document.querySelectorAll('.foo');
    const nodes = Array.from(foo);
    
    //PS: array-like object是有 length 属性且key为非负数的对象
    //const x = {1:1,2:3,3:8,length:4}
    //const y = Array.from(x)
    ```

  - [4.5] Use return statements in array method callbacks. It’s ok to omit the return if the function body consists of a single statement returning an expression without side effects, following [8.2]. eslint: [`array-callback-return`](http://eslint.org/docs/rules/array-callback-return)
  在数组回调方法里使用返回语句。如果函数主体只有一个句子，且返回无副作用的表达式，可以省略 return。 

    ```javascript
    // good
    [1, 2, 3].map((x) => {
      const y = x + 1;
      return x * y;
    });

    // good
    [1, 2, 3].map(x => x + 1);

    // bad
    const flat = {};
    [[0, 1], [2, 3], [4, 5]].reduce((memo, item, index) => {
      const flatten = memo.concat(item);
      flat[index] = flatten;
    });

    // good
    const flat = {};
    [[0, 1], [2, 3], [4, 5]].reduce((memo, item, index) => {
      const flatten = memo.concat(item);
      flat[index] = flatten;
      return flatten;
    });

    // bad
    inbox.filter((msg) => {
      const { subject, author } = msg;
      if (subject === 'Mockingbird') {
        return author === 'Harper Lee';
      } else {
        return false;
      }
    });

    // good
    inbox.filter((msg) => {
      const { subject, author } = msg;
      if (subject === 'Mockingbird') {
        return author === 'Harper Lee';
      }

      return false;
    });
    ```

  - [4.6] Use line breaks after open and before close array brackets if an array has multiple lines.
  如果一个数组有多行，在左数组括号之前或者右数组括号之后使用分行。

  ```javascript
  // bad
  const arr = [
    [0, 1], [2, 3], [4, 5],
  ];

  const objectInArray = [{
    id: 1,
  }, {
    id: 2,
  }];

  const numberInArray = [
    1, 2,
  ];

  // good
  const arr = [[0, 1], [2, 3], [4, 5]];

  const objectInArray = [
    {
      id: 1,
    },
    {
      id: 2,
    },
  ];

  const numberInArray = [
    1,
    2,
  ];
  ```


## Destructuring 解构

  - [5.1] Use object destructuring when accessing and using multiple properties of an object. jscs: [`requireObjectDestructuring`](http://jscs.info/rule/requireObjectDestructuring)
  当存取或者使用一个对象的多个属性时，使用对象解构。

    > Why? Destructuring saves you from creating temporary references for those properties.
    > 为什么？ 解构可以帮助你为这些属性创建临时的引用。

    ```javascript
    // bad
    function getFullName(user) {
      const firstName = user.firstName;
      const lastName = user.lastName;

      return `${firstName} ${lastName}`;
    }

    // good
    function getFullName(user) {
      const { firstName, lastName } = user;
      return `${firstName} ${lastName}`;
    }

    // best
    function getFullName({ firstName, lastName }) {
      return `${firstName} ${lastName}`;
    }
    ```
    
  - [5.2]Use array destructuring. jscs: [`requireArrayDestructuring`](http://jscs.info/rule/requireArrayDestructuring)
  使用数组解构。

    ```javascript
    const arr = [1, 2, 3, 4];

    // bad
    const first = arr[0];
    const second = arr[1];

    // good
    const [first, second] = arr;
    ```

  - [5.3] Use object destructuring for multiple return values, not array destructuring. jscs: [`disallowArrayDestructuringReturn`](http://jscs.info/rule/disallowArrayDestructuringReturn)
  为了返回对个值可以使用对象解构，不要用数组解构。

    > Why? You can add new properties over time or change the order of things without breaking call sites.
    
    > 为什么？ 过一段时间你还可以加新的属性，改变东西的顺序的时候不改变调用函数。

    ```javascript
    // bad
    function processInput(input) {
      // then a miracle occurs
      return [left, right, top, bottom];
    }

    // the caller needs to think about the order of return data
    const [left, __, top] = processInput(input);

    // good
    function processInput(input) {
      // then a miracle occurs
      return { left, right, top, bottom };
    }

    // the caller selects only the data they need
    const { left, top } = processInput(input);
    ```

## Strings 字符串

  - [6.1] Use single quotes `''` for strings. eslint: [`quotes`](http://eslint.org/docs/rules/quotes.html) jscs: [`validateQuoteMarks`](http://jscs.info/rule/validateQuoteMarks)
  使用单引号当字符串。

    ```javascript
    // bad
    const name = "Capt. Janeway";

    // bad - template literals should contain interpolation or newlines
    //模板语法应该包含插入变量或者本身是多行
    const name = `Capt. Janeway`;

    // good
    const name = 'Capt. Janeway';
    ```

  - [6.2] Strings that cause the line to go over 100 characters should not be written across multiple lines using string concatenation.
  导致某行超过100个字符的字符串应该使用连接符写成多行。

    > Why? Broken strings are painful to work with and make code less searchable.
    
    > 为什么？ 打断字符串是一个十分蛋疼的事情，导致它不好被搜索。

    ```javascript
    // bad
    const errorMessage = 'This is a super long error that was thrown because \
    of Batman. When you stop to think about how Batman had anything to do \
    with this, you would get nowhere \
    fast.';

    // bad
    const errorMessage = 'This is a super long error that was thrown because ' +
      'of Batman. When you stop to think about how Batman had anything to do ' +
      'with this, you would get nowhere fast.';

    // good
    const errorMessage = 'This is a super long error that was thrown because of Batman. When you stop to think about how Batman had anything to do with this, you would get nowhere fast.';
    ```
    
  - [6.3]When programmatically building up strings, use template strings instead of concatenation. eslint: [`prefer-template`](http://eslint.org/docs/rules/prefer-template.html) [`template-curly-spacing`](http://eslint.org/docs/rules/template-curly-spacing) jscs: [`requireTemplateStrings`](http://jscs.info/rule/requireTemplateStrings)
  用编程的方式构建字符串的时候，应该使用模板字符串而不是连接符。

    > Why? Template strings give you a readable, concise syntax with proper newlines and string interpolation features.
    
    > 为什么？模板字符串给了一个更可读，更简明的语法来包含换行符和插入字符串变量。

    ```javascript
    // bad
    function sayHi(name) {
      return 'How are you, ' + name + '?';
    }

    // bad
    function sayHi(name) {
      return ['How are you, ', name, '?'].join();
    }

    // bad
    function sayHi(name) {
      return `How are you, ${ name }?`;
    }

    // good
    function sayHi(name) {
      return `How are you, ${name}?`;
    }
    ```
  - [6.4] Never use `eval()` on a string, it opens too many vulnerabilities. eslint: [`no-eval`](http://eslint.org/docs/rules/no-eval)
  永远不要在字符串里面使用 eval() ，这玩意缺陷太多。

  - [6.5] Do not unnecessarily escape characters in strings. eslint: [`no-useless-escape`](http://eslint.org/docs/rules/no-useless-escape)
  字符串里不要使用不必要的转义字符。

    > Why? Backslashes harm readability, thus they should only be present when necessary.
    
    > 为什么？反斜杠伤害可读性，因此它们应该只在需要的时候出现。

    ```javascript
    // bad
    const foo = '\'this\' \i\s \"quoted\"';

    // good
    const foo = '\'this\' is "quoted"';
    const foo = `my name is '${name}'`;
    ```

## Functions 函数

  - [7.1]Use named function expressions instead of function declarations. eslint: [`func-style`](http://eslint.org/docs/rules/func-style) jscs: [`disallowFunctionDeclarations`](http://jscs.info/rule/disallowFunctionDeclarations)
  使用命名函数表达式而不是函数声明。

    > Why? Function declarations are hoisted, which means that it’s easy - too easy - to reference the function before it is defined in the file. This harms readability and maintainability. If you find that a function’s definition is large or complex enough that it is interfering with understanding the rest of the file, then perhaps it’s time to extract it to its own module! Don’t forget to name the expression - anonymous functions can make it harder to locate the problem in an Error’s call stack. ([Discussion](https://github.com/airbnb/javascript/issues/794))
    
    > 为什么？ 函数声明会变量提升，意味着很容易发生在定义之前产生引用。这很伤可读性和可维护性。如果发现一个函数足够大或者足够复杂，甚至会影响你理解剩下的代码，那么
或许此时应该把它提取出来放到它自己的模块里去。别忘了命名表达式，在错误调用栈里匿名函数可能更加难定位问题。

    ```javascript
    // bad
    function foo() {
      // ...
    }

    // bad
    const foo = function () {
      // ...
    };

    // good
    const foo = function bar() {
      // ...
    };
    ```

  - [7.2] Wrap immediately invoked function expressions in parentheses. eslint: [`wrap-iife`](http://eslint.org/docs/rules/wrap-iife.html) jscs: [`requireParenthesesAroundIIFE`](http://jscs.info/rule/requireParenthesesAroundIIFE)
  使用小括号把立即调用的函数表达式包起来。

    > Why? An immediately invoked function expression is a single unit - wrapping both it, and its invocation parens, in parens, cleanly expresses this. Note that in a world with modules everywhere, you almost never need an IIFE.
    
    > 为什么？一个立即调用的函数表达式是一个单独的单元，把它和它的调用括号括起来可以清楚的表达这个意思。值得注意的是，一个到处是模块的世界里，你几乎不需要立即调用表达式。

    ```javascript
    // immediately-invoked function expression (IIFE)
    (function () {
      console.log('Welcome to the Internet. Please follow me.');
    }());
    ```

  - [7.3] Never declare a function in a non-function block (`if`, `while`, etc). Assign the function to a variable instead. Browsers will allow you to do it, but they all interpret it differently, which is bad news bears. eslint: [`no-loop-func`](http://eslint.org/docs/rules/no-loop-func.html)
  绝对不要在一个非函数块里面定义一个函数，比如 if while。应该把函数赋值给一个变量。浏览器会允许你这么做，但是他们用不同的方式解释，这是坏的空头支票。

  - [7.4] **Note:** ECMA-262 defines a `block` as a list of statements. A function declaration is not a statement. [Read ECMA-262’s note on this issue](http://www.ecma-international.org/publications/files/ECMA-ST/Ecma-262.pdf#page=97).
  **注意:** ECMA-262 定义了一个 `block` 作为句子列表。函数声明不是一个句子

    ```javascript
    // bad
    if (currentUser) {
      function test() {
        console.log('Nope.');
      }
    }

    // good
    let test;
    if (currentUser) {
      test = () => {
        console.log('Yup.');
      };
    }
    ```
    
  - [7.5] Never name a parameter `arguments`. This will take precedence over the `arguments` object that is given to every function scope.
  绝对不要命名成 `arguments`，这个优先于 `arguments` 对象，被给到每个函数作用域。

    ```javascript
    // bad
    function foo(name, options, arguments) {
      // ...
    }

    // good
    function foo(name, options, args) {
      // ...
    }
    ```

  - [7.6] Never use `arguments`, opt to use rest syntax `...` instead. eslint: [`prefer-rest-params`](http://eslint.org/docs/rules/prefer-rest-params)
  绝对不要使用 `arguments`，可以使用剩余操作符 `...` 替代. 

    > Why? `...` is explicit about which arguments you want pulled. Plus, rest arguments are a real Array, and not merely Array-like like `arguments`.

    > 为什么？`...` 你想要拉的变量是非常明确的，另外，剩余操作符是一个真的数组，不仅仅是一个 Array-list 的对象 `arguments`.
    ```javascript
    // bad
    function concatenateAll() {
      const args = Array.prototype.slice.call(arguments);
      return args.join('');
    }

    // good
    function concatenateAll(...args) {
      return args.join('');
    }
    ```

  - [7.7] Use default parameter syntax rather than mutating function arguments.
  使用默认参数语法而不要使用变化的函数参数。

    ```javascript
    // really bad
    function handleThings(opts) {
      // No! We shouldn’t mutate function arguments.
      // Double bad: if opts is falsy it'll be set to an object which may
      // be what you want but it can introduce subtle bugs.
      opts = opts || {};
      // ...
    }

    // still bad
    function handleThings(opts) {
      if (opts === void 0) {
        opts = {};
      }
      // ...
    }

    // good
    function handleThings(opts = {}) {
      // ...
    }
    ```

  - [7.8] Avoid side effects with default parameters.
  避免默认参数的副作用

    > Why? They are confusing to reason about.
    > 为什么？他们令人困惑到难以推论
    

    ```javascript
    var b = 1;
    // bad
    function count(a = b++) {
      console.log(a);
    }
    count();  // 1
    count();  // 2
    count(3); // 3
    count();  // 3
    ```

  - [7.9] Always put default parameters last.
  总是把默认参数放最后。

    ```javascript
    // bad
    function handleThings(opts = {}, name) {
      // ...
    }

    // good
    function handleThings(name, opts = {}) {
      // ...
    }
    ```

  - [7.10] Never use the Function constructor to create a new function. eslint: [`no-new-func`](http://eslint.org/docs/rules/no-new-func)
  绝对不要使用函数构造函数来创造一个新的函数。

    > Why? Creating a function in this way evaluates a string similarly to eval(), which opens vulnerabilities.
    > 为什么？用这种方法创造一个函数会计算出一个类似于 eval()的字符串，会带来一堆缺陷。

    ```javascript
    // bad
    var add = new Function('a', 'b', 'return a + b');

    // still bad
    var subtract = Function('a', 'b', 'return a - b');
    ```

  - [7.11] Spacing in a function signature. eslint: [`space-before-function-paren`](http://eslint.org/docs/rules/space-before-function-paren) [`space-before-blocks`](http://eslint.org/docs/rules/space-before-blocks)
  函数和括号之间放一个空格。

    > Why? Consistency is good, and you shouldn’t have to add or remove a space when adding or removing a name.
    > 为什么？连贯性更好，当你加或者删除名字的时候，没必要去加或者删除一个空格。

    ```javascript
    // bad
    const f = function(){};
    const g = function (){};
    const h = function() {};

    // good
    const x = function () {};
    const y = function a() {};
    ```

  - [7.12] Never mutate parameters. eslint: [`no-param-reassign`](http://eslint.org/docs/rules/no-param-reassign.html)
  永远不要改变参数

    > Why? Manipulating objects passed in as parameters can cause unwanted variable side effects in the original caller.
    > 为什么？操作参数传递进来的对象，可能给原始调用者引起预料之外的副作用。

    ```javascript
    // bad
    function f1(obj) {
      obj.key = 1;
    }

    // good
    function f2(obj) {
      const key = Object.prototype.hasOwnProperty.call(obj, 'key') ? obj.key : 1;
    }
    ```

  - [7.13] Never reassign parameters. eslint: [`no-param-reassign`](http://eslint.org/docs/rules/no-param-reassign.html)
  不要给参数重新赋值。

    > Why? Reassigning parameters can lead to unexpected behavior, especially when accessing the `arguments` object. It can also cause optimization issues, especially in V8.
    > 为什么？给参数重新赋值可能导致预期之外的行为，尤其是赋值给`arguments`对象。它还会造成性能问题，尤其是 V8 引擎。

    ```javascript
    // bad
    function f1(a) {
      a = 1;
      // ...
    }

    function f2(a) {
      if (!a) { a = 1; }
      // ...
    }

    // good
    function f3(a) {
      const b = a || 1;
      // ...
    }

    function f4(a = 1) {
      // ...
    }
    ```

  - [7.14] Prefer the use of the spread operator `...` to call variadic functions. eslint: [`prefer-spread`](http://eslint.org/docs/rules/prefer-spread)
  使用传参符号 `...` 来调用可变参函数。

    > Why? It’s cleaner, you don’t need to supply a context, and you can not easily compose `new` with `apply`.
    > 为什么？ 它更加干净，你不需要提供上下文，你很难去比较`new` 和 `apply`。

    ```javascript
    // bad
    const x = [1, 2, 3, 4, 5];
    console.log.apply(console, x);

    // good
    const x = [1, 2, 3, 4, 5];
    console.log(...x);

    // bad
    new (Function.prototype.bind.apply(Date, [null, 2016, 8, 5]));

    // good
    new Date(...[2016, 8, 5]);
    ```

  - [7.15]Functions with multiline signatures, or invocations, should be indented just like every other multiline list in this guide: with each item on a line by itself, with a trailing comma on the last item.
  多行声明或者调用的函数应该像任何其他的多行列表一样。每个元素自己占一行，最后一个元素拖一个逗号。
  PS: Functions signatures:一个函数由这么几部分组成，函数名、参数个数、参数类型、返回值，函数签名由参数个数与其类型组成。函数在重载时，利用函数签名的不同（即参数个数与类型的不同）来区别调用者到底调用的是那个方法！ 

    ```javascript
    // bad
    function foo(bar,
                 baz,
                 quux) {
      // ...
    }

    // good
    function foo(
      bar,
      baz,
      quux,
    ) {
      // ...
    }

    // bad
    console.log(foo,
      bar,
      baz);

    // good
    console.log(
      foo,
      bar,
      baz,
    );
    ```

## Arrow Functions 箭头函数

  - [8.1] When you must use function expressions (as when passing an anonymous function), use arrow function notation. eslint: [`prefer-arrow-callback`](http://eslint.org/docs/rules/prefer-arrow-callback.html), [`arrow-spacing`](http://eslint.org/docs/rules/arrow-spacing.html) jscs: [`requireArrowFunctions`](http://jscs.info/rule/requireArrowFunctions)
  当你一定要用一个函数表达式，比如一个匿名函数，使用箭头符号。

    > Why? It creates a version of the function that executes in the context of `this`, which is usually what you want, and is a more concise syntax.

    > Why not? If you have a fairly complicated function, you might move that logic out into its own function declaration.
    > 为什么？它创造了一个在 `this` 上下文的函数版本，这一般都是你想要的更简单的写法。
    >为什么不？如果你有一个巨复杂的函数，你也许应该把逻辑移动到它函数定义的地方。

    ```javascript
    // bad
    [1, 2, 3].map(function (x) {
      const y = x + 1;
      return x * y;
    });

    // good
    [1, 2, 3].map((x) => {
      const y = x + 1;
      return x * y;
    });
    ```

  - [8.2]If the function body consists of a single statement returning an [expression](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Expressions_and_Operators#Expressions) without side effects, omit the braces and use the implicit return. Otherwise, keep the braces and use a `return` statement. eslint: [`arrow-parens`](http://eslint.org/docs/rules/arrow-parens.html), [`arrow-body-style`](http://eslint.org/docs/rules/arrow-body-style.html) jscs:  [`disallowParenthesesAroundArrowParam`](http://jscs.info/rule/disallowParenthesesAroundArrowParam), [`requireShorthandArrowFunctions`](http://jscs.info/rule/requireShorthandArrowFunctions)
  
如果一个函数的主要只有一个句子，返回一个无副作用的表达式，省略括号、返回一个隐式返回值。否则，应该保留括号并且有一个 return 语句。
    > Why? Syntactic sugar. It reads well when multiple functions are chained together.
    > 为什么？句法糖。多个函数链式调用的时候读起来爽。

    ```javascript
    // bad
    [1, 2, 3].map(number => {
      const nextNumber = number + 1;
      `A string containing the ${nextNumber}.`;
    });

    // good
    [1, 2, 3].map(number => `A string containing the ${number}.`);

    // good
    [1, 2, 3].map((number) => {
      const nextNumber = number + 1;
      return `A string containing the ${nextNumber}.`;
    });

    // good
    [1, 2, 3].map((number, index) => ({
      [index]: number,
    }));

    // No implicit return with side effects
    function foo(callback) {
      const val = callback();
      if (val === true) {
        // Do something if callback returns true
      }
    }

    let bool = false;

    // bad
    foo(() => bool = true);

    // good
    foo(() => {
      bool = true;
    });
    ```

  - [8.3] In case the expression spans over multiple lines, wrap it in parentheses for better readability.
  万一这个表达式有多行，用圆括号把它包起来可以得到更好的可读性。

    > Why? It shows clearly where the function starts and ends.
    > 为什么？它更清楚的告诉你这个函数从哪开始到哪结束。

    ```javascript
    // bad
    ['get', 'post', 'put'].map(httpMethod => Object.prototype.hasOwnProperty.call(
        httpMagicObjectWithAVeryLongName,
        httpMethod,
      )
    );

    // good
    ['get', 'post', 'put'].map(httpMethod => (
      Object.prototype.hasOwnProperty.call(
        httpMagicObjectWithAVeryLongName,
        httpMethod,
      )
    ));
    ```
    
  - [8.4] If your function takes a single argument and doesn’t use braces, omit the parentheses. Otherwise, always include parentheses around arguments for clarity and consistency. Note: it is also acceptable to always use parentheses, in which case use the [“always” option](http://eslint.org/docs/rules/arrow-parens#always) for eslint or do not include [`disallowParenthesesAroundArrowParam`](http://jscs.info/rule/disallowParenthesesAroundArrowParam) for jscs. eslint: [`arrow-parens`](http://eslint.org/docs/rules/arrow-parens.html) jscs:  [`disallowParenthesesAroundArrowParam`](http://jscs.info/rule/disallowParenthesesAroundArrowParam)
  如果你的函数只有一个参数且不适用花括号，那么不使用圆括号。否则，始终使用圆括号包裹参数来保持清晰和一致。

    > Why? Less visual clutter.

    ```javascript
    // bad
    [1, 2, 3].map((x) => x * x);

    // good
    [1, 2, 3].map(x => x * x);

    // good
    [1, 2, 3].map(number => (
      `A long string with the ${number}. It’s so long that we don’t want it to take up space on the .map line!`
    ));

    // bad
    [1, 2, 3].map(x => {
      const y = x + 1;
      return x * y;
    });

    // good
    [1, 2, 3].map((x) => {
      const y = x + 1;
      return x * y;
    });
    ```

  - [8.5] Avoid confusing arrow function syntax (`=>`) with comparison operators (`<=`, `>=`). eslint: [`no-confusing-arrow`](http://eslint.org/docs/rules/no-confusing-arrow)
  避免使用混淆的箭头符号和比较符号(`=>`) (`<=`, `>=`)。

    ```javascript
    // bad
    const itemHeight = item => item.height > 256 ? item.largeSize : item.smallSize;

    // bad
    const itemHeight = (item) => item.height > 256 ? item.largeSize : item.smallSize;

    // good
    const itemHeight = item => (item.height > 256 ? item.largeSize : item.smallSize);

    // good
    const itemHeight = (item) => {
      const { height, largeSize, smallSize } = item;
      return height > 256 ? largeSize : smallSize;
    };
    ```
    
## Classes & Constructors 类&构造器

  - [9.1]Always use `class`. Avoid manipulating `prototype` directly.
  经常使用 `class`，避免直接操作 `prototype`

    > Why? `class` syntax is more concise and easier to reason about.
    > 为什么？class语法更简明，更容易推断。

    ```javascript
    // bad
    function Queue(contents = []) {
      this.queue = [...contents];
    }
    Queue.prototype.pop = function () {
      const value = this.queue[0];
      this.queue.splice(0, 1);
      return value;
    };

    // good
    class Queue {
      constructor(contents = []) {
        this.queue = [...contents];
      }
      pop() {
        const value = this.queue[0];
        this.queue.splice(0, 1);
        return value;
      }
    }
    ```

  - [9.2] Use `extends` for inheritance.
  使用`extends` 来继承。

    > Why? It is a built-in way to inherit prototype functionality without breaking `instanceof`.
    > 为什么？它是一个内置的方法来继承函数原型，并且不打破`instanceof`法则。

    ```javascript
    // bad
    const inherits = require('inherits');
    function PeekableQueue(contents) {
      Queue.apply(this, contents);
    }
    inherits(PeekableQueue, Queue);
    PeekableQueue.prototype.peek = function () {
      return this.queue[0];
    };

    // good
    class PeekableQueue extends Queue {
      peek() {
        return this.queue[0];
      }
    }
    ```

  - [9.3] Methods can return `this` to help with method chaining.
  方法可以返回 `this` 来帮助实现方法链.
    ```javascript
    // bad
    Jedi.prototype.jump = function () {
      this.jumping = true;
      return true;
    };

    Jedi.prototype.setHeight = function (height) {
      this.height = height;
    };

    const luke = new Jedi();
    luke.jump(); // => true
    luke.setHeight(20); // => undefined

    // good
    class Jedi {
      jump() {
        this.jumping = true;
        return this;
      }

      setHeight(height) {
        this.height = height;
        return this;
      }
    }

    const luke = new Jedi();

    luke.jump()
      .setHeight(20);
    ```

  - [9.4]It’s okay to write a custom toString() method, just make sure it works successfully and causes no side effects.
写一个定制的 tostring 函数是可以接受的，但是确保它能正常运行且没有副作用。

    ```javascript
    class Jedi {
      constructor(options = {}) {
        this.name = options.name || 'no name';
      }

      getName() {
        return this.name;
      }

      toString() {
        return `Jedi - ${this.getName()}`;
      }
    }
    ```

  - [9.5] Classes have a default constructor if one is not specified. An empty constructor function or one that just delegates to a parent class is unnecessary. eslint: [`no-useless-constructor`](http://eslint.org/docs/rules/no-useless-constructor)
  无特别声明，类自己有一个默认的构造器。一个空的或者直接委托给父类的构造器没必要。

    ```javascript
    // bad
    class Jedi {
      constructor() {}

      getName() {
        return this.name;
      }
    }

    // bad
    class Rey extends Jedi {
      constructor(...args) {
        super(...args);
      }
    }

    // good
    class Rey extends Jedi {
      constructor(...args) {
        super(...args);
        this.name = 'Rey';
      }
    }
    ```
  - [9.6]Avoid duplicate class members. eslint: [`no-dupe-class-members`](http://eslint.org/docs/rules/no-dupe-class-members)
  避免重复类的成员。

    > Why? Duplicate class member declarations will silently prefer the last one - having duplicates is almost certainly a bug.
    > 为什么？重复的对象成员声可能默默的选了后一个，有重复声明基本上肯定是个 bug。

    ```javascript
    // bad
    class Foo {
      bar() { return 1; }
      bar() { return 2; }
    }

    // good
    class Foo {
      bar() { return 1; }
    }

    // good
    class Foo {
      bar() { return 2; }
    }
    ```

