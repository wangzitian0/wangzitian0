title: 用Gulp处理变态的静态资源
author: 田_田
date: 2017-06-26 19:48:09
tags:
---
静态资源的更新是一门学问，问题为何产生可以查看这个文章：[变态的静态资源缓存与更新](https://my.oschina.net/jathon/blog/404968)

<!-- more -->

## 基本工程文件
### 先准备工程的手脚架
```shell
npm install -g gulp
npm init
#输入信息后 package.json 应该大致长这个样子，这是 npm 安装依赖软件包的根据 
{
  "name": "gulp-demo",
  "version": "1.0.0",
  "description": "test gulp",
  "main": "index.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "author": "wangzitian0",
  "license": "WTFPL"
}
```
然后可以用 npm 安装各种基本依赖
```
npm install --save-dev gulp
npm install --save-dev gulp-watch
```
### 准备 gulp 基本文件
工程目录创建一个文件 Gulpfile.js
```
var gulp = require('gulp');

gulp.task('default', function() {
  // 将你的默认的任务代码放在这
});
```
### 概览
我的工程大致长这个样子，包含基本的 js、html、png 文件，还有需要编译的 sass 文件。
```
.
├── Gulpfile.js
├── package.json
└── src
    ├── images
    │   ├── baidu.png
    │   ├── headlogo.png
    │   ├── linkedin.png
    │   ├── logo-1.png
    │   ├── logo-2.png
    │   ├── sidebar01.png
    │   └── weibo.png
    ├── index.html
    ├── js
    │   └── main.js
    ├── lib
    │   ├── video-js.css
    │   ├── video.min.js
    │   └── videojs-ie8.min.js
    └── sass
        └── mobile.scss
```
## 编译 sass

### 基本使用
```
npm install --save-dev gulp-sass
```
然后到 gulpfile 里面添加类似的东西：
```
'use strict';

var gulp = require('gulp');
var sass = require('gulp-sass');

gulp.task('sass', function () {
  return gulp.src('./src/sass/*.scss')
    .pipe(sass().on('error', sass.logError))
    .pipe(gulp.dest('./dist/css'));
});

//用 src 来读源文件，经过 sass 处理之后，输出到 dist 文件夹

gulp.task('default', ['sass',]);
```

gulp执行的任务就是gulp.task里面第一个参数指定的 `default`，如果要执行编译 sass 任务输入`gulp sass`即可:
```
gulp sass
gulp
```
此时应该要多一个文件夹 dist
```
├── dist
│   └── css
│       └── mobile.css
```






