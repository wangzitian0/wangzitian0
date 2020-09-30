title: Embercli 文档（1）：开始
author: 田_田
tags:
  - Ember
  - Javascript
categories: []
date: 2013-11-07 20:49:00
---
embercli
The command line interface for ambitious web applications.
为有野心应用设计的命令行。
```
npm install -g ember-cli
```

翻译自https://ember-cli.com/，embercli 文档。
<!--more-->

## 概括
Ember CLI 是 [Ember.js](http://emberjs.com) 命令行提供了一个快速 [Broccoli](https://github.com/broccolijs/broccoli#broccoli)-powered 资源管道，一个非常符合惯例的工程结构，一个方便扩展的 [插件系统](http://www.ember-cli.com/extending/#developing-addons-and-blueprints). 

Ember CLI的 [资源编译系统](https://ember-cli.com/user-guide/#asset-compilation) 已经支持:

* [Handlebars](http://handlebarsjs.com/)
* [HTMLBars](https://github.com/tildeio/htmlbars/)
* [Emblem](http://emblemjs.com/)
* [LESS](http://lesscss.org/)
* [Sass](http://sass-lang.com/)
* [Compass](http://compass-style.org/)
* [Stylus](http://learnboost.github.io/stylus/)
* [CoffeeScript](http://coffeescript.org/)
* [EmberScript](http://emberscript.com/)
* Minified JS & CSS

除了上面这些, Ember CLI的 [插件系统](http://www.ember-cli.com/extending/#developing-addons-and-blueprints) 
提供了一种创建可复用代码单元的方法，用来扩展这个构建工具。查看插件[emberaddons](http://www.emberaddons.com/).

### 模块

Ember CLI 用 [babel](https://babeljs.io/) 把 [ES2015 module  语法](http://jsmodules.io/) 转化成 AMD (RequireJS-esq) 模块。
使用一个定制过的解释器(resolver)，Ember CLI可以在它需要的时候自动导入模块。比如路由器 `routes/post.js` 会知道使用控制器 `controllers/post.js` 应该使用模板 `templates/post.hbs`。
如果你的应用需要明确引入一个模块，你不会被自动解析限制，只需 `import` 一下就好了。

### CLI 的测试

所有用 Ember CLI 构建的应用默认使用 [QUnit](http://qunitjs.com/)  和 [Ember QUnit](https://github.com/rwjblue/ember-qunit)。尽管这些是默认的，你也可以自由选择其他的，比如 [Mocha](https://mochajs.org/) 和 [Ember Mocha](https://github.com/switchfly/ember-cli-mocha/)。

### 依赖管理
Ember CLI 使用两个包管理了工具：
[Bower](http://bower.io/), 用来管理自动更新的前端依赖(包括 jQuery, Ember, and QUnit) 
[npm](http://npmjs.org), 用来管理应用的内部依赖。
两个包管理工具可以同时用来管理你的依赖。

### 运行环境配置

Ember CLI的运行环境可以通过一个叫做`.ember-cli`的文件配置。这个长得像 JSON 格式的文件必须放在根目录，命令行选项应该用小驼峰格式。比如：

```
# ~/.ember-cli
{
  "skipGit" : true,
  "port" : 999,
  "host" : "0.1.0.1",
  "liveReload" : true,
  "environment" : "mock-development",
  "checkForUpdates" : false
}
```

### 正文安全策略

[ember-cli-content-security-policy](https://github.com/rwjblue/ember-cli-content-security-policy/)
插件可以用来启用在现代浏览器里跑开发环境的 [正文安全策略 headers](http://content-security-policy.com/)。启用正文安全策略headers可以帮助缓解几种特定类型的 XSS 工具或者数据注入。[浏览器支持](http://caniuse.com/#feat=contentsecuritypolicy)非常靠谱，
所以Ember CLI + Ember-CLI-Content-Security-Policy 插件使得建一个文本安全的应用十分简单。举例来说，生产环境启用[headers](/user-guide/#content-security-policy)十分简单。

### 社区

Ember CLI 是一个持续贡献的社区，它有持续的影响力。我们欢迎你提问，PR，修 bug，还有任何可以提高 Ember 开发者开发质量的事情。https://ember-cli.com/

### Node
现在， Ember CLI 支持 Node ([latest LTS recommended](https://nodejs.org/en/download/)), npm (3.x and above) 还有 yarn。

## 用户指南

### 先决条件

#### Node

首先，装好最新的 LTS 版本的 Node。值得注意的是，装 node 别用 sudo，最好是用 nvm 来装 node。
```
node -v
npm -v
```

#### Ember CLI

装好 node 之后全局装 Ember CLI:
```
npm install -g ember-cli
```
装完 `ember` 命令就可以用了

#### Bower

你要全局装一下[Bower](http://bower.io)

```
npm install -g bower
```

然后你就可以用 `bower` 命令行了。

#### Watchman

在 \*nix 系统, 推荐装 [Watchman](https://facebook.github.io/watchman/) version >= 4.x, 将会用一种更有效率地监控工程文件夹改动的方式。文件观察系统在 OSX 容易报错，Node 的内置 `NodeWatcher` 在监控大的目录树的时候有问题。[Watchman](https://facebook.github.io/watchman/)
用其他的方法在这些问题和性能上都表现不俗。你可以通过这个文章查看 FB 的设计思路
[here](https://www.facebook.com/notes/facebook-engineering/watchman-faster-builds-with-large-source-trees/10151457195103920).

OSX:

```
brew install watchman
```

完整的安装指令去查这个文档吧[Watchman website](https://facebook.github.io/watchman/)。注意 `npm` 有个包不是用来安装的。看到这些提示说明装错了：

```
invalid watchman found, version: [2.9.8] did not satisfy [^3.0.0], falling back to NodeWatcher
```

如果你的 `npm` 版本由于其他目的需要使用，确认它不在你的`PATH` ，不然:

```
npm uninstall -g watchman
```

用这个命令检查它

```
which -a watchman
```

最好，Watchman没装好的时候，调用不同的命令会触发同一个提示，可以放心的忽略他们：

```
Could not find watchman, falling back to NodeWatcher for file system events
```

#### PhantomJS

有了 Ember CLI，你可以随便用自动化测试，但是大部分测试服务会要你用或者推荐用 [PhantomJS](http://phantomjs.org/)。注意PhantomJS是 [Testem](https://github.com/airportyh/testem) 和 [Karma](http://karma-runner.github.io/0.12/index.html) 默认的运行程序。

如果你想用 PhantomJS 跑你的integration测试，它必须被全局安装：

```
npm install -g phantomjs-prebuilt
```

#### 创建新项目

运行 `new` 命令加上你要求的 app 名字来创建一个新项目：

```
ember new my-new-app
```

Ember CLI 会创建一个新的 `my-new-app` 目录，然后生成应用的工程结构。

生成过程完成后可以开始加载程序：
```
cd my-new-app
ember server
```

跳转到`http://localhost:4200` 可以看到你的 app.

跳转到`http://localhost:4200/tests` 可以看到你测试的结果

#### 从一个已有Ember但没用 Ember CLI 的项目迁移

如果你的 app 在用已经废弃的Ember App Kit，这里是一个 [迁移指南](https://github.com/stefanpenner/ember-app-kit#migrating-to-ember-cli)。

如果 app 全局用了其他的构建管道，如Grunt, Ember-Rails, or Gulp, 你可以试试用[Ember CLI migrator](https://github.com/fivetanley/ember-cli-migrator)。
Ember CLI migrator是一个命令行工具，看起来像是一个语法分析器，然后把代码根据 ember cli 的约定重写成 ES6。它会保持你的代码风格，而且保持 git 的历史通过`git log --follow`。

#### 复制一个已有的项目

如果你 checkout 一个已有的 ember cli 工程项目，你需要安装 `npm` 和 `bower` 的依赖，然后运行服务：
```
git clone git@github.com:me/my-app.git
cd my-app
npm install
bower install
ember server
```

### 使用 Ember CLI

 命令                                     | 用途
 :------------------------------------------ | :-------
 `ember`                                     | 打印可用命令列表
 `ember new <app-name>`                      | 创建了一个叫`<app-name>`的文件夹，在里面生成了应用结构。如果 git 可用，目录还会被初始化成一个有初始 commit 的 git 仓库。用 `--skip-git` 标记可用禁用这个特性。
 `ember init`                                | 在当前文件夹生成应用结构。
 `ember build`                               | 构建应用到`dist/` 目录 (自己指定可用`--output-path` 标记)。用 `--environment` 标记来指定构建环境(默认为 `development`)。用`--watch`标记来保持运行，改变发生时自动重新构建。
 `ember server`                              | 开启服务，默认端口是`4200`。用`--proxy`标记来转发 ajax 请求到某个地址。比如`ember server --proxy http://127.0.0.1:8080` 会代理所有ajax请求到运行在`http://127.0.0.1:8080`的服务商. 别名: `ember s`, `ember serve`
`ember generate <generator-name> <options>`  | 运行一个指定的生成器。`ember help generate`可以看有哪些生成器. 别名: `ember g`
`ember destroy <generator-name> <options>`  | 删除`generate`命令创建的代码。如果代码生成的时候有`--pod`标记，你需要用同样的标记去跑`destroy`。别名: `ember d`
 `ember test`                                | CI 模式用 Testem 跑测试。你可以通过`testem.json`文件传递任何参数。默认情况Ember CLI会搜索你的工程根目录。你也可以指定一个`config-file`. 别名: `ember t`
 `ember install <addon-name>`                | 安装插件到工程，并将它保存到`package.json`，有必要的话命令还会自己跑 [blueprint](http://www.ember-cli.com/extending/#generators-and-blueprints).

### 文件夹布局

 文件/目录         | 目的
 :-------------      | :-------
 `app/`              | 包含你Ember应用的代码。Javascript文件在这个文件夹会被编译和连接成一个文件`<app-name>.js`。这个表格后面有更多信息
 `dist/`             | 包括可以分发(优化后且独立)的应用输出。部署这个文件到服务器。
 `public/`           | 这个目录包括逐字拷贝的文件。如图和字体等不需要构建的资源文件使用它。
 `tests/`            | 包括你的单元和集成测试，同时加上助手函数。
 `tmp/`              | 构建时临时应用和调试输出。
 `bower_components/` | `Bower` 依赖 (默认值+用户安装的包)。
 `node_modules/`     | `npm` 依赖 (默认值+用户安装的包)。
 `vendor/`           | 你不通过 bower 和 npm 安装的其他的依赖。
 `.eslintrc.js`         | [ESLint](http://eslint.org/docs/user-guide/configuring) 配置
 `.gitignore`        | Git忽略文件的配置。
 `ember-cli-build.js` | 包含构建管道 [Broccoli](https://github.com/joliss/broccoli) 的说明。
 `bower.json`        | Bower 配置和依赖。
 `package.json`      | npm 配置和依赖。主要用来列出资源编译的依赖


### app 文件夹里面的布局

 文件/目录    | 目的
 :------------- | :-------
 `app/app.js` | 你的应用的入口。这是执行的第一个模块。
 `app/index.html` | 你的单页应用唯一的页面！包括依赖和 ember 应用。
 `app/router.js` | 你的路由配置。这里定义的路由和`app/routes/`处定义的路由差不多。
 `app/styles/` | 你的样式表，无论是SASS, LESS, Stylus, Compass, 还是朴素 CSS (尽管只允许用一种类型，详情可以看资源编译)。他们都会被编译成`<app-name>.css`.
 `app/templates/` | 你的 HTMLBars模板。他们会被编译到`/dist/assets/<app-name>.js`。模板命名和他们的名字一样(i.e. `templates/foo/bar.hbs` -> `foo/bar`)。
 `app/controllers/`, `app/models/`, etc. | Ember CLI解释器生成的模块

[PhantomJS]: http://phantomjs.org
[Homebrew]: http://brew.sh

#### app/index.html

`app/index.html` 文件放置了你的基础架构。它是一个基于 DOM 结构的布局，设置了标题属性，引入了样式表。另外，`app/index.html`包括多个hook

```
{{content-for 'head'}}
{{content-for 'body'}}
```

可以被插件注入到应用的`head` 或 `body`。这些hook需要留在合适的位置，你也可以安全地忽略你没有操作的插件。

### 插件

插件会在 npm 注册，使用关键词`ember-addon`。查看完整列表 [here](https://www.npmjs.org/browse/keyword/ember-addon).

### 子路径上开发

如果你的 app 不是运行在根路由上(`/`)，而是一个子路径 (比如
`/my-app/`)，你的 app 只能在 `/my-app/`路由上访问，而不能在 `/my-app`上。有时候这可能很艹蛋。因此，你应该用这个简单的代码片段来确保你的路由去了对的地方：

```Javascript
// index.js
module.exports = function(app) {
  app.get('/my-app', function(req, res, next) {
    let subpath = '/my-app/';
    if (req.path !== subpath) {
      res.redirect(subpath);
    } else {
      next();
    }

  });
};
```
直接把它放到`/server`文件夹里的`index.js`里，（这样跑本地服务器的时候才会启用）。这段代码测试这个 url 是不是`/my-app/`前缀。如果不是会跳转。