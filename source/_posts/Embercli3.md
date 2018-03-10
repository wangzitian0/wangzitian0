title: Embercli 文档（3）：Ember Data + 测试
author: 田_田
tags:
  - Ember
  - Javascript
categories: []
date: 2013-11-09 21:14:00
---
embercli
翻译自https://ember-cli.com/，embercli 文档。

本文原文地址：
https://ember-cli.com/user-guide/#ember-data
https://ember-cli.com/user-guide/#testing

<!--more-->
## Ember Data

现在版本的 Ember Data 被包含在 CLI 里。Ember Data 被彻底的重构过一次，被彻底的简化，因而解释器用起来更简单。这里有几条用 CLI 的几条建议。

用 ember-cli 但是不用 Ember Data 就把依赖从 package.json 里面删掉
(同样适用于 [ic-ajax](https://github.com/rwjblue/ember-cli-ic-ajax))
```
npm rm ember-data --save-dev
```


### 模型

模型对任何一个动态 web 应用都很重要，Ember Data 让模型变得特别简单。
举个例子，我们可以创建一个`todo` 模型：

```
// models/todo.js
import DS from "ember-data";

export default DS.Model.extend({
  title: DS.attr('string'),
  isCompleted: DS.attr('boolean'),
  quickNotes: DS.hasMany('quick-note')
});

// models/quick-note.js
import DS from "ember-data";

export default DS.Model.extend({
  name: DS.attr('string'),
  todo: DS.belongsTo('todo')
});

```
注意，文件名应该全小写并且用减号连接(撸串命名法：）)，这是解释器自动解析的方式。

### 适配器 & 序列化器

Ember Data 重度使用各种类型的适配器和序列化器。这些对象可以和其他部分一样被解析。

适配器放在 `/app/adapters/type.js`:
```
// adapters/post.js
import DS from "ember-data";

export default DS.RESTAdapter.extend({});
```

序列化器放在 `/app/serializers/type.js`:
```
// serializers/post.js
import DS from "ember-data";

export default DS.RESTSerializer.extend({});
```

全局 APP 级别（默认）的适配器 & 序列化器应该分别命名成 `adapters/application.js` 和 `serializers/application.js`。

### Mocks

Ember CLI提出了一种 http-mock 生成器，开发和测试样例的首选应该是它。 Mock 的方案比直接写固定数据相比，最主要的好处是可以和应用的适配器交互。尽管最终你会把你的 hook 发到线上 API，但是刚开始的时候就测试适配器是个明智的决定。

创建一个 `posts` API 请求的 mock：

```
ember g http-mock posts
```
一个 url 为 `/your-app/server/mocks/posts.js` 的简易[ExpressJS](http://expressjs.com/)服务器会被架起来。只要你加上合适的 JSON 返回值，就能跑了。之后你运行 `ember server`，你的新 mock server 会监听你的 Ember app 发出的任何API请求。

> 注意：Mocks只是用来开发的。运行 `ember build` 和 `ember test`的时候，整个 `/server` 文件夹都会被直接忽略


## 测试

### 跑已经有的测试

随便哪个都能跑你的测试：
```
ember test            # 当前 shell 跑你一次测试集
ember test --server   # 每次文件改动跑一次测试集
ember t -s -m 'Unit | Utility | name' # 每次文件改动都跑 'Unit | Utility | name' 这个模块的所有测试集
ember t -f 'match a phrase in test description(s)' # 跑一次描述匹配这段话的测试
```

另一种选择是在你自己的浏览器里用QUnit接口测试。跑`ember server`命令，打开`http://localhost:4200/tests`。在/tests跑的应用是development环境，不是test环境，这点要注意。

### 写个测试

* ember-testing
* helpers
* unit/acceptance

Ember CLI 默认使用 [QUnit](http://qunitjs.com/)，通过 [Mocha](http://mochajs.org/) / [Chai](http://chaijs.com/)来测试，所以可以使用 [ember-cli-mocha](https://github.com/switchfly/ember-cli-mocha)。
后面的测试可以告诉你怎么写上面几种测试，用这个包：[ember-testing
package](http://ianpetzer.wordpress.com/2013/06/14/getting-started-with-integration-testing-ember-js-using-ember-testing-and-qunit-rails/).

测试应该用`-test.js`作为文件后缀名。

如果你在 environment.js 手动设置了 locationType 的值为 `hash` 或者`none`，你需要更改你的 `tests/index.html`到绝对路径(`/assets/vendor.css`、`/testem.js` 或者默认是相对路径).

### 用 Testem 持续集成

`ember test` 会用 `Testem` 在持续集成模型下跑所有测试。你可以用配置文件传递任何参数到 `Testem`。如果你需要`Testem` xunit报告，用 `ember test --silent` 可以屏蔽掉类似 ember-cli 版本之类的冗余信息。如果你想把它输出到文件，把 `report_file: "path/to/file.xml"` 加到 `testem.json` 配置文件里。

默认情况，集成测试(integration tests)跑在 [PhantomJS](http://phantomjs.org/) 里。你可以用 [npm](https://www.npmjs.org/) 安装：

```
npm install -g phantomjs-prebuilt
```

**我们计划让测试驱动可拔插，然后你可以用你自己喜欢的驱动程序。**

#### 用 ember-qunit 做集成(integration)测试

所有的 Ember 应用有内置的 [ember测试助手](https://guides.emberjs.com/v2.0.0/testing/acceptance/#toc_test-helpers)，写集成测试的时候十分有用。使用它需要引入 `tests/helpers/start-app.js`，它会自己注入需要的助手函数。
确保你用 `module` 函数来调用 `beforeEach` 和 `afterEach`。

```
import Ember from "ember";
import { module, test } from 'qunit';
import startApp from '../helpers/start-app';
var App;

module('An Integration test', {
  beforeEach: function() {
    App = startApp();
  },
  afterEach: function() {
    Ember.run(App, App.destroy);
  }
});

test("Page contents", function(assert) {
  assert.expect(2);
  visit('/foos').then(function() {
    assert.equal(find('.foos-list').length, 1, "Page contains list of models");
    assert.equal(find('.foos-list .foo-item').length, 5, "List contains expected number of models");
  });
});
```

#### 用 ember-qunit 做单元测试

一个Ember CLI生成的项目应该预加载[ember-qunit](https://github.com/rpflorence/ember-qunit)，里面包含了[不少助手函数](http://emberjs.com/guides/testing/unit-test-helpers/#toc_unit-testing-helpers):

* moduleFor
* moduleForModel
* moduleForComponent

##### moduleFor(fullName, description, callbacks, delegate)

通用解释器会加载你指定的东西，用法非常像 QUnit 的 `module` 函数。他的用法可以参考这个 [index-test.js](https://github.com/stefanpenner/ember-app-kit/blob/master/tests/unit/routes/index-test.js)：

```
// tests/unit/routes/index-test.js
import { test, moduleFor } from 'ember-qunit';

moduleFor('route:index', "Unit - IndexRoute", {
  // 只有运行时想加载其他对象的时候有必要
  // needs: ['controller:index']
  beforeEach: function () {},
  afterEach: function () {}
});

test("it exists", function(assert){
  assert.ok(this.subject());
});
```

`fullname`

你需要测试的对象名，需要是解释器支持的命名方式。

`description`

描述会把后面所有的测试当成一个分组。默认和 `fullname` 值一样。

`callbacks`

你可以提供一个定制的 beforeEach, afterEach, 或子函数给callbacks参数。如果对象应该被加载到 Ember.js ，用`needs`属性指定这些对象。

`delegate`

手动修改一个容器&测试上下文，指定一个函数作为委托，需要满足这个函数签名`delegate(container, testing_context)`.

`this.subject()` 调用由全名指定的对象工厂，会返回一个对象实例。

##### moduleForModel(name, description, callbacks)

继承通用 `moduleFor` 函数，并装载为模型定制的测试：

```
// tests/unit/models/post-test.js
import DS from 'ember-data';
import Ember from 'ember';
import { test, moduleForModel } from 'ember-qunit';

moduleForModel('post', 'Post Model', {
  needs: ['model:comment']
});

test('Post is a valid ember-data Model', function (assert) {
  var store = this.store();
  var post = this.subject({title: 'A title for a post', user: 'bob'});
  assert.ok(post);
  assert.ok(post instanceof DS.Model);

  // 设置关系
  Ember.run(function() {
    post.set('comment', store.createRecord('comment', {}))
  });

  assert.ok(post.get('comment'));
  assert.ok(post.get('comment') instanceof DS.Model);
});
```

`name`

你要测的模型名。重要的是，只给这个名字，不是对象的解释器路径。(`model:post` => `post`).

`description`

描述可以把后面所有的测试当做一个分组，默认和`name`一样。

`callbacks`

你可以提供一个定制的 beforeEach, afterEach, 或子函数给 callbacks 参数。如果对象应该被加载到 Ember.js ，用`needs`属性指定这些对象。

注意：如果你要测的模型和其他模型有关系，这些模型需要通过 `needs` 属性指定。

`this.store()` 去查询 `DS.Store`.

`this.subject()` 会根据全名去调用 `DS.Model` 工厂，返回一个对象实例。

##### moduleForComponent(name, description, callbacks)


继承通用 `moduleFor` 函数，并装载为组件定制的测试：

```
// tests/integration/components/pretty-color-test.js
import Ember from "ember";
import { test, moduleForComponent } from 'ember-qunit';

moduleForComponent('pretty-color');

test('changing colors', function(assert){
  var component = this.subject();

  Ember.run(function(){
    component.set('name','red');
  });

  // first call to $() renders the component.
  assert.equal(this.$().attr('style'), 'color: red;');

  Ember.run(function(){
    component.set('name', 'green');
  });

  assert.equal(this.$().attr('style'), 'color: green;');
});
```

`name`


`name`

你要测的组件名。重要的是，只给这个名字，不是对象的解释器路径。(`component:pretty-color` => `pretty-color`)。

`description`

描述可以把后面所有的测试当做一个分组，默认和`name`一样。

`callbacks`


你可以提供一个定制的 beforeEach, afterEach, 或子函数给 callbacks 参数。如果对象应该被加载到 Ember.js ，用`needs`属性指定这些对象。

注意：如果你要测的模型和其他模型有关系，这些模型需要通过 `needs` 属性指定。

`this.subject()` 会根据全名去调用 `Ember.Component` 工厂，返回一个对象实例。

第一个调用 `this.$()` 的地方会渲染出这个组件，如果你要测试样式，你需要通过 jQuery 。

### 写你自己的测试助手函数

Ember 提供了能力，你可以注册自己的测试助手函数。为了让 ember-cli使用这个功能， 他们必须在 `startApp` 定义之前注册。

一个文件定义一个助手函数或者一组助手函数，取决于自己的搞法。

#### 每个文件一个助手函数

```
// helpers/routes-to.js
import Ember from "ember";

export default Ember.Test.registerAsyncHelper('routesTo', function (app, assert, url, route_name) {
  visit(url);
  andThen(function () {
    assert.equal(currentRouteName(), route_name, 'Expected ' + route_name + ', got: ' + currentRouteName());
  });
});
```
`start-app.js`里就可以用，像这样：

```
// helpers/start-app.js
import routesTo from './routes-to';

export default function startApp(attrs) {
//...
```

#### 一个文件一组助手函数

可选的方案是创造一堆助手函数放在一个自调函数，比如：

```
// helpers/custom-helpers.js
var customHelpers = function() {
  Ember.Test.registerHelper('myGreatHelper', function (app) {
    //do awesome test stuff
  });

  Ember.Test.registerAsyncHelper('myGreatAsyncHelper', function (app) {
    //do awesome test stuff
  });
}();

export default customHelpers;
```

`start-app.js` 里也可以用：

```
// helpers/start-app.js
import customHelpers from './custom-helpers';

export default function startApp(attrs) {
//...
```
当你的帮助函数定义好了，你需要要确保他们在 `.eslintrc.js` 里列出。

```
// /tests/.eslintrc.js
{
  "globals": {
    "myGreatHelper": true,
    "myGreatAsyncHelper": true
```
