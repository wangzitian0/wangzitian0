title: 从零到一建站（4）
author: 田_田
tags:
  - HTML
  - zero2one
  - golang
  - gin
categories: []
date: 2013-07-26 17:58:00
---
之前去美国出差，这个项目被耽搁了俩月，现在重新开始搞。被人吐槽了，所以我要重新梳理一下这些代码，做得更加符合 golang 的国际规范一点。

<!-- more -->
被人吐槽：
> Hey there! This is great code to go off of but I think it would be more helpful if comments were added to their appropriate places, which is also go fmt compliant. Thoughts?


# Go tools

## go fmt
第一件事是 go fmt，可以直接帮助 fmt 所有代码，本身我使用 intellij 了，应该代码本身已经没有编译问题，但是之前确实没有注意 fmt。

```
go fmt ./...
```

## go doc
我去研究了一下 golang 加注释的方式 [go fmt](https://github.com/golang/go/tree/master/src/fmt)，大致是几部分，一个是 doc.go 文件，另一个部分是每个函数前的注释，会被生成成这个样子[go fmt doc](https://golang.org/pkg/fmt/)
```
godoc -http=:6600
```
跑起来，然后进入http://localhost:6600/pkg/，找到自己的包就能看到实时编译的 doc 了。

## go test
这个基本不变，但是我之前最开始的几个 test 挂了一大半……现在逐渐把它做规范
```
go fmt ./...
```

# gogogo
## 从 users 模块开始改造
### goc.go
在里面加一些东西，注释需要加在 package 语句的上面。
```
/*
The user module containing the user CRU operation.

model.go: definition of orm based data model
routers.go: router binding and core logic
serializers.go: definition the schema of return data
validators.go: definition the validator of form data
*/
package users
```
### models.go
加上一些基本注释，还有方法函数的使用说明之类
```
// Models should only be concerned with database schema, more strict checking should be put in validator.
//
// More detail you can find here: http://jinzhu.me/gorm/models.html#model-definition
//
// HINT: If you want to split null and "", you should use *string instead of string.
type UserModel struct {
}


// You could update properties of an UserModel to database returning with error info.
//  err := db.Model(userModel).Update(UserModel{Username: "wangzitian0"}).Error
func (model *UserModel) Update(data interface{}) error {
}
```
### middlewares.go
这个部分和我最开始的想法稍微有一些不一样，因为现在已经把有 token 的用户的 user_model 直接读到 context 里面，所以和 users 这个模块无法分割，会形成交叉依赖，所以现在直接把两个模块合成一个。

### tests.go

大致就是把测试放到一个数组里面，然后依次去跑。
然后就是关于如何初始化和结束一个测试，大致有两种：
一种是文件级别的：[Set up & Tear down](https://golang.org/pkg/testing/#hdr-Main)，会在每一个 test 文件开始执行的前后执行，类似于装饰器。
一种是用例级别的：[关于Golang测试的最佳实践](https://medium.com/@sebdah/go-best-practices-testing-3448165a0e18)，直接在循环内部的开始处和结束处写Set up & Tear down的条件就好。

然后 golang 本身支持函数式编程，在定义数组的时候可以直接传递函数进去，然后在后面想调用的时候可以直接调用这个函数。比如可以手写Setup(), Teardown()两个函数传递进去。典型的一个例子是我可以不清空有状态的集合，这样若干组 test 连成一个 combine 。

同时，可以加一些数字来做 switch，在需要的时候只 assert 自己需要的变量和类型。

这个话题很多，可以参考我的代码。
```
var someTests = []struct {
	init           func(*http.Request)
	url            string
	msg            string
}{
	{
		func(req *http.Request) {
			resetDBWithMock()
		},
		"/users/",
		"POST",
		"valid data and should return StatusCreated",
	},
```

## Travis CI
关于持续集成的基础知识可以去搜一下，大致就是可以在 git 本身在提交前后都有一堆的 hook，然后 CI 系统可以帮你自动跑一些东西，跑的前后都会有相应的 hook。Travis CI是 github 支持最好的持续集成网站。
这个部分我反复提交了很多很多次才成功，只贴最后的结果。大致做的事情是在3个不同的 go 版本环境分别检测 gofmt 是不是符合规范，然后运行一遍所有的 test，最后上传覆盖率文件到codecov。
然后在相应的网站去找自动生成的 badge，贴到自己的 markdown 里面就好了：

[![Build Status](https://travis-ci.org/wangzitian0/golang-gin-starter-kit.svg?branch=master)](https://travis-ci.org/wangzitian0/golang-gin-starter-kit)
[![codecov](https://codecov.io/gh/wangzitian0/golang-gin-starter-kit/branch/master/graph/badge.svg)](https://codecov.io/gh/wangzitian0/golang-gin-starter-kit)

.travis.yml
```
language: go

go:
  - 1.7
  - 1.8.x
  - master

go_import_path: github.com/wangzitian0/golang-gin-starter-kit

services:
  - sqlite3

install:
  - go get -u github.com/wangzitian0/golang-gin-starter-kit
  - go get -u github.com/kardianos/govendor
  - govendor sync
script:
#  - go test -v ./...
  - bash ./scripts/gofmt.sh
  - bash ./scripts/coverage.sh

after_success:
  - bash <(curl -s https://codecov.io/bash)

```

https://github.com/wangzitian0/golang-gin-starter-kit/tree/0.0.3




