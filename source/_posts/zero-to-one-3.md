title: 从零到一建站（3）
author: 田_田
tags:
  - HTML
  - zero2one
  - golang
  - gin
categories: []
date: 2013-07-26 17:31:00
---
这一篇开始设计具体的业务模型。主要是数据库的 one2one，one2many，many2many


<!-- more -->

## 准备工作
[gorm_example](https://github.com/adlerhsieh/gorm_example)
先看看这个项目，除了 self reference 里面没有之外，其他的常见关系都被涵盖了。下面这个命令可以让我们查看 orm 生成的 SQL 长什么样子。
```
db.LogMode(true)
```

需要提到的一点是，变量名会自动转换，大驼峰转为全小写下划线连接。
如 UserID 这个 field 在数据库中的 column 名会变成 user_id。

## 第一个关系数据following
这个模块应该是一个[self-reference](https://github.com/jinzhu/gorm/issues/653)的m2m 模型。由于我没有复现这个过程，我直接采用另一种方式，新建一个模型，添加两个外键。
```
type FollowModel struct {
    gorm.Model
    Following       UserModel
    FollowingID     uint
    FollowedBy      UserModel
    FollowedByID    uint
}
```
自己做实验，核心的代码如下：
```
db.Where(FollowModel{
    FollowingID: myUserModel.ID,
    FollowedByID: userModel.ID,
}).First(&follow)
```
用这个方法可以充分的利用 orm 特性。
users/routers.go
```
func ProfileRegister(router *gin.RouterGroup) Router{
    r := Router{}
    r.BasePath = router.BasePath()
    router.GET("/:username", r.ProfileRetrieve)
    router.POST("/:username/follow", r.ProfileFollow)
    router.DELETE("/:username/follow", r.ProfileUnfollow)
    return r
}

func (r Router) ProfileRetrieve(c *gin.Context) {
    db := c.MustGet("DB").(*gorm.DB)
    username := c.Param("username")
    var userModel UserModel

    if err := db.Where(&UserModel{Username: username}).First(&userModel).Error; err != nil {
        c.JSON(http.StatusNotFound, common.NewError("profile",errors.New("Invalid username")))
        return
    }
    myUserModel := c.MustGet("my_user_model").(UserModel)
    var follow FollowModel
    db.Where(FollowModel{
        FollowingID: myUserModel.ID,
        FollowedByID: userModel.ID,
    }).First(&follow)
    res := userModel.getProfile()
    res.Following = follow.ID!=0
    c.JSON(http.StatusOK, gin.H{"profile": res})
}
func (r Router) ProfileFollow(c *gin.Context) {
    db := c.MustGet("DB").(*gorm.DB)
    username := c.Param("username")
    var userModel UserModel

    if err := db.Where(&UserModel{Username: username}).First(&userModel).Error; err != nil {
        c.JSON(http.StatusNotFound, common.NewError("profile",errors.New("Invalid username")))
        return
    }
    myUserModel := c.MustGet("my_user_model").(UserModel)
    follow := FollowModel{
        Following: myUserModel,
        FollowedBy: userModel,
    }
    db.Save(&follow)
    res := userModel.getProfile()
    res.Following = true
    c.JSON(http.StatusOK, gin.H{"profile": res})
}
func (r Router) ProfileUnfollow(c *gin.Context) {
    db := c.MustGet("DB").(*gorm.DB)
    username := c.Param("username")
    var userModel UserModel

    if err := db.Where(&UserModel{Username: username}).First(&userModel).Error; err != nil {
        c.JSON(http.StatusNotFound, common.NewError("profile",errors.New("Invalid username")))
        return
    }
    myUserModel := c.MustGet("my_user_model").(UserModel)

    db.Where(FollowModel{
        FollowingID: myUserModel.ID,
        FollowedByID: userModel.ID,
    }).Delete(FollowModel{})
    res := userModel.getProfile()
    res.Following = false
    c.JSON(http.StatusOK, gin.H{"profile": res})
}
```

hello.go 加入 `users.ProfileRegister(v1.Group("/profiles"))`

此时，这个 API 的功能部分已经完成，但是，发现代码变脏了，各种结构有点混乱。

## 重构
之前的结构是自己的想象，现在做如下的调整。
- common/utils.go
 - 封装一个工具包
- models.go
 - 我希望用它来处理数据库相关的东西，那么应该屏蔽和 request 相关的内容，不应该把`c *gin.Context`暴露给它，和 db 相关联的东西应该放在这里。
- validators.go
 - 我希望用它来处理用户数据验证相关的东西，理想情况是定好 schema 之后，自动校验和返回一个标准的错误集，自动适配不同的格式如 json/xml/proto，它应该屏蔽内部的存贮结构，也不应该关心和数据库存贮相关的数据【如 email 不能重复不应该由它管】。
- serializes.go
 - 我希望用它来处理返回值相关的东西，主要解决返回格式适配问题。
- routers.go
 - 我希望它来处理路由绑定相关的逻辑，业务和流程相关的大部分内容放在这个模块，它不应该关心具体的实现。
 

### 数据库连接池
之前的数据库连接池获取的位置是 router，现在把它弄成只有 model 能访问。

### 完工
写了一堆东西，重要把 postman 的一堆测试过了，具体代码在这里。
https://github.com/gothinkster/golang-gin-realworld-example-app/tree/0.0.1

最终有一个地方不符合预期，就是 go router 不支持按顺序一个个 match，是一个类似 hash 的方法。（不支持在 /foo/ 路由后面加一个新的路由 /foo/bar/，它会直接把后面这个 router 处理到前面去。）

