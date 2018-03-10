title: HTTP协议的最佳实践RESTful
author: 田_田
tags:
  - HTML
  - Best Practice
  - ''
categories: []
date: 2017-06-16 14:44:00
---
记录一下我学习 http 协议和 RESTful 最佳实践的学习过程。
<!-- more -->

> HTTP协议是Hyper Text Transfer Protocol（超文本传输协议）的缩写,是用于从万维网（WWW:World Wide Web ）服务器传输超文本到本地浏览器的传送协议。

换句话说，http 的表现是文本，所有的数据都通过文本来体现，各个控制传输的参数也是文本来提现。（ps：http2协议是二进制协议，但是核心思想没有变）

## 知识储备&预备
### what happens after enter url
首先要对整个 web 栈有一个理解，最典型的问题就是问自己，输入 url 到页面完整的完成，过程中发生了什么：
https://github.com/skyline75489/what-happens-when-zh_CN
### tcp 协议
http://www.jianshu.com/p/ef892323e68f
理解一下 http 为什么是可靠连接
### osi 七层协议
http://www.jianshu.com/p/4b9d43c0571a
我们主要是在应用层使用 http 协议

## http主要特点
基础知识在这：
http://www.jianshu.com/p/80e25cb1d81a

现在的 web 框架本质上是对 http 的Request && Response请求的封装。

### http 协议的Request和Response由哪几个部分组成？服务器和客户端如何相互确定需要的信息？
https://developer.mozilla.org/en-US/docs/Web/HTTP/Overview
#### Request
http methed，请求方法。可以使动词方法 GET, POST，或者名词OPTIONS or  HEAD，协议头。定义一次请求想干啥。 
- [常用 header](http://honglu.me/2015/07/13/%E5%BC%80%E5%8F%91%E4%B8%AD%E5%B8%B8%E7%94%A8%E7%9A%84HTTP-header/)，[常用 methed](https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods)
- header 的内容包括不限于缓存控制，语言，数据格式，用户身份认证等
- header 里的重点  [cookies](http://javascript.ruanyifeng.com/bom/cookie.html)，[缓存控制策略相关 header](http://www.cnblogs.com/xinzhao/p/5099807.html)，[CORS 跨域相关的 header](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Access_control_CORS)，注意[Accept](https://tools.ietf.org/html/rfc7231#section-5.3.2)和[Content-Type](http://honglu.me/2015/07/13/%E5%B8%B8%E7%94%A8%E7%9A%84%E5%87%A0%E7%A7%8DContent-Type/)的不同，一个是来一个是回。

Path of resource，资源路径。 定义和标识需要操作的资源。包括一个协议头、地址、端口等。
- 路径的的表示方法分为[url urn uri](http://web.jobbole.com/83452/)。
- 常用的[协议和端口](https://wsgzao.github.io/post/service-names-port-numbers/)

HTTP version，协议版本.
- [优雅的谈论http版本](http://www.jianshu.com/p/52d86558ca57)

Body，正文，比如 POST 请求，数据会放在 body 里。
- [常见的 POST 提交数据](https://imququ.com/post/four-ways-to-post-data-in-http.html)，`Content-Type`控制。

#### response
HTTP version，协议版本，同上。

Status code, 状态号，告知你请求是否成功，怎样成功或者失败。
- [状态码](http://www.runoob.com/http/http-status-codes.html)

Status message, 一段简单的文字状态描述。

HTTP headers,请求头，同上。
- header 进一步详细的的介绍可以看这个 [mozilla docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers) 
- 对 header 如果很熟悉就可以试着去玩一下 Nginx，有各种通过正则式改写 header 和 url 的技巧
- 写 header 可以完成某些转发、跨域、缓存、身份验证、文件下载等需求。

Body，应该返回的数据或者媒体资源文件。
- json 是 JavaScript 的经典数据描述，但是表示一个对象有更多的 [序列化和反序列化](http://www.infoq.com/cn/articles/serialization-and-deserialization) 工具。


### post 和 get 有什么区别？put 和 patch 有什么区别？

细节可以看这个[post&get对比](http://www.w3school.com.cn/tags/html_ref_httpmethods.asp)

post 和 get 设计上主要的区别是有没有幂等性，get执行一次和执行 n 次结果一样。符合范式的 get 应该是请求无数次后也不会改变服务器状态。其他的特性都是为了保障幂等性而做的限制：
- get 可以缓存，post 不能。因为执行 n 次对结果没有影响，那么只要记录一次，再执行 n 次结果也应该一样。
- get 只能 ASCII 字符编码，数据以 param 的形式被编码进URL，而且有长度限制，是为了对数据进行更好的标识，方便缓存等行为。而 post 可以提交的数据类型可以是 multipart/form-data 甚至是 file存贮在 body 中，数据不会被暴露在 url 里。url 在传输的时候是不会对 header 和 url 进行加密的。
- post 刷新之后数据会被重新提交，参数不会被保存在浏览器历史中，是为了防止 post被多次提交改变服务器状态。

patch 是新版 http 协议里支持的方法，在RESTful里面，put 是把应该对象完整的放到 uri，而 patch 是对一个对象的部分属性进行更新。举个例子：
服务器有对象 {a:1, b:2},
请求 PUT {a:2} 之后，服务器的对象变为{a:2}。
请求 PATCH {a:2} 之后，服务器的对象变为{a:2, b:2}

### http协议栈如何分层，更高一层使用了哪些技术。
[HTTP、TCP、UDP、Socket](http://blog.csdn.net/xijiaohuangcao/article/details/6105623)



## RESTful
### what？
#### origin
REST这个词，是Roy Thomas Fielding在他2000年的博士论文中提出的。

Fielding是一个非常重要的人，他是HTTP协议（1.0版和1.1版）的主要设计者、Apache服务器软件的作者之一、Apache基金会的第一任主席。所以，他的这篇论文一经发表，就引起了关注，并且立即对互联网开发产生了深远的影响。

论文中给了很多的建议，以至于这些建议很多都已经成为开源世界的默认标准。

#### define
REST，是Representational State Transfer的缩写。我对这个词组的翻译是"表现层状态转化"。如果一个架构符合REST原则，就称它为RESTful架构。

#### details
REST的名称"表现层状态转化"中，省略了主语。"表现层"其实指的是"资源"（Resources）的"表现层"。所谓"资源"，就是网络上的一个实体，或者说是网络上的一个具体信息，它可以是一段文本、一张图片、一首歌曲、一种服务。

所谓"上网"，就是与互联网上一系列的"资源"互动，然后 RESTful 现在定义了 一组能唯一标识资源的 path 和对资源进行的操作的一种规范，RESTful 架构的意思就是，满足与网上一系列资源互动的一组规范的架构。


### why？
#### scene
现在考虑这样的资源和操作，我们要分为两个不相关的步骤：

- 第一步，通过某些标识唯一指定某个资源
- 第二步，骤以及对这个资源进行操作，转换成我想要的样子。

#### define
前者叫做表现层RE（Representation），后者叫做状态转换ST（State Transfer）

具体来说，我要从服务器拿一段文本。可以用txt格式表现，也可以用HTML格式、XML格式、JSON格式表现，甚至可以采用二进制格式；它可以是不同的语言。
现在我们希望分成这两个要素 RE 和 ST

- RE: URI只代表资源的实体，不代表它的形式。比如网址最后的".html"后缀名是不必要的，因为这个后缀名表示格式，属于 ST 范畴，而 URI 应该只代表"资源"的位置。
- ST: 它的具体表现形式，应该在HTTP请求的头信息中用Accept和Content-Type字段指定，这两个字段才是对"表现层"的描述。它的语言应该在Accept-Language中指定


#### RESTful

互联网通信协议HTTP协议，是一个无状态协议。这意味着，所有的状态都保存在服务器端。因此，如果客户端想要操作服务器，必须通过某种手段，让服务器端发生"状态转化"（State Transfer）。而这种转化是建立在表现层之上的，所以就是"表现层状态转化"。

客户端用到的手段，只能是HTTP协议。具体来说，就是HTTP协议里面的操作方式动词：GET、POST、PUT、PATCH、DELETE。它们分别对应增删改查基本操作：GET用来获取资源，POST用来新建资源（也可以用于更新资源），PUT、PATCH用来更新资源，DELETE用来删除资源。

```
（1）每一个URI代表一种资源；
（2）客户端和服务器之间，传递这种资源的某种表现层；
（3）客户端通过HTTP动词，对服务器端资源进行操作，实现"表现层状态转化"。
```

### how?
#### basic
常见增删改查，注意下安全性和幂等性。
- 安全性：不会改变资源状态，可以理解为只读的；
- 幂等性：执行1次和执行N次，对资源状态改变的效果是等价的。

安全性和幂等性均不保证反复请求能拿到相同的response。以 DELETE 为例，第一次DELETE返回200表示删除成功，第二次返回404提示资源不存在，这是允许的。
```
GET /zoos：列出所有动物园
POST /zoos：新建一个动物园
GET /zoos/ID：获取某个指定动物园的信息
PUT /zoos/ID：更新某个指定动物园的信息（提供该动物园的全部信息）
PATCH /zoos/ID：更新某个指定动物园的信息（提供该动物园的部分信息）
DELETE /zoos/ID：删除某个动物园
GET /zoos/ID/animals：列出某个指定动物园的所有动物
DELETE /zoos/ID/animals/ID：删除某个指定动物园的指定动物
```
#### common
花式GET，并且所有请求都是可以缓存的，在浏览器，nginx，服务端代码里都应该可以缓存。
```
GET /zoos
GET /zoos/1
GET /zoos/1/employees     //为id为1的动物园雇佣员工
GET /zoos?type=1&age=16	  //允许一定的uri冗余，如/zoos/1与/zoos?id=1
GET /zoos?sort=age,desc	  //age 第一参数，desc 第二参数排序
GET /zoos?whitelist=email //指定额外参数
GET /zoos?whitelist=id1,id2 //指定额外参数
GET /zoos?limit=10&offset=3  //分页器
```
花式POST：创建单个资源。POST一般向“资源集合”型uri发起
```
POST /animals  //新增动物
POST /zoos/1/employees //为id为1的动物园加入雇佣员工
```
花式PUT：更新单个资源（全量），客户端提供完整的更新后的资源。与之对应的是 PATCH，PATCH 负责部分更新，客户端提供要更新的那些字段。PUT/PATCH一般向“单个资源”型uri发起
```
PUT /animals/1
PUT /zoos/1
```
花式DELETE
```
DELETE /zoos/1/employees/2
DELETE /zoos/1/employees/2;4;5  //花式删除关系，一般这种 url 代表关系，不一定要Delete雇员对象，这个可以自己定。
DELETE /zoos/1/animals  //删除id为1的动物园内的所有动物
```
HEAD / OPTION 作为简单请求，在 RESTful 不重要，毕竟，RESTful 可以方便的一键生成单个资源的 CRUD，快速的生成资源之间的相互 join。
#### more
- API的身份认证应该使用OAuth框架，增加一个 login、logout 接口，使用 token 来确认身份。

- Hypermedia API
```
//RESTful API最好做到Hypermedia，即返回结果中提供链接，连向其他API方法，使得用户不查文档，也知道下一步应该做什么。
//比如 angular ember react-redux 都对标准的 RESTful 有一定支持，而且倾向于拿单个的对象，然后每个对象单独更新，这样每个对象都容易更新。
//在某些情况下可以把下面 zoos 对应的 url 换成一个 list，tiger 换成一个 object，框架很容易完成这件事。
{
  "zoos":  "https://api.example.com/zoos",
  "tiger":  "https://api.example.com/zoos/1",
  "title": "List of zoos",
}
```

- 服务的 URL 设计
服务应该使用名词，比如计算应该使用calculation，不应该使用calc或者calculate。

```
//应该根据幂等性来使用GET 和 Post，典型的就是一个函数式计算任务和一个队列提交任务。
GET /distance-calculation?lats=47.480&lngs=-122.389&late=37.108&lnge=-122.448

POST /tasks
[{"from":0,"to":1,"text":"abc"},{},{}...]
```

设计的时候应该要保证服务可以单独部署，对多个资源操作的事务由单独部署的服务来管理。



- 各HTTP方法成功处理后Response的数据格式：
```
response	格式
GET			单个对象、集合
POST		新增成功的对象
PUT/PATCH	更新成功的对象
DELETE		空, 通过状态码确认
```

- json格式的约定：
  时间用长整形(毫秒数)
- URI规范
```
不用大写；
用中杠-不用下杠_；
参数列表要encode；
URI中的名词表示资源集合，使用复数形式。
```

- 避免层级过深的URI
一般根据id导航。过深的导航容易导致url膨胀，不易维护。尽量使用查询参数代替路径中的实体导航。 
```
相对不好的设计
GET /zoos/1/areas/3/animals/4
相对好的设计
GET /animals?zoo=1&area=3；
```


- 对Composite资源的访问
```
它的生命周期完全依赖父实体，无法独立存在，不直接对应表，也无id。服务器端的组合实体必须在uri中通过父实体的id导航访问。一个常见的例子是 User — Address，Address是对User表中zipCode/country/city三个字段的简单抽象，无法独立于User存在。必须通过User索引到Address：GET /user/1/addresses
```

- URI失效
应该添加301到新地址，或者有一个错误提示。

- 版本
GITHUB 的处理方式是这样的：
```
https://api.example.com/v1/
```

- 不要瞎JB搞，乱包东西很丑
```
//H5前端工程师非常讨厌这种搞法，开源世界的库都不能愉快的使用。
{
    "success":true,
    "data":{"id":1,"name":"xiaotuan"},
}
```

### So what?
正如前文所说，RESTful 几乎是开源世界里非rpc调用最通用的接口。很多的开源 web 框架都有对应的 RESTful 库类，可以用极少量的配置完成对对象的序列化。

典型的如 Django的django-restful-framework，100行代码可以完成一个支持邮件收发、注册改密码、身份验证、序列化反序列化、数据 schema，持久化增删改查等的 todoMVC项目。

符合规范可以可以极大的提高开发效率！