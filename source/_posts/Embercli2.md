title: Embercli 文档（2）：模块、解释器、命名惯例
author: 田_田
tags:
  - Ember
  - Javascript
categories: []
date: 2013-11-09 14:16:00
---
embercli
翻译自https://ember-cli.com/，embercli 文档。

本文原文地址：
https://ember-cli.com/user-guide/#using-modules
https://ember-cli.com/user-guide/#naming-conventions
<!--more-->

## 使用模块 & 解释器
Ember 解释器(Resolver)用来负责在你的应用里检索代码，然后按命名约定转换成真实的类、函数、或者模板，Ember 会处理的需要的依赖。比如，一个给定的路由需要哪些模板。这里有个Ember Resolver的介绍和一个简单案例说明它怎么运行。[Youtube视频链接](https://www.youtube.com/watch?v=OY0PzrltMYc#t=51) by [Robert Jackson](https://www.twitter.com/@rwjblue).

之前，Ember 的默认解释器把每个东西扔到一个全局命名空间里，你偶尔会遇到这种样子的代码：

```
App.IndexRoute = Ember.Route.extend({
  model: function() {
    return ['red', 'yellow', 'blue'];
  }
});
```

现在，Ember CLI 用基于 ES6 的 [新版本的Resolver](https://github.com/stefanpenner/ember-resolver)。这意味着你可以用未来的 JavaScript 版本来写你的应用，然后导出 AMD 模块使其被现有版本支持。


举个栗子，定义在 `app/routes/index.js` 里的路由会生成一个叫 `your-app/routes/index` 的模块。Ember解释器在找路由的时候，会自己搜到这个模块和它需要导出的对象。


```
// app/routes/index.js
import Ember from "ember";

export default Ember.Route.extend({
  model: function() {
    return ['red', 'yellow', 'blue'];
  }
});
```

你也可以用这种语法导入模块：
```
import FooMixin from "./mixins/foo";
```

你可以用相对路径和绝对路径引用一个模块。如果你想用绝对路径引用一个模块，用`package.json`里定义的应用名字加上绝对路径。


```
import FooMixin from "appname/mixins/foo";
```

同样，你可以给导入的模块手工命任何名字。看看上面的例子，想想 `mixins/foo` 模块是如何被赋值给变量 `FooMixin`。



### 用 Ember 或者 Ember Data

在你的模块里用`Ember`或者`DS`(Ember Data)，你需要这样引入：

```
import Ember from "ember";
import DS from "ember-data";
```


### 使用 Pods

新版解释器带来的一个改进，它会在查找老版的项目结构前先查找 Pods 结构。


### 模块目录命名结构

目录           | 目的
--------------------|
`app/adapters/`     | 约定适配器命名为 `adapter-name.js`。
`app/components/`   | 约定组件命名为`component-name.js`。组件必须要有一个`-`号在名字里，所以`blog-post`是可以接受的命名，`post`不是。
`app/helpers/`      | 约定助手函数命名为`helper-name.js`。帮助函数必须有一个`-`号在名字里。记住你必须通过导出`makeBoundHelper`来注册助手函数，或者明确调用`registerBoundHelper`。
`app/initializers/` | 约定构造器命名为`initializer-name.js`。构造器总是自动加载的。
`app/mixins/`       | 约定混入继承命名`mixin-name.js`。
`app/models/`       | 约定模型命名为`model-name.js`。
`app/routes/`       | 约定路由命名为`route-name.js`。子路由被定义在子目录里`parent/child.js`。为了提供定制化生成路由（等价于全局使用`App.Route`）使用 `app/routes/basic.js`。
`app/serializers/`  | 模型或者适配器的序列化器，命名成`model-name.js`或`adapter-name.js`.
`app/transforms/`   | 将Ember Data的属性进行转换，命名为新的属性名`attribute-name.js`。
`app/utils/`        | 约定工具包命名为`utility-name.js`.

所有在`app`里的模块都能被解释器加载，除了特别的类 `mixins` 和 `utils` ，应该手动import加载。

命名转换会更详细的介绍

### 处理 Handlebars 助手函数

定制的Handlebars助手函数可以帮你复用 HTML。注册你的定制助手函数，它可以被任何Handlebars调用。
located under `app/helpers`.

```
// app/helpers/upper-case.js
import Ember from "ember";

export default Ember.Helper.helper(function([value]) {
  return value.toUpperCase();
});
```

在`some-template.hbs`里:
```
{% raw %}
{{upper-case "foo"}}
{% endraw %}
```
先前版本的ember-cli要求自动解释助手函数必须有一个`-`，现在的版本是有没有都自动解释。

一种常用的模式是定义一个帮助函数来视觉层使用(如定制字符框，`MyTextField`定义了助手函数`my-text-field`)。不推荐，这种直接做成组件更好。

```
// Given... app/components/my-text-field.js
import Ember from "ember";

export default Ember.TextField.extend({
  // some custom behaviour...
});
```


###	使用全局变量或者第三方脚本
如果你想用第三方的包来写面向全局的东西(如[moment.js](http://momentjs.com/))，你需要在`.eslintrc.js`里把他们加到`globals` 里，并且把它们的值设成 true。然后测试用了的库也一样，只是把东西加到`tests/.eslintrc.js`里。



## 命名惯例

- `kebab-case` （撸串命名法？
  - 文件名
  - 目录名
  - html标签、ember 组件
  - CSS类名
  - URLs
- `camelCase` (小驼峰
  - JavaScript
  - JSON

用 Ember CLI 的时候小心点，稍不注意就出轨了。
这个章节会给你一些命名约定。

### 模块的例子

#### Adapters

```
// app/adapters/application.js
import Ember from "ember";
import DS from "ember-data";

export default DS.RESTAdapter.extend({});
```

#### Components

```
// app/components/time-input.js
import Ember from "ember";

export default Ember.TextField.extend({});
```

#### Controllers

```
// app/controllers/stop-watch.js
import Ember from "ember";

export default Ember.Controller.extend({});
```
如果不是嵌套的控制器，我们可以这样声明子控制器：`app/controllers/posts/index.js`.

#### Helpers

```
// app/helpers/format-time.js
import Ember from "ember";

export default Ember.Helper.helper(function(){});
```

#### Initializers

```
// app/initializers/observation.js
export default {
  name: 'observation',
  initialize: function() {
    // code
  }
};
```

注意: `initializers`是自动加载的。

#### Mixins

```
// app/mixins/evented.js
import Ember from "ember";

export default Ember.Mixin.create({});
```

#### Models

```
// app/models/observation.js
import DS from "ember-data";

export default DS.Model.extend({});
```

#### Routes

```
// app/routes/timer.js
import Ember from "ember";

export default Ember.Route.extend({});
```

可以这样嵌套路由： `app/routes/timer/index.js` or `app/routes/timer/record.js`.

#### Serializers

```
// app/serializers/observation.js
import DS from "ember-data";

export default DS.RESTSerializer.extend({});
```

#### Transforms

```
// app/transforms/time.js
import DS from "ember-data";

export default DS.Transform.extend({});
```

#### Utilities

```
// app/utils/my-ajax.js
export default function myAjax() {};
```

#### Views

```
<!-- app/index.hbs -->
{{view 'stop-watch'}}
```

```
// app/views/stop-watch.js
import Ember from "ember";

export default Ember.View.extend({});
```

视图可以在子目录中引用，但不能继承。


```
<!-- app/index.hbs -->
{% raw %}{{view 'inputs/time-input'}}{% endraw %}
```

```
// app/views/inputs/time-input.js
import Ember from "ember";

export default Ember.TextField.extend({});
```

### 文件名

Ember 解释器用文件名来组织工程关系，所以记住它们很重要。这可以让你避免每个地方都自己去想命名空间。
这里仍有一些你需要知道的事情：

#### 所有文件名应该小写

```
// models/user.js
import Ember from "ember";
export default Ember.Model.extend();
```

#### 文件名和目录名用减号连接

```
// controllers/sign-up.js
import Ember from "ember";
export default Ember.Controller.extend();
```

#### 嵌套目录

如果你你认为嵌套文件可以更好的管理你的应用，你轻而易举的可以这样：

```
// controllers/posts/new.js 在控制器里面被命名为"controllers.posts/new"
import Ember from "ember";
export default Ember.Controller.extend();
```

你不能在模板里面使用包含`/`，Handlebars会把他们转回`.`，简单创建一个映射：

```
// controllers/posts.js
import Ember from "ember";
export default Ember.Controller.extend({
  needs: ['posts/details'],
  postsDetails: Ember.computed.alias('controllers.posts/details')
});
```

```
{% raw %}
<!-- templates/posts.hbs -->
<!-- because {{controllers.posts/details.count}} does not work -->
{{postsDetails.count}}
{% endraw %}
```

### 测试

想让测试文件正常跑，测试应该以`-test.js`结尾。

#### Pod结构

当应用变大了，功能特性驱动的结构可能更好。把你的应用按照功能、资源划分可以给你更多精力，去掌控运维过程。默认情况，如果文件没在 POD 结构里，解释器会去正常的结构里去解析。

这个例子里，你可以把文件按照功能命名，给定一个资源`Users`，目录结构应该是：

- `app/users/controller.js`
- `app/users/route.js`
- `app/users/template.hbs`

不要把资源文件放在项目根目录，你可以定义一个POD路径，在环境变量里面加入属性`podModulePrefix`，POD 路径应该是这个形式：`{appname}/{poddir}`.

```
// config/environment.js
module.exports = function(environment) {
  var ENV = {
    modulePrefix: 'my-new-app',
    // namespaced directory where resolver will look for your resource files
    podModulePrefix: 'my-new-app/pods',
    environment: environment,
    baseURL: '/',
    locationType: 'auto'
    //...
  };

  return ENV;
};
```

然后你的目录结构会变成：

- `app/pods/users/controller.js`
- `app/pods/users/route.js`
- `app/pods/users/template.hbs`