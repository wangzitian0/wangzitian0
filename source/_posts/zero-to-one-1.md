title: 从零到一建站（1）
author: 田_田
tags:
  - HTML
  - zero2one
  - golang
  - gin
categories: []
date: 2013-06-29 20:00:00
---
我现在想写一个从零到一建web 网站的教程。也想留下一个好的工程模板。

<!-- more -->

## 基本要求
### 设想
麻雀虽小，五脏俱全
- 用户邮件或者手机注册
- 每个用户看到自己的内容
- 就做经典的 todolist 吧
- 让用户之间可以共享文档
- 前后端做好分离，后端 restful，前端 SPA
- 加一点简单的 gis、短信或者其他的云服务。

### 后端
基本要求：
- 有一个舒服的框架来帮助实现路由绑定和分级、数据打包。
- 有一个好的 orm 插件，帮助处理80%以上的数据库细节
- 有一个好的表单验证插件，数据合法性尽可能直接使用配置
- 要能方便的实现 RESTFUL，方便实现oauth。
- 自己实现几个中间件
选型：
我自己非常熟悉 django，BOJv3和 BOJv4花费了大量的时间学习和开发，如果使用 pinax，可以使得开发非常快。但是 django 有点重，即使写过一遍，还是会花费极多的时间来看文档。

基本要求，要么测试覆盖率90%+，要么 github 千星以上。

这一次试试 golang，工作的时候用了半年的 gin。查了很久的资料，三件事分别使用三个不同插件，剩余的尽可能直接使用 golang 的内置实现，如果不行就弃坑。

- 框架选择 gin，赤兔用的框架，flask 风格，路由实现还可以，比对了其他的 beego 和 Gorilla、Revel等几个比较火的，用这个比较清爽的吧。
- Gorm：golang 体系里最火的 orm
- [validator](https://github.com/go-playground/validator): 一个测试覆盖率100%的项目。


### 前端
基本要求：
- 最好是 SPA，单页面应用。
- 使用好的打包工具与发布流程。

目前来说前端全家桶世界是三驾马车：Angular，React，Vue。
综合来说Angular最老，React人最多，Vue学习曲线最舒服。
打包工具选择 gulp 和 webpack，走在世界前列。

### 持续集成
基本要求：
- 前后端争取都把覆盖率做到85%+
- 放在 github，使用优雅的姿势，把三方的源码检测 icon 加进来
- 上线版本管理。
- 如果有机会，反作用于开源社区
这部分还没有想特别清楚。后期弄完了再专门写一篇文章。


## 开工
信仰不能变，JetBrains Gogland + Webstorm
流程类似这样[不和谐](http://www.jianshu.com/p/15e6f6ca335e)

跳转到定义可以直接 cmd+click，这一个功能就能大大提高开发效率。

前端包管理使用 NPM，后端包管理使用自带的vendor。不明白我在说啥的可以看看这个：[各种语言常见的包管理工具](https://www.tianmaying.com/tutorial/package-manager)


### 安装 Golang
官网下一个[安装包](https://golang.org/doc/install)
.zshrc 里加上环境变量
```
export GOROOT=/usr/local/go/
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$GOPATH/bin:$GOROOT/bin
```
正常情况看到这个就行
```
➜  todolist-backend git:(master) ✗ go version  
go version go1.8.3 darwin/amd64
```

### 使用 vendor 管理包
大致是先要指定一个 GOPATH，然后里面建一个 src 文件夹，然后再 src 文件夹里面建立工程。
```
cd /tmp/test/src
mkdir myproj
cd myproj
govendor init
```
这个时候出现一个vendor文件夹。

参考这个资料：[vendor的简要说明](https://golang.top/articles/9785)

### 安装  Gin
Gin 的官方地址是 gopkg.in/gin-gonic/gin.v1
```
govendor fetch gopkg.in/gin-gonic/gin.v1
```
此时 vendor 文件夹应该变了：
```
{
	"comment": "",
	"ignore": "test",
	"package": [
		{
			"checksumSHA1": "UsILDoIB2S7ra+w2fMdb85mX3HM=",
			...
		},
        ...
		{
			"checksumSHA1": "hT+7DPyl8tQ96kUXW3Sr5o0Pcj0=",
			"path": "gopkg.in/gin-gonic/gin.v1",
			"revision": "e2212d40c62a98b388a5eb48ecbdcf88534688ba",
			"revisionTime": "2016-12-04T22:13:08Z"
		},
        ...
	],
	"rootPath": "todolist-backend"
}
```
这里可以看到很多的包，很有意思，validator和我之前调研的居然是同一个。

### hello gin

这个时候吧 hello world拷贝到工程目录:
```
➜  todolist-backend git:(master) ✗ touch hello.go
```
内容：
```
package main

import "gopkg.in/gin-gonic/gin.v1"

func main() {
	r := gin.Default()
	r.GET("/ping", func(c *gin.Context) {
		c.JSON(200, gin.H{
			"message": "pong",
		})
	})
	r.Run() // listen and serve on 0.0.0.0:8080
}
```
运行之：
```
➜  todolist-backend git:(master) ✗ go run hello.go
```
浏览器打开`http://localhost:8080/ping`
可以看到`{"message":"pong"}`

然后把 golang 最热门的 orm 工具 gorm 装上
```
➜  todolist-backend git:(master) ✗ govendor fetch github.com/jinzhu/gorm
➜  todolist-backend git:(master) ✗ govendor fetch github.com/go-sql-driver/mysql
```
后端基础安装工作完成！
### auto reload
每次改东西都重启服务很不爽，所以找到一个库[gin fresh](https://github.com/pilu/fresh)
```
➜  todolist-backend git:(master) ✗ go get github.com/pilu/fresh
➜  todolist-backend git:(master) ✗ fresh
```

### 跑起来非常非常慢
查资料发现应该是依赖的 pkg 并没有编译[go build very slow](https://stackoverflow.com/questions/24341654/go-build-became-very-slow-after-installing-a-new-version-of-go)

## 简单的 RESTFUL 接口
Restful 的具体要求可以去查看我的博文

简言之：
```
POST todos/
GET todos/
GET todos/{id}
PUT todos/{id}
PATCH todos/{id}
DELETE todos/{id}
```

### 架子
创建一个文件 main.go
```
➜  todolist-backend git:(master) ✗ touch main.go
```

输入
```
package main

import (
    "gopkg.in/gin-gonic/gin.v1"
)

func main() {
    router := gin.Default()
    v1 := router.Group("/api/v1/todos")
    {
        v1.POST("/", CreateTodo)
        v1.GET("/", FetchAllTodo)
        v1.GET("/:id", FetchSingleTodo)
        v1.PUT("/:id", UpdateTodo)
        v1.DELETE("/:id", DeleteTodo)
    }
    router.Run()
}
```

### 确认数据库运行
gorm.Model 包含了基本的一些变量 “ID, CreatedAt, UpdatedAt, DeletedAt”

```
type Todo struct {
    gorm.Model
    Title     string `json:"title"`
    Completed int `json:"completed"`
}

type TransformedTodo struct {
    ID        uint `json:"id"`
    Title     string `json:"title"`
    Completed bool `json:"completed"`
}
```

注释掉 main() 里面的其他东西，只保留这一部分
```
    db := Database()
    db.AutoMigrate(&Todo{})
    defer db.Close()
```
此时应该会在工程目录下出现一个 gorm.db 文件。


### 先模仿别人的
请先阅读下面的文章，后端是在他基础上的改进！

请先阅读下面的文章，后端是在他基础上的改进！

请先阅读下面的文章，后端是在他基础上的改进！

[Build RESTful API with GIN](https://medium.com/@thedevsaddam/build-restful-api-service-in-golang-using-gin-gonic-framework-85b1a6e176f3)

我把它的代码在本地运行了。
好处：
- 提供了一个 gin 和 gorm 一起工作的样板
- 提供了一个增删改查的能正确运行的架子，减少踩坑的次数
问题：
- 并不是很标准的 restful，返回值乱包了东西。
- 数据接受dataform，不能根据 content-type 来自己适配


## 改进代码
基本要求如下：
GET api/v1/todos/ 返回对象全集
POST api/v1/todos/ 返回新生成的对象
PUT api/v1/todos/id 返回被更新的对象
PATCH api/v1/todos/id 返回被更新的对象
DELETE api/v1/todos/id 返回成功提示

### CreateTodo
#### 同时支持 form_data && json_data
我们希望 post 同时支持 form_data && json_data

这个部分先去 gin 框架的文档搜，发现它的实现方式是用 c.bind(&something)，大致 就是把 request 数据绑定到一个结构体里面去。

[model-binding-and-validation](https://github.com/gin-gonic/gin#model-binding-and-validation)
官方这样：
```
type Login struct {
	User     string `form:"user" json:"user" binding:"required"`
	Password string `form:"password" json:"password" binding:"required"`
}
```
我自己把域改成类似的样子，经过 postman 的测试，这段代码是可以工作的。但测了几个数据，发现一个天坑，0 和 false 无法被 gin 的 binding接受，然后解决方案是这样： [use pointer & 'exists'](https://github.com/gin-gonic/gin/issues/491)

大致是说required域在结构体创建的时候会有一个默认值，程序没法知道这个值是由post_data 来的还是默认来的，因此需要使用指针来判断。

此时大概这样：
```
type Todo struct {
    gorm.Model
    Title     string `form:"title" json:"title" binding:"required"`
    Priority  *int `form:"priority" json:"priority" binding:"exists"`
    Completed *bool `form:"completed" json:"completed" binding:"exists"`
}
```
然后，我进一步常识，发现不需要使用指针，直接把 binding 域改成 exists 就好了。

动手修改了定义模型的结构体，这样 bind 的时候就会把作用域自动绑定，另外把域修改为 int, bool, string 各一个，麻雀虽小五脏俱全：
```

type Todo struct {
    gorm.Model
    Title     string `form:"title" json:"title" binding:"required"`
    Priority  int `form:"priority" json:"priority" binding:"exists"`
    Completed bool `form:"completed" json:"completed" binding:"exists"`
}
```
#### CreateTodo
然后这个时候我们去修改CreateTodo
```
func CreateTodo(c *gin.Context) {
    var todo Todo
    fmt.Println(todo)
    if err := c.Bind(&todo); err != nil {
        fmt.Println(err)
        c.JSON(http.StatusBadRequest, gin.H{"Data binding error" : err})
        return
    }
    db := Database()
    defer db.Close()

    if err := db.Save(&todo).Error; err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"Database error" : err})
        return
    }
    c.JSON(http.StatusCreated, todo)
}
```
此时已经比较接近我想要的 CreateTodo
#### 定制 Response
看了几个资料之后觉得这种是最好的[different marshalling & unmarshalling](https://stackoverflow.com/questions/26303694/json-marshalling-unmarshalling-same-struct-to-different-json-format-in-go)
```
//自制一个 Response，可以自由插入元素个数

type TodoResponse struct {
    ID        uint `json:"id" xml:"id"`
    Title     string `json:"title" xml:"title"`
    Priority  int `json:"priority" xml:"priority"`
    Completed bool `json:"completed" xml:"completed"`
}

func (todo Todo) Response() (interface{}){
    return TodoResponse{
        ID: todo.ID,
        Title: todo.Title,
        Priority: todo.Priority,
        Completed: todo.Completed,
    }
}

//把CreateTodo()里的返回改成自制的函数
...
c.JSON(http.StatusCreated, todo.Response())
//注释掉上面一句，取消下面一句可以返回 xml
//c.XML(http.StatusCreated, todo.Response())
...

```
#### 总结
用 json marshul 自带的功能来反序列化，这样使用框架自带的 binding 功能，一次性支持多种格式。
然后序列化自己写函数来生成一个对象，然后由框架根据 header 完成序列化。

Todo:
- 理想情况应该是根据 header 里的 Accept 选项来选择 response 的 content-type
- 没有记录 log，包括 error 的收集和用户访问 tracking。
- Schema 没有严格的数据校验，应该加入一个 validater 的库

### FetchAllTodo
先把返回形式改成我自己接受的
```
func FetchAllTodo(c *gin.Context) {
    var todos []Todo
    var _todos []interface{}

    db := Database()
    db.Find(&todos)

    if (len(todos) <= 0) {
        c.JSON(http.StatusNotFound, gin.H{"error" : "No todo found!"})
        return
    }

    //transforms the todos for building a good response
    for _, todo := range todos {
        _todos = append(_todos, todo.Response())
    }
    //c.JSON(http.StatusOK, _todos)
    c.XML(http.StatusOK, _todos)
}
```
理论上这个接口应该承接搜索和分页的内容：
api/v1/todos/?min_priority=2
api/v1/todos/?page=0&per_page=10
api/v1/todos/?min_priority=2&page=0&per_page=10
此时搜索一下 gorm 的 limit where offset 的用法，然后用 Query Param把参数传递到 gin。
```
func FetchAllTodo(c *gin.Context) {
    var todos []Todo
    var _todos []interface{}

    db := Database()

    page_str := c.Query("page");
    page, err := strconv.Atoi(page_str);
    if  err!=nil {
        page = 0
    }
    per_page_str := c.Query("per_page")
    per_page, err := strconv.Atoi(per_page_str);
    if  err!=nil {
        per_page = 10
    }
    db = db.Limit(per_page).Offset(per_page * page)

    min_priority_str := c.Query("min_priority")
    min_priority, err := strconv.Atoi(min_priority_str);
    if  err==nil {
        db = db.Where("priority >= ?", min_priority)
    }
    db.Find(&todos)

    if (len(todos) <= 0) {
        c.JSON(http.StatusNotFound, gin.H{"error" : "No todo found!"})
        return
    }

    //transforms the todos for building a good response
    for _, todo := range todos {
        _todos = append(_todos, todo.Response())
    }
    c.JSON(http.StatusOK, _todos)
    //c.XML(http.StatusOK, _todos)
}
```
Todo：
- 搜索这类功能最好引入 ElasticSearch，直接暴力叠参数和查关系数据库效率低，容易把库拖垮
- 分页器最好写成中间件，然后应用到所有的 list。

### GET & PUT & PATCH SingleTodo
这个部分直接改动返回值，然后PUT & PATCH做出区别。
PUT 没有值是设置为默认值，PATCH没有值是设置为原来的值。
```
func FetchSingleTodo(c *gin.Context) {
    var todo Todo
    todoId := c.Param("id")

    db := Database()
    db.First(&todo, todoId)

    if (todo.ID == 0) {
        c.JSON(http.StatusNotFound, gin.H{"error" : "No todo found!"})
        return
    }

    c.JSON(http.StatusOK, todo.Response())
}

func UpdateTodo(c *gin.Context) {
    var todo, todoTmp Todo
    todoId := c.Param("id")
    db := Database()
    db.First(&todoTmp, todoId)

    if (todoTmp.ID == 0) {
        c.JSON(http.StatusNotFound, gin.H{"message" : "No todo found!"})
    }else if err := c.Bind(&todo); err == nil {
        fmt.Println(todoTmp)
        todo.ID = todoTmp.ID
        db.Save(&todo)
        c.JSON(http.StatusOK, todo.Response())
    }else {
        c.JSON(http.StatusBadRequest, gin.H{"Bind Error" : err })
    }
}

func PartialUpdateTodo(c *gin.Context) {
    var todo Todo
    todoId := c.Param("id")
    db := Database()
    db.First(&todo, todoId)

    if (todo.ID == 0) {
        c.JSON(http.StatusNotFound, gin.H{"message" : "No todo found!"})
    }else if err := c.Bind(&todo); err == nil {
        //--- 可以手工一个个域更新，也可以一次性更新 todo ---
        //db.Model(&todo).Update("title", c.PostForm("title"))
        //db.Model(&todo).Update("completed", c.PostForm("completed"))
        db.Model(&todo).Update(todo)
        c.JSON(http.StatusOK, todo.Response())
    }else {
        c.JSON(http.StatusBadRequest, gin.H{"Bind Error" : err })
    }
}
```

### DeleteTodo
```
func DeleteTodo(c *gin.Context) {
    var todo Todo
    todoId := c.Param("id")
    db := Database()
    db.First(&todo, todoId)

    if (todo.ID == 0) {
        c.JSON(http.StatusNotFound, gin.H{ "error" : "No todo found!"})
        return
    }

    db.Delete(&todo)
    c.JSON(http.StatusOK, gin.H{"message" : "Todo deleted successfully!"})
}
```

## 总结
至此，RESTFUL 的架子搭好了。完整的代码在[github](https://github.com/wangzitian0/todolist-backend/tree/v0.01)
说句实话，开发的速度大大低于我的预期，而且连英文的文档也支持非常不好，几乎只能直接读代码，我还是喜欢 rails 和 django 这种The Web framework for perfectionists with deadlines的框架。

todo：
- 缺少一些批量的接口，比如batch_POST
```
v1.POST("/", BatchCreateTodo)
v1.GET("/", BatchFetchTodo)
```
- 还没有实现 auth
- 对 header 的控制不够，缺少根据 header 对内容进行转变的中间件。
- 无埋点方案的 log 和 tracking
- gorm 还没有使用一对多、多对多关系
- Hypermedia，我希望搞成类似 django 处理模板 url 的 URL reverse技术

调研了一下，有两个需求做起来非常的困难。所以我接下来会去尝试其他的框架或者类库。

[Go 的框架基本上不慢](http://www.techempower.com/benchmarks/#section=data-r8&hw=ph&test=plaintext)。