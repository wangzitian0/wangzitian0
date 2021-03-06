title: 从零到一建站（2）
author: 田_田
tags:
  - HTML
  - zero2one
  - golang
  - gin
categories: []
date: 2013-07-12 13:49:00
---
逛 github 的时候发现这个项目了，提供了一个不错的 spec，后续的工作围绕它的 spec 来做：[realworld](https://github.com/gothinkster/realworld)

<!-- more -->

## Fork form realworld
这是官方提供的 [spec](https://github.com/gothinkster/realworld/tree/master/spec)

现在 fork 这个项目，然后重命名成 golang-gin-starter-kit，然后参考上一篇文章，建立 go 的项目。

## 做一些小的实验
所有的实验我的是先在单个文件中实现，然后将他们的逻辑分散到各个不同的文件里面去。

### 建立DB连接池
我依旧打算使用 gorm，关于连接池的说法 [GORM Pooling](https://github.com/jinzhu/gorm/issues/246)

先在单个文件里面使用中间件，中间件来添加数据库连接：
```

type Todo struct {
	Title     string `form:"title" json:"title" binding:"exists,required"`
}

func ApiMiddleware() gin.HandlerFunc {
	db, err := gorm.Open("sqlite3", "gorm.db")
	if err != nil {
		fmt.Println("db err: ",err)
	}
	//defer db.Close()
	return func(c *gin.Context) {
		c.Set("DB", db)
		c.Next()
	}
}

func InitDB() {
	db, err := gorm.Open("sqlite3", "gorm.db")
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()

	db.AutoMigrate(&Todo{})
	//todo := Todo{
	//	Title: "heheda",
	//}
	//db.Save(&todo)
	//db.First(&todo)
	//fmt.Println("db: ",todo)
}

func main() {
	r := gin.Default()
	InitDB()

	r.Use(ApiMiddleware())

	r.GET("/ping", func(c *gin.Context) {
		db := c.MustGet("DB").(*gorm.DB) // MustGet returns an interface so you have to type cast it first :)
		var todo Todo
		db.First(&todo)
		c.JSON(200, gin.H{
			"message": "pong",
			"todo": todo,
		})
	})
	r.Run() // listen and serve on 0.0.0.0:8080
}
```

完成之后拆分成两个文件：
文件1： 
storage/database.go
```
package storage

import (
    "gopkg.in/gin-gonic/gin.v1"
    "github.com/jinzhu/gorm"
    "fmt"
)

func DatabaseConnection() *gorm.DB {
    db, err := gorm.Open("sqlite3", "gorm.db")
    if err != nil {
        fmt.Println("db err: ",err)
    }
    return db
}

func ApiMiddleware(db *gorm.DB) gin.HandlerFunc {
    return func(c *gin.Context) {
        c.Set("DB", db)
        c.Next()
    }
}

```

文件2：
hello.go
```
package main

import (
	"gopkg.in/gin-gonic/gin.v1"
	"github.com/jinzhu/gorm"
	"golang-gin-starter-kit/storage"
	_ "github.com/jinzhu/gorm/dialects/sqlite"
	"fmt"
)

type Todo struct {
	gorm.Model
	Title     string `form:"title" json:"title" binding:"exists,required"`
}

func main() {
	r := gin.Default()

	db := storage.DatabaseConnection()
	defer db.Close()
	r.Use(storage.ApiMiddleware(db))


	db.AutoMigrate(&Todo{})
	todo := Todo{
		Title: "heheda2",
	}
	db.Save(&todo)
	fmt.Println("db: ",todo)

	r.GET("/ping", func(c *gin.Context) {
		db := c.MustGet("DB").(*gorm.DB) // MustGet returns an interface so you have to type cast it first :)
		var todo Todo
		db.First(&todo)
		c.JSON(200, gin.H{
			"message": "pong",
			"todo": todo,
		})
	})
	r.Run() // listen and serve on 0.0.0.0:8080
}
```
此时控制台可以看到数据 `heheda2`
fresh 启动命令server之后 `curl http://localhost:8080/ping`可以看到东西，说明中间件正常运行。

### 数据绑定

这个部分我看了一下gin的反射实现机制，具体的文档在这里：
[go-playground/validator](https://github.com/go-playground/validator/tree/v8.18.1)

gin 本身用的就是validation.v8做校验器，然后 golang 反射包对应的 struct tag 改成了`binding`


```

type Todo struct {
    ID        int
	Title     string     `form:"title" json:"title" binding:"exists,alphanum,min=8,max=255"`
	Email     string     `form:"email" json:"email" binding:"exists,email"`
}


//main:

func (todo Todo) Response() (interface{}){
    return map[string]interface{}{
        "id": todo.ID,
        "title": todo.Title,
    }
}

	r.POST("/ping", func(c *gin.Context) {
		db := c.MustGet("DB").(*gorm.DB) // MustGet returns an interface so you have to type cast it first :)
		var todo Todo
		if err := c.Bind(&todo); err != nil {
            fmt.Println("before bind",err)
			errs := err.(validator.ValidationErrors)
            var res []interface{}
			for _, v := range errs {
				// can translate each error one at a time.
				fmt.Println(v.Value)
                res = append(res, v.Field)
			}
            c.JSON(http.StatusBadRequest, gin.H{"Data invalid" : res})
            return

		}
		fmt.Println("after bind",todo)
		if err := db.Save(&todo).Error; err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"Database error" : err})
			return
		}
		c.JSON(http.StatusCreated, todo.Response())
	})
```
alphanum 这个 tag 的意思是数字和字母，这个时候用 postman 测试，如果输入不是字母和数字就会返回StatusBadRequest。


### 整体源代码
此时已经可以正常运行
```
//column对应数据库存的数据的名称
type User struct {
    gorm.Model
    Username      string      `gorm:"column:username"`
    Email         string      `gorm:"column:email"`
    Bio           string      `gorm:"column:bio"`
    Image         string      `gorm:"column:image"`
    Salt          string      `gorm:"column:salt"`
    PasswordHash  string      `gorm:"column:password"`
}

//password加盐加密之后存数据库，校验的时候直接对比加密后的值
func (u *User) setPassword(password string){
    passwordHash := password + "salt"
    u.PasswordHash = passwordHash
}

func (u *User) checkPassword(password string) bool{
    passwordHash := password + "salt"
    return passwordHash == u.PasswordHash
}

// 需求里面的 spec 非常有奇怪的嵌套，这里进行一些 binding 的测试
type RegistrationForm struct {
    User struct {
        Username      string      `json:"username"`
        Email         string      `json:"email"`
        Password      string      `json:"password"`
    } `json:"user"`
}

type LoginForm struct {
    User struct {
        Email         string      `json:"email"`
        Password      string      `json:"password"`
    } `json:"user"`
}

// 大致测试一下整个流程是不是通的
func (User) Registration(c *gin.Context) {
    db := c.MustGet("DB").(*gorm.DB)
    var form RegistrationForm
    if err := c.Bind(&form); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"Data binding error" : err})
        return
    }
    var user User
    user.Username = form.User.Username
    user.Email = form.User.Email
    user.setPassword(form.User.Password)
    if err := db.Save(&user).Error; err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"Database error" : err})
        return
    }
    c.JSON(http.StatusCreated, gin.H{"user":user})
}

func (User) Login(c *gin.Context) {
    db := c.MustGet("DB").(*gorm.DB)
    var form LoginForm
    if err := c.Bind(&form); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"Data binding error" : err})
        return
    }
    var user User

    if err := db.Where(&User{ Email: form.User.Email}).First(&user).Error; err != nil {
        c.JSON(http.StatusForbidden, gin.H{"Database error" : err})
        return
    }
    fmt.Println("user from DB: ",user)

    if valid := user.checkPassword(form.User.Password); !valid {
        c.JSON(http.StatusForbidden, gin.H{"Error" : "password error!"})
        return
    }
    c.JSON(http.StatusOK, gin.H{"user":user})
}

// main.go

    v1 := r.Group("/api/v1/users")
    {
        user := new(User)
        v1.POST("/", user.Registration)
        v1.POST("/login", user.Login)
    }
```

此时应该有的效果

POST http://localhost:8080/api/v1/users
```
{
  "user":{
    "username": "Jacob",
    "email": "wzt@gg.cn",
    "password": "jakejake"
  }
}
```
返回：
```
{
    "user": {
        "ID": 1,
        "CreatedAt": "2017-07-16T14:02:37.381339679+08:00",
        "UpdatedAt": "2017-07-16T14:02:37.381339679+08:00",
        "DeletedAt": null,
        "Username": "Jacob",
        "Email": "wzt@gg.cn",
        "Bio": "",
        "Image": "",
        "Salt": "",
        "PasswordHash": "jakejakesalt"
    }
}
```

POST http://localhost:8080/api/v1/users/login
```
{
  "user":{
    "email": "wzt@gg.cn",
    "password": "jakejake"
  }
}
```
返回：
```
{
    "user": {
        "ID": 1,
        "CreatedAt": "2017-07-16T14:02:37.381339679+08:00",
        "UpdatedAt": "2017-07-16T14:02:37.381339679+08:00",
        "DeletedAt": null,
        "Username": "Jacob",
        "Email": "wzt@gg.cn",
        "Bio": "",
        "Image": "",
        "Salt": "",
        "PasswordHash": "jakejakesalt"
    }
}
```
POST http://localhost:8080/api/v1/users/login
```
{
  "user":{
    "email": "wzt@gg.cn",
    "password": "jakejakex"
  }
}
```
返回：
```
{
    "Error": "password error!"
}
```


### 模块划分
模块划分一般来说有两种模式，按照功能划分，按照应用结构划分
- 按照功能划分
 - 建立的文件夹叫 routers models views
 - 每个文件夹内用应用的名字命名文件 users.go articles.go
 - 定义结构体、对象、接口的时候，使用`功能.应用-模块`
 - 访问的时候 models.User routers.userLogin

- 按照应用结构划分
 - 建立的文件夹叫 users articles
 - 每个文件夹内用应用的名字命名文件 routers.go models.go views.go
 - 定义结构体、对象、接口的时候，使用`应用.模块-功能`
 - 访问的时候 users.UserModel users.Login
 - 中间件之类单独放一个文件夹

我使用第二种划分方法
```
.
├── BACKEND_INSTRUCTIONS.md
├── FRONTEND_INSTRUCTIONS.md
├── MOBILE_INSTRUCTIONS.md
├── bak.hello.gogo
├── gorm.db
├── hello.go
├── logo.png
├── readme.md
├── storage
│   └── database.go
├── tmp
│   └── runner-build
└── users
    ├── models.go
    ├── routers.go
    └── validators.go
```
models.go
放入 orm 模型定义相关的东西
routers.go
放入处理的逻辑，路由绑定关系
validators.go
表单、json 数据校验器
serializers.go
将来可能再加上，放入序列化的定义

此时，代码大致变成了这样： [github](https://github.com/wangzitian0/golang-gin-starter-kit/tree/v0.01)


## 实现 SPEC
有了刚才的若干试验，此时可以用刚才的手脚架正式开始加入 feature

### 数据库模型生成与密码保存
常识部分我搜了一个介绍[如何安全的存储用户的密码](http://www.freebuf.com/articles/web/28527.html)

这里选择 [bcrypt](https://en.wikipedia.org/wiki/Bcrypt#Algorithm)，它本身就是一个加了盐的算法，然后我们重写之前的生成密码和校验密码的方法。

另外，给模型加入tag `json:"balabala"`和`json:"-"`，这样默认的序列化会给对象加上相关的属性。

image 的 string变成一个指针，这样生成的字符串就可以是null，而不是一个 
字符串；[marshal null](https://stackoverflow.com/questions/31048557/assigning-null-to-json-fields-instead-of-empty-strings-in-golang)

此时 users/models.go变成：
```
package users

import (
    "golang.org/x/crypto/bcrypt"
    "golang-gin-starter-kit/common"
)

type UserModel struct {
    ID            uint        `json:"id" gorm:"primary_key"`
    Username      string      `json:"username" gorm:"column:username"`
    Email         string      `json:"email" gorm:"column:email;unique_index"`
    Bio           string      `json:"bio" gorm:"column:bio"`
    Image         *string     `json:"image" gorm:"column:image"`
    PasswordHash  string      `json:"-" gorm:"column:password"`
    JWT           string      `json:"jwt" gorm:"column:-"`
}

func (u *UserModel) setJWT()error{
    token, err := common.GenToken(u.ID)
    u.JWT = token
    return err
}

func (u *UserModel) setPassword(password string) error{
    bytePassword := []byte(password)
    passwordHash, err := bcrypt.GenerateFromPassword(bytePassword, bcrypt.DefaultCost)
    if err!=nil {
        return err
    }
    u.PasswordHash = string(passwordHash)
    err = u.setJWT()
    return err
}

func (u *UserModel) checkPassword(password string) error{
    bytePassword := []byte(password)
    byteHashedPassword := []byte(u.PasswordHash)
    err := u.setJWT()
    if err!=nil {
        return err
    }
    return bcrypt.CompareHashAndPassword(byteHashedPassword, bytePassword)
}
```

### Auth 中间件
这里的选型是 jwt，介绍可以看这个文章[JSON Web Token](http://blog.leapoahead.com/2015/09/06/understanding-jwt/),以及 oauth 的介绍[理解OAuth 2.0](http://www.ruanyifeng.com/blog/2014/05/oauth_2_0.html)

具体实现参考这个中间件[gin-jwt](https://github.com/gin-gonic/contrib/blob/master/jwt/example/example.go)，但是这个地方有一些坑，他的header引入的是这一个gin`"github.com/gin-gonic/gin"`,而我使用的是发布版`"gopkg.in/gin-gonic/gin.v1"`

common/utils.go
```
const NBSecretPassword = "heheda";

func GenToken(id uint) (string, error){
    token := jwt.New(jwt.GetSigningMethod("HS256"))
    // Set some claims
    token.Claims = jwt.MapClaims{
        "Id":  id,
        "exp": time.Now().Add(time.Hour * 24).Unix(),
    }
    // Sign and get the complete encoded token as a string
    return token.SignedString([]byte(NBSecretPassword))
}
```
直接在models的checkPassword里边加入生成JWT token的代码，之所以把生成的逻辑添加在这个地方，是因为每次登陆的时候都需要运行这段逻辑，另外，由于中间件可以从token里面直接解析出过期的时间，重复生成token是没有关系的。
```
func (u *UserModel) checkPassword(password string) error{
    bytePassword := []byte(password)
    byteHashedPassword := []byte(u.PasswordHash)
    token, err := common.GenToken(u.ID)
    if err!=nil {
        return err
    }
    u.JWT = token
    return bcrypt.CompareHashAndPassword(byteHashedPassword, bytePassword)
}
```
middlewares/auth-jwt.go
```
package middlewares


import (
    "gopkg.in/gin-gonic/gin.v1"
    "github.com/dgrijalva/jwt-go"
    "github.com/dgrijalva/jwt-go/request"
)

func Auth(secret string) gin.HandlerFunc {
    return func(c *gin.Context) {
        _, err := request.ParseFromRequest(c.Request, request.OAuth2Extractor, func(token *jwt.Token) (interface{}, error) {
            b := ([]byte(secret))
            return b, nil
        })

        if err != nil {
            c.AbortWithError(401, err)
        }
    }
}

```
hello.go
```
// main:

    r := gin.Default()
    testAuth := r.Group("/api/v1/ping")
    testAuth.Use(middlewares.Auth(common.NBSecretPassword))

    testAuth.GET("/", func(c *gin.Context) {
        c.JSON(200, gin.H{
            "message": "pong",
        })
    })

```
接着使用 postman 测试，过期时间设置为半分钟，先使用login接口登陆，此时的返回值应该长成这样：
```
{
    "user": {
        "id": 1,
        "username": "Jacob",
        "email": "wzt@gg.cn",
        "bio": "",
        "image": null,
        "jwt": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJJZCI6MSwiZXhwIjoxNTAwMjE3NzQzfQ.gJHBLwohyfPMub7_gbOE_jI_y9hYej4NauJKO-Gelio"
    }
}
```
header 中加入这个键值对 `Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJJZCI6MSwiZXhwIjoxNTAwMjE3NzQzfQ.gJHBLwohyfPMub7_gbOE_jI_y9hYej4NauJKO-Gelio`

此时应该能够看到一个返回值pong，我们正在半分钟之后再进行尝试，此时的返回值是401。

中间件完成

## 测试
[基本介绍+通用教程](http://tabalt.net/blog/golang-testing/)

[gin testing docs](https://github.com/gin-gonic/gin/pull/37)

### 测试文件结构
首先介绍`m *testing.M`，这是整个文件的入口，如果我们需要 setup 和 teardown，我们可以把相关的东西放到这个里面。`m.Run()`用来运行其他的测试`t *testing.T`
```
func TestMain(m *testing.M) {

    test_db, _ = gorm.Open("sqlite3", "./../gorm_test.db")
    test_db.AutoMigrate(&UserModel{})
    //fmt.Println("before")
    exitVal := m.Run()
    //fmt.Println("after")
    test_db.Close()
    os.Remove("./../gorm_test.db")

    os.Exit(exitVal)
}
```
### 最佳实践
个人认为的最佳实践是把相关参数和正则放到一个数字/dict 里面，然后用一个函数去依次执行相关的函数。
```
var routerRegistrationTests = []struct {
    bodyData        string
    expectedCode    int
    responseRegexg  string
    msg             string
}{
    {
        `{"user":{"username": "wangzitian0","email": "wzt@gg.cn","password": "jakejxke"}}`,
        http.StatusCreated,
        `{"user":{"id":1,"username":"wangzitian0","email":"wzt@gg.cn","bio":"","image":null,"token":"([a-zA-Z0-9-_.]{115})"}}`,
        "valid data and should return 200",
    },
    {
        `{"user":{"username": "u","email": "wzt@gg.cn","password": "jakejxke"}}`,
        http.StatusUnprocessableEntity,
        `{"errors":{"Username":"{min: 8}"}}`,
        "short username should return error",
    },
    {
        `{"user":{"username": "wangzitian0","email": "wzt@gg.cn","password": "j"}}`,
        http.StatusUnprocessableEntity,
        `{"errors":{"Password":"{min: 8}"}}`,
        "short password should return error",
    },
    {
        `{"user":{"username": "wangzitian0","email": "wztgg.cn","password": "jakejxke"}}`,
        http.StatusUnprocessableEntity,
        `{"errors":{"Email":"{key: email}"}}`,
        "email invalid should return error",
    },
}

func TestRouter_Registration(t *testing.T) {
    assert := assert.New(t)

    r := gin.New()
    usersGroup := r.Group("/p")
    usersGroup.Use(middlewares.DatabaseMiddleware(test_db))
    UsersRegister(usersGroup)
    for _, testData := range routerRegistrationTests{
        bodyData := testData.bodyData
        req, err := http.NewRequest("POST", "/p/", bytes.NewBufferString(bodyData))
        req.Header.Set("Content-Type", "application/json")

        assert.NoError(err)
        w := httptest.NewRecorder()
        r.ServeHTTP(w, req)

        assert.Equal(testData.expectedCode, w.Code, "code - " + testData.msg)
        assert.Regexp(testData.responseRegexg, w.Body.String(),"regexp - %v\n " + testData.msg)
    }
}
```

### 解释
核心是这一段代码，req 是一个 net/http 包生成的请求，现在模拟用户的请求，把它放到 req 里面，r 可以是一个 gin的路由，httptest.NewRecorder()包装了一个虚拟的请求，只要运行r.ServeHTTP(w, req)，就相当于在浏览器 curl 了相关地址。
后续我们可以 assert 相关的变量参数。
```
req, err := http.NewRequest()

w := httptest.NewRecorder()

r.ServeHTTP(w, req)
```
### 杂七杂八
#### assert
[github.com/stretchr/testify/](github.com/stretchr/testify/)这个库封装了很多东西，我这边主要是它用 assert。具体来说，`t *testing.T` 包含了报错的要素，现在`assert := assert.New(t)`把它传递给了这个库，然后后续用的时候可以少打参数。
最好用还是这个 assert：
```
assert.Regexp(x, y, msg)
```

#### os
想用golang来删除文件，查到了这个:
```
os.Remove("./../gorm_test.db")

test_db, _ = gorm.Open("sqlite3", "./../gorm_test.db")
```
发现一个问题，在根目录和子目录它对应的文件不同，后续需要找一个 config 的方案，给工程指定一个 env 变量。


#### Bearer Token
jwt-go 提供的 token 形式是 `Authorization: Bearer <token>`，但是 spec 里面需要的形式是`Authorization: Token <token>`。另外，我希望从 jwt-token 中读出 user_id 放进中间件，我选择仿照 oauth2 的接口直接重写中间件：
```
package middlewares


import (
    "net/http"
    "gopkg.in/gin-gonic/gin.v1"
    "github.com/dgrijalva/jwt-go"
    "github.com/dgrijalva/jwt-go/request"
    "golang-gin-starter-kit/common"
    "strings"
)
// Strips 'Bearer ' prefix from bearer token string
func stripBearerPrefixFromTokenString(tok string) (string, error) {
    // Should be a bearer token
    if len(tok) > 5 && strings.ToUpper(tok[0:6]) == "TOKEN " {
        return tok[6:], nil
    }
    return tok, nil
}

// Extract bearer token from Authorization header
// Uses PostExtractionFilter to strip "Bearer " prefix from header
var AuthorizationHeaderExtractor = &request.PostExtractionFilter{
    request.HeaderExtractor{"Authorization"},
    stripBearerPrefixFromTokenString,
}

// Extractor for OAuth2 access tokens.  Looks in 'Authorization'
// header then 'access_token' argument for a token.
var MyAuth2Extractor = &request.MultiExtractor{
    AuthorizationHeaderExtractor,
    request.ArgumentExtractor{"access_token"},
}



func Auth() gin.HandlerFunc {
    return func(c *gin.Context) {
        token, err := request.ParseFromRequest(c.Request, MyAuth2Extractor, func(token *jwt.Token) (interface{}, error) {
            b := ([]byte(common.NBSecretPassword))
            return b, nil
        })
        if err != nil {
            c.AbortWithError(http.StatusUnauthorized, err)
            return
        }
        if claims, ok := token.Claims.(jwt.MapClaims); ok && token.Valid {
            my_user_id := uint64(claims["id"].(float64))
            //fmt.Println(my_user_id,claims["id"])
            c.Set("my_user_id", my_user_id)
        } else {
            c.Set("my_user_id", uint64(0))
        }
    }
}

```
这里单独提一下`c.AbortWithError`这个函数。一旦使用它就应该马上 return，如果再使用其他 response 类函数如`c.JSON()`会panic。


#### bind error
这个查了很久的文档和源码，gin 本身使用的 validater 是 [go-playground/validator.v8](http://godoc.org/gopkg.in/go-playground/validator.v8)，它本身的实现是基于反射，给了很多的域，但是这些域是没法拿到其他 struct tag的，比如`json:"field0"`，我们没法从它的信息中得到field0这个字符串。如果非要拿，可以用reflect.Type得到名称之后再去取完整的 struct tag，然后再从中 Get 相关映射值。
```
type FieldError struct {
	FieldNamespace string
	NameNamespace  string
	Field          string
	Name           string
	Tag            string
	ActualTag      string
	Kind           reflect.Kind
	Type           reflect.Type
	Param          string
	Value          interface{}
}
```
另外是我希望嵌套 json 直接 bind 到结构体，事实证明可以嵌套，对应域的后面加上 tag 即可。
```
{"user":{"email":"john@jacob.com", "password":"johnnyjacob"}}

type LoginValidator struct {
    User struct {
        Email         string      `form:"email" json:"email" binding:"exists,email"`
        Password      string      `form:"password"json:"password" binding:"exists,min=8,max=255"`
    } `json:"user"`
}

```
spec 表单错误要求返回422，但是 bind 错误之后直接返回400了，还不能改写，所以我重写了这个函数，把 must 变成 should，自己接管错误检测。
```
func Bind(c *gin.Context, obj interface{}) error {
    b := binding.Default(c.Request.Method, c.ContentType())
    return c.ShouldBindWith(obj, b)
}
```


#### 巧用 struct tag
```
PasswordHash  string      `json:"-" gorm:"column:password;not null"`
Token         string      `json:"token" gorm:"column:-"`
```
一部分不希望被序列化，一部分不希望持久化，可以用减号来避免操作。
```
Image         *string     `json:"image" gorm:"column:image"`
```
如果希望字符串出现类似于 "hehe":null 的空值，那么需要使用指针。指针的 nil 和 “” 是两个不同的值。
```
Image         string      `form:"image" json:"image" binding:"omitempty,url"`
```
omitempty 是个特殊值，可以让你为空，或者为某种特定串。
具体可以仔细研究下文档[golang Marshal](https://golang.org/pkg/encoding/json/#Marshal)

#### 状态码
长知识了，状态码很多，表单错误最标准的返回应该是422
具体可以参考 net/http/status.go 里面的完整描述。



#### postman 真好用
[spec of realworld](https://github.com/gothinkster/realworld/tree/master/api#profile)这个文档里面给了一份脚本，这才是 postman 的正确姿势：
- 可以加入、根据 response 来修改环境的变量，如得到 token 之后写到一个环境变量里面
- 可以自动化跑一个组的 request
- 可以在返回值里面加入 assert，这样基本上不用肉眼看。
- 以前我用的是假的 postman。


### 总结
截止到目前，没有任何的数据库关系。[restful level2](https://martinfowler.com/articles/richardsonMaturityModel.html)的部分已经基本上和我想要的差不多了。因为要和 spec 完全对齐，所以这篇文章的代码和最终的有很多地方有差别，正式的代码可以看下面的github链接。
还差的东西：
- 加上全局的 config
- 多对多关系，外键，等等还没有使用
- github 的 badge
- commit 之后自动 build
- 缓存系统、session 之类
- 没有文档

至此 [v0.04](https://github.com/wangzitian0/golang-gin-starter-kit/tree/v0.04)