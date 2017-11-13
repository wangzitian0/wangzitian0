title: Embercli 文档（4）：资源编译 & 依赖管理
author: 田_田
tags:
  - Ember
  - Javascript
categories: []
date: 2017-11-13 11:39:00
---
embercli
翻译自https://ember-cli.com/，embercli 文档。

本文原文地址：
https://ember-cli.com/user-guide/#asset-compilation
https://ember-cli.com/user-guide/#managing-dependencies

<!--more-->

## 资源编译
### 原始资源

* `public/assets` vs `app/styles`

想要添加图片、字体或者其他资源，直接把他们放在 `public/assets` 文件夹。比如，把 `logo.png` 放到 `public/assets/images`，你可以在模板里面引用它 `assets/images/logo.png`，或者在样式表里面引用 `url('/assets/images/logo.png')`。

Ember-CLI 的这个功能来自 [broccoli-asset-rev](https://github.com/rickharrison/broccoli-asset-rev)。请仔细检查所有的选项和使用说明。

### JS 转换

Ember-cli 会自动转换未来版本的 JS (ES6/ES2015, ES2016 and beyond)到标准的 ES5 JS，通过 [Babel JS](https://babeljs.io) 和 [ember-cli-babel](https://github.com/babel/ember-cli-babel) 插件，让每个浏览器都可以运行。

默认的配置可以处理大部分项目的需要，但是你可以提供配置来禁用某些指定的转换，比如你的 app 只在确认能跑 ES6 的浏览器运行，或者约定开启转换某些暂时默认没开的试验性特性。

你可以在 `ember-cli-build.js` 里配置 babel 的运行选项。比如，这样可以禁用 ES6/2015 特性：

```
// ember-cli-build.js
var EmberApp = require('ember-cli/lib/broccoli/ember-app');

module.exports = function(defaults) {
  var app = new EmberApp(defaults, {
    babel: {
      blacklist: [
        'es6.arrowFunctions',
        'es6.blockScoping',
        'es6.classes',
        'es6.destructuring',
        'es6.parameters',
        'es6.properties.computed',
        // ...more options
      ]
    }
  });

  //...
  return app.toTree();
};
```

这些选项转发自 Babel。Ember-cli 现在用 Babel 5.X，你可以查看这个完整的文档[all available transformations](https://github.com/babel/babel.github.io/blob/5.0.0/docs/usage/transformers/index.md) ，还有选项 [options](https://github.com/babel/babel.github.io/blob/5.0.0/docs/usage/options.md)。

升级到 Babel 6 的工作正在进行中。你可以查看进度[track the progress and help](https://github.com/ember-cli/ember-cli/issues/5015)。

### 混淆/最小化

编译的 CSS 文件被 `broccoli-clean-css` 或 `broccoli-csso` 最小化。你可以传递最小化指定参数给他们，通过你的 ember-cli-build 传递`minifyCSS:options` 对象。生产环境最小化默认会打开，可以用 `minifyCSS:enabled` 开关关闭。

相似地，JS 文件在生产环境默认用 `broccoli-uglify-js` 最小化。你可以在 ember-cli-build 通过 `minifyJS:options` 传递定制化参数给最小化器。开关 JS 最小化，只需要加一个布尔参数 `minifyJS:enabled`。

举个例子，关掉 CSS 和 JS 的最小化功能，`ember-cli-build.js`:

```
// ember-cli-build.js
var EmberApp = require('ember-cli/lib/broccoli/ember-app');

module.exports = function(defaults) {
  var app = new EmberApp(defaults, {
    minifyJS: {
      enabled: false
    },
    minifyCSS: {
      enabled: false
    }
  });

  //...
  return app.toTree();
};
```

#### 不需要最小化的例外

去除 `dist/assets` 里不需要最小化的资源，可以传递参数给 [broccoli-uglify-sourcemap](https://github.com/ef4/broccoli-uglify-sourcemap) ，比如这样：

```
// ember-cli-build.js
var EmberApp = require('ember-cli/lib/broccoli/ember-app');

module.exports = function(defaults) {
  var app = new EmberApp(defaults, {
    minifyJS: {
      options: {
        exclude: ["**/vendor.js"]
      }
    }
  });

  //...
  return app.toTree();
};
```

这样会让 `vendor.js` 的文件不被最小化。

### Source Maps

Ember CLI 支持制作一个 source maps 给你的合并或最小化的 JS 文件。

Source maps 被 `sourcemaps` 选项指定配置，默认是不打开的。传递 `sourcemaps: {enabled: true}` 参数给你的 EmberApp 构造器，会打开 source maps。使用 `extensions` 选项来添加其他的格式，比如coffeescript 和 CSS：`{extensions: ['js', 'css', 'coffee']}`。JS 现在开箱即用，CSS 目前不支持。其他的格式(Sass, Coffee, etc)取决于他们自己的插件。

默认 ember-cli-build.js:

```
import EmberApp from 'ember-cli/lib/broccoli/ember-app';
var app = new EmberApp({
  sourcemaps: {
    enabled: EmberApp.env() !== 'production',
    extensions: ['js']
  }
});
```

### 样式表

Ember CLI 开箱即用朴素的 CSS。你可以添加你的样式到 `app/styles/app.css`，它会自动编译成 `assets/application-name.css`。

比如，添加 bootstrap 到你的工程，你需要这么干：

```
bower install bootstrap --save
```

在 `ember-cli-build.js` 加这段：
```
app.import('bower_components/bootstrap/dist/css/bootstrap.css');
```
这会告诉 [Broccoli](https://github.com/broccolijs/broccoli) 我们想要把这个文件合并到 `vendor.css`。

要用 CSS 预处理器，你要添加合适的插件 [Broccoli](https://github.com/broccolijs/broccoli)。当使用一个预处理器的时候，Broccoli 可以被编辑成在 `app/styles` 文件夹查找一个`app.less`, `app.scss`, `app.sass`,
或 `app.styl` 清单文件。清单文件应该引入所有其他的样式表。

所有处理之后的样式表会被编译成一个文件 `assets/application-name.css`。

如果你想改变这个行为，或者想编译成多个输出，你可以调整输出配置。(参见后面的文档)

#### CSS

朴素 CSS 直接用 `app.css`：

* 在 `app.css` 里写你的样式，或者把你的 CSS 放到不同样式文件，然后在 `app.css` 通过 `@import` 引入。
* [CSS `@import` 语句](https://developer.mozilla.org/en-US/docs/Web/CSS/@import) (e.g. `@import 'typography.css';`) 必须是合法的 CSS，意味着 `@import` 语句 *必须* 在其他规则之前，所以它们必须放在 `app.css` 的*顶部*。

为了处理你的引入文件，用文件对应的内容替换它们，在 `ember-cli-build.js` 添加：
```
// ember-cli-build.js
var EmberApp = require('ember-cli/lib/broccoli/ember-app');

module.exports = function(defaults) {
  var app = new EmberApp(defaults, {
    minifyCSS: {
      options: { processImport: true }
    }
  });

  //...
  return app.toTree();
};
```

会造成如下的改变：

* 构建生成环境，`@import` 语句被对应文件的正文替换，然后最小化，合并到一个 CSS 文件 `dist/assets/yourappname-FINGERPRINT_GOES_HERE.css`。
* 任何独立的 CSS 文件也可以构建，最小化到 `dist/assets/`，假如你需要单独用这个样式表。
* 相关路径会被改变

例如 `app.css` ，使用了合法的 `@import`：

```
/* @imports must appear at top of stylesheet to be valid CSS */
@import 'typography.css';
@import 'forms.css';

/* Any CSS rules must go *after* any @imports */
.first-css-rule {
  color: red;
}
...
```

#### CSS 预处理器

为了用后面的预处理器，你需要做的就是安装合适的 NPM 模块。各自文件会被挑选，自动化处理。

#### LESS

为了启用 [LESS](http://lesscss.org/)，你需要加 [ember-cli-less](https://github.com/gdub22/ember-cli-less) 到你的 NPM 模块里。

```
ember install ember-cli-less
```

#### SCSS/SASS

为了启用 [SCSS/SASS](http://sass-lang.com/)，你需要加 [ember-cli-sass](https://github.com/aexmachina/ember-cli-sass) 插件到你的工程 *(配置默认允许 .scss, .sass )*.

```
ember install ember-cli-sass
```

你可以配置你的 `ember-cli-build.js` 使用 .sass：

```
// ember-cli-build.js
var app = new EmberApp(defaults, {
  sassOptions: {
    extension: 'sass'
  }
});
```

#### Compass

想用 [Compass](http://compass-style.org/)，用 NPM 安装 [ember-cli-compass-compiler](https://github.com/quaertym/ember-cli-compass-compiler) 插件。

```
ember install ember-cli-compass-compiler
```

#### Stylus

为了使用 [Stylus](http://learnboost.github.io/stylus/)，你需要加 [ember-cli-stylus](https://github.com/drewcovi/ember-cli-stylus) 到你的 NPM 模块：

```
ember install ember-cli-stylus
```

### CoffeeScript

为了用 [CoffeeScript](http://coffeescript.org/)，你需要加 [ember-cli-coffeescript](https://github.com/kimroen/ember-cli-coffeescript) 到你的 NPM 模块里：

```
ember install ember-cli-coffeescript
```

`package.json` 的改动应该纳入源码版本控制。CoffeeScript 可以在你的源码和测试里面用，只需要用 `.coffee` 扩展名就好。我们推荐使用版本 >= 1.16.0 的 ember-cli-coffeescript 来避免用 `import` 和 `export` 语句。

注意：早期的编译器版本就明确支持 CoffeeScript，但是现在这个支持被删除了。


### EmberScript

为了用 [EmberScript](http://emberscript.com)，你需要加 [broccoli-ember-script](https://github.com/aradabaugh/broccoli-ember-script) 到你的 NPM 模块里：

```
npm install broccoli-ember-script --save-dev
```

注意：ES6 模块转译器不直接支持 Emberscript，要使用 \` 字符，和上面 CoffeeScript的例子差不多。

### Emblem

要用 [Emblem](http://emblemjs.com/)，跑这个命令：

```
ember install ember-cli-emblem
```

如果你用早期版本的 broccoli-emblem-compiler 插件，你需要选择 ember-cli-emblem。早期版本的 broccoli-emblem-compiler 直接编译成 JS 而不是 Handlebars，因此和现在新版的 HTMLBars 不兼容。

### 指纹和 CDN URLs

指纹使用这个插件 [broccoli-asset-rev](https://github.com/rickharrison/broccoli-asset-rev)
(默认已经包含)。

在生产环境(e.g. `ember build --environment=production`)，这个插件会自动化算你的js, css, png, jpg, gif 资源的指纹，添加一个 md5 checksum 到他们的文件名结尾
(e.g. `assets/yourapp-9c2cbd818d09a4a742406c6cb8219b3b.js`)。另外，你的 html, js, css 文件会被重写成新名字。这里有很多参数你可以传递给`EmberApp`，通过改 `ember-cli-build.js` 定制你的行为：

* `enabled` - 默认: `app.env === 'production'` - Boolean. 为真的时候启用指纹算法。**生产环境默认为True**
* `exclude` - 默认: `[]` - 一个字符串数组。如果一个文件名被包含，它不会被计算指纹。
* `ignore` - 默认: `[]` - 一个字符串数组。如果一个文件名被包含，它的内容不会被计算指纹。
* `extensions` - 默认: `['js', 'css', 'png', 'jpg', 'gif', 'map']` - 需要添加 MD5 checksum 的文件类型。
* `prepend` - 默认: `''` - 预先在所有资源添加。加 CDN urls 的时候很方便，比如 `https://subdomain.cloudfront.net/`
* `replaceExtensions` - 默认: `['html', 'css', 'js']` - 需要用带 checksum 文件名替换的文件类型。
* `customHash` - 指定了值的时候，追加到指纹文件名而不用 MD5。用 `null` 可以取代 hash，在用 `prepend` 的时候非常有用。

作为一个例子，这个 `ember-cli-build` 会给除了 fonts/169929 文件夹的所有资源文件都加上一个云前端域名。

```
// ember-cli-build.js
var app = new EmberApp({
  fingerprint: {
    exclude: ['fonts/169929'],
    prepend: 'https://subdomain.cloudfront.net/'
  }
});
```

最终的结果：

```
<script src="assets/appname.js">
background: url('/images/foo.png');
```

会变成

```
<script src="https://subdomain.cloudfront.net/assets/appname-342b0f87ea609e6d349c7925d86bd597.js">
background: url('https://subdomain.cloudfront.net/images/foo-735d6c098496507e26bb40ecc8c1394d.png');
```

在 `ember-cli-build.js` 里你可以禁用指纹算法:

```
// ember-cli-build.js
var app = new EmberApp({
  fingerprint: {
    enabled: false
  }
});
```

或者直接删除你 `package.json` 的 `EmberApp` 和  `broccoli-asset-rev`。

### 应用配置

你 `ember-cli-build.js` 里的应用配置会被存在 `dist/index.html` 一个特殊的 meta tag里。

meta tag的例子

```
<meta name="user/config/environment" content="%7B%22modulePre.your.config">
```

这个 meta tag 要求你的 ember 应用正常运行。如果你希望这个 tag 是你编译 js 文件的一部分，你可能需要在 `ember-cli-build.js` 里用 `storeConfigInMeta` 标记。

```
// ember-cli-build.js
var app = new EmberApp({
  storeConfigInMeta: false
});
```

#### 编辑输出路径

编译文件会输出到下面的路径：

|资源|输出文件|
|---|---|
|`app/index.html`|`/index.html`|
|`app/*.js`|`/assets/application-name.js`|
|`app/styles/app.css`|`/assets/application-name.css`|
|其他在 `app/styles` 的 CSS 文件|同样的文件到 `/assets`|
|用 `app.import()` 引入的 JS 文件|`/assets/vendor.js`|
|用 `app.import()` 引入的 CSS 文件|`/assets/vendor.css`|

想要改变这些路径，指定 `outputPaths` 配置选项。默认的选项：


```
// ember-cli-build.js
var app = new EmberApp({
  outputPaths: {
    app: {
      html: 'index.html',
      css: {
        'app': '/assets/application-name.css'
      },
      js: '/assets/application-name.js'
    },
    vendor: {
      css: '/assets/vendor.css',
      js: '/assets/vendor.js'
    }
  }
});
```

你可以改变这些路径，但是确保更新在 `app.outputPaths.app.html` 里的路径，它默认是 `index.html` 和 `tests/index.html`。如果没改对，你的 app 无法正常的识别资源文件。

```
// ember-cli-build.js
var app = new EmberApp({
  outputPaths: {
    app: {
      js: '/assets/main.js'
    }
  }
});
```

`outputPaths.app.css`选项用了一个 kv 对。*key* 是输入文件，*value* 是输出路径。注意，我们不需要包括扩展名，因为每个预处理器有不同的扩展名。

使用 CSS 预处理器的时候，只有 `app/styles/app.scss` (or `.less` etc) 被编译了。如果你需要处理多个文件，你需要加另一个 key：

```
// ember-cli-build.js
var app = new EmberApp({
  outputPaths: {
    app: {
      css: {
        'app': '/assets/application-name.css',
        'themes/alpha': '/assets/themes/alpha.css'
      }
    }
  }
});
```

#### 集成

当 ember 是在另一个项目内的时候，你可能只有一个特定路由的时候想要加载 ember。如果你提前加载了 ember 的 JS 文件，你需要禁用 `autoRun`：

```
// ember-cli-build.js
var app = new EmberApp({
  autoRun: false
});
```

手动跑Ember:
`require("app-name/app")["default"].create({/* app settings */});`

#### 子资源完整性

子资源完整性 [SRI integrity](http://www.w3.org/TR/SRI/) 计算由插件 [ember-cli-sri](https://github.com/jonathanKingston/ember-cli-sri) 完成(默认被包含。

子资源完整性是一个安全性概念，用来检查 JS 和样式用了 CDN 之后是不是有正确的内容。


#### 为什么

添加这个到你的应用是问了防止 CDNs 被劫持，从而改变你的 JS 或者 CSS。

- [JavaScript DDoS 预防](https://blog.cloudflare.com/an-introduction-to-javascript-based-ddos/)
  - 新版 [GitHub DDoS attack](http://googleonlinesecurity.blogspot.co.uk/2015/04/a-javascript-based-ddos-attack-as-seen.html)
- 防治不够信任的服务器的被污染代码

#### 定制

定制 SRI 器：[ember-cli-sri](https://github.com/jonathanKingston/ember-cli-sri)


## 依赖管理

### NPM 和 Bower 配置

Ember CLI 支持 [NPM](https://www.npmjs.com) 和 [Bower](http://bower.io/) 管理依赖。

一个 Ember CLI 生成的项目只有 NPM 依赖，你会发现 `package.json` 文件在你的工程根目录，没有 `bower.json`。
为了用 Bower，你需要用 `bower init` 来创建 `bower.json` 文件。

NPM 的 `package.json` 加上 Bower 的 `bower.json` 允许你声明你的依赖。改变你的依赖需要管理这俩文件，而不是手动的装包。

执行 `npm install` 会一键安装 `package.json` 里的依赖。同样的，执行 `bower install` 会一键安装 `bower.json` 里的依赖。

Ember CLI 默认配置了 git 忽略你的 `bower_components` 和
`node_modules` 文件夹。

Ember CLI 监控 `bower.json` 的改变，因此会重新加载你的应用，如果你通过 `bower install <dependencies> --save`装了新东西。如果你通过 `npm install <dependencies> --save`装东西，需要重启。


通过官方文档可以了解更多:

* [Bower](http://bower.io/)
* [NPM](https://www.npmjs.com)

注意，一般装东西用 `ember install` 是最容易的，它会保存所有的依赖到正确的文件，然后运行需要的步骤。

### 编译资源

Ember CLI 用 [Broccoli](https://github.com/broccolijs/broccoli) 。

资源清单在工程根目录的 `ember-cli-build.js`(不是默认的`ember-cli-build.js`).

为了加一个资源，在你调用 `app.toTree()` 之前指定依赖的资源到你的 `ember-cli-build.js`。你只能引入在 `bower_components` 或者 `vendor` 目录里的资源。以下示例场景说明了这是如何工作的。

#### Javascript 资源

##### 标准 Non-AMD 资源

首先，提供资料路径，作为唯一的参数 

```
app.import('bower_components/moment/moment.js');
```

文档指定的包，通常是全局变量。这个例子里：

```
import Ember from 'ember';
/* global moment */
// No import for moment, it's a global called `moment`

// ...
var day = moment('Dec 25, 1995');
```

注意: 不要忘了 ESLint，加 `/* global MY_GLOBAL */` 到你的模块，或者在 `.eslintrc.js` 的 `globals` 部分里定义。

另一种选择是你可以生成一个 ES6 shim，让库可以通过 `import` 引入。

首先，生成这个shim：

```
ember generate vendor-shim moment
```

然后，提供 vendor 资源路径：

```
app.import('vendor/shims/moment.js');
```

最后，使用这个包，添加合适的 `import` 语句：

```
import moment from 'moment';

// ...
var day = moment('Dec 25, 1995');
```

##### 标准 AMD 资源

提供资源路径作为第一个参数，模块和导出列表作为第二个：

```
app.import('bower_components/ic-ajax/dist/named-amd/main.js');
```

引入资源。比如，`ic-ajax`， 使用的时候 `ic.ajax.raw`:

```
import { raw as icAjaxRaw } from 'ic-ajax';
//...
icAjaxRaw( /* ... */ );
```

##### 标准匿名 AMD 资源

提供资源路径作为第一个参数，目标模块作为第二个：

```
app.import('bower_components/ic-ajax/dist/amd/main.js', {
  using: [
    { transformation: 'amd', as: 'ic-ajax' }
  ]
});
```

为了用资源而导入。比如，`ic-ajax`, 使用的时候 `ic.ajax.raw`:

```
import { raw as icAjaxRaw } from 'ic-ajax';
//...
icAjaxRaw( /* ... */ );
```

##### 环境指定资源

如果你在不同的环境需要用不同的资源，指定一个对象作为第一个参数。对象的 key 应该是环境的名字，value 是应该使用的资源文件。

```
app.import({
  development: 'bower_components/ember/ember.js',
  production:  'bower_components/ember/ember.prod.js'
});
```

如果你需要引入一个资源，在某个环境，但是其他环境不想引入它，你可以用 `app.import`，然后用 `if` 把它包起来。

```
if (app.env === 'development') {
  app.import('vendor/ember-renderspeed/ember-renderspeed.js');
}
```

##### 定制内置资源文件

这是不标准的方式，但是因为你可能需要用全部的handlebar版本，甚至在生产环境也是，所以支持这种方式。
你应该提供一个简单的路径给你的 `EmberApp` 构造器:

```
var app = new EmberApp({
  vendorFiles: {
    'handlebars.js': {
      production: 'bower_components/handlebars/handlebars.js'
    }
  }
});
```

另一种选择是，如果你想避免内置资源自动加载到 `vendor.js`，你可以把这个值设为 `false`:

```
var app = new EmberApp({
  vendorFiles: {
    'handlebars.js': false
  }
});
```

注意: 跑你的程序需要某些内置资源的依赖。如果你用上面的方法去指定排除某些东西，你应该用其他方法再重新引入。

##### 资源文件黑白名单

你可以限制哪些依赖运行或者不允许被导入到你的 Ember 应用，通过 EmberApp 的构造器选项。

```
var app = new EmberApp({
  addons: {
    blacklist: [
      'fastboot-app-server'
    ]
  }
});

```

##### 测试 Assets

你在跑测试的时候也许有其他的库(例如 qunit-bdd or sinon)。

```
// ember-cli-build.js
var EmberApp = require('ember-cli/lib/broccoli/ember-app'),
    isProduction = EmberApp.env() === 'production';

var app = new EmberApp();

if ( !isProduction ) {
    app.import( app.bowerDirectory + '/sinonjs/sinon.js', { type: 'test' } );
    app.import( app.bowerDirectory + '/sinon-qunit/lib/sinon-qunit.js', { type: 'test' } );
}

module.exports = app.toTree();
```

**注意:**
- 确保你传递 `{ type: 'test' }` 作为 `app.import` 的第二个参数。这可以确保你的库被编译成 `test-support.js` 文件。


#### 样式

##### 静态 CSS

资源文件作为第一个参数：

```
app.import('bower_components/foundation/css/foundation.css');
```

所有这样添加的的样式资源会被合并成一个文件 `/assets/vendor.css`。

##### 动态样式 (SCSS, LESS, etc)

自动生成的树通过实例化提供了可用的动态样式文件。例子如下(在 `app/styles/app.scss` 里):

```
@import "bower_components/foundation/scss/normalize.scss";
```

#### 其他资源

##### 使用 app.import()

所有的其他资源，如字体图片，可用被 `import()` 引入。默认他们会被拷贝到 `dist/` 文件夹。

```
app.import('bower_components/font-awesome/fonts/fontawesome-webfont.ttf');
```

这个例子会创建一个字体在 `dist/font-awesome/fonts/fontawesome-webfont.ttf`。

你可以选择告诉 `import()` 把文件放到一个不同的地方。这个例子是把文件拷贝到 `dist/assets/fontawesome-webfont.ttf`。

```
app.import('bower_components/font-awesome/fonts/fontawesome-webfont.ttf', {
  destDir: 'assets'
});
```

如果你需要在其他资源之前加载某个依赖，你可以设置 `prepend` 属性为 `true` 在 `import()` 的第二格参数。这会预加载依赖到生成目录而不是按默认行为追加。

```
app.import('bower_components/es5-shim/es5-shim.js', {
  type: 'vendor',
  prepend: true
});
```

如果你需要某个资源加载到某个特定文件。你可以提供一个 `outputFile` 选项给你的导入：

```
// ember-cli-build.js
app.import('vendor/dependency-1.js', { outputFile: 'assets/additional-script.js'});
app.import('vendor/dependency-2.js', { outputFile: 'assets/additional-script.js'});
```

作为结果，两个资源会按它们的制定顺序合并成一个到 `dist/assets/additional-script.js`。

主要: `outputFile` 只能被 javascript 和 css 文件使用。

##### 使用 broccoli-funnel

有了 [broccoli-funnel](https://github.com/broccolijs/broccoli-funnel)，部分 bower 安装的包可以被用作 as-is 资源。首先确认 Broccoli 包已经装好。

```
npm install broccoli-funnel --save-dev
```

添加这个引用到 `ember-cli-build.js` 的头部：

```
var Funnel = require('broccoli-funnel');
```

在 `ember-cli-build.js` 里，我们把资源从一个 bower 依赖和主程树合并：

```
module.exports = function(defaults) {

   ...

   // 只拷贝相关文件。例如 WOFF 文件和网页字体样式表

   var extraAssets = new Funnel('bower_components/a-lovely-webfont', {
      srcDir: '/',
      include: ['**/*.woff', '**/stylesheet.css'],
      destDir: '/assets/fonts'
   });

   // 提供额外的树给 `toTree` 方法会让这些树合并到最终的输出

   return app.toTree(extraAssets);

}
```

在上面的例子，这些资源从叫做 `a-lovely-webfont` 的虚构 bower 依赖调用，现在可以在 `/assets/fonts/` 里找到，可能被关联到 `index.html`。像这样：
```
<link rel="stylesheet" href="assets/fonts/lovelyfont_bold/stylesheet.css">
```

你可以把这些资源从最终的输出移除，用相似的方式。比如，在输出中排除所有的 `.gitkeep` 文件：
```
// 又一次，添加这个引用到 `ember-cli-build.js` 的头部
var Funnel = require('broccoli-funnel');

// 正常的 ember-cli-build 正文

// 选择 toTree() 的输出
var filteredAssets = new Funnel(app.toTree(), {
  // 排除 gitkeeps 到输出
  exclude: ['**/.gitkeep']
});

// 输出选择后的树
module.exports = filteredAssets;
```

注意: [broccoli-static-compiler](https://github.com/joliss/broccoli-static-compiler) 已经废弃了。使用 [broccoli-funnel](https://github.com/broccolijs/broccoli-funnel)。